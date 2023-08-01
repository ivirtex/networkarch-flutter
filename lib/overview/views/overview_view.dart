// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/bloc/bloc.dart';
import 'package:network_arch/network_status/views/views.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/permissions/message_type.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/utils.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  late final BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  late bool _isPremiumGranted;
  late bool _isPremiumTempGranted;

  bool get _isPremiumAvail => _isPremiumGranted || _isPremiumTempGranted;

  AdaptyPaywall? _paywall;

  @override
  void initState() {
    super.initState();

    if (Hive.box<bool>('settings')
        .get('hasIntroductionBeenShown', defaultValue: false)!) {
      Permission.location.isGranted.then((bool isGranted) {
        if (!isGranted) {
          showPlatformMessage(context, type: MessageType.denied);
        }
      });
    }

    context.read<NetworkStatusBloc>().add(NetworkStatusStreamStarted());
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());

    _bannerAd = BannerAd(
      adUnitId: getAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }

          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();

    _setUpIapAndListenForChanges();
    _setupIapPaywall();
  }

  @override
  void dispose() {
    super.dispose();

    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Overview'),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
      builder: (context, state) {
        return ContentListView(
          children: [
            PlatformWidget(
              androidBuilder: (context) {
                return Column(
                  children: [
                    const SmallDescription(
                      text: 'Networks',
                      leftPadding: 8,
                    ),
                    const WifiStatusCard(),
                    const SizedBox(height: Constants.listSpacing),
                    const CarrierStatusCard(),
                    const SizedBox(height: Constants.listSpacing),
                    const SmallDescription(
                      text: 'Utilities',
                      leftPadding: 8,
                    ),
                    ToolCard(
                      toolName: 'Ping',
                      toolDesc: Constants.pingDesc,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/tools/ping',
                        arguments: '',
                      ),
                    ),
                    const SizedBox(height: Constants.listSpacing),
                    ToolCard(
                      toolName: 'LAN Scanner',
                      toolDesc: Constants.lanScannerDesc,
                      onPressed: state.isWifiConnected
                          ? () => Navigator.pushNamed(context, '/tools/lan')
                          : null,
                    ),
                    const SizedBox(height: Constants.listSpacing),
                    ToolCard(
                      toolName: 'Wake On LAN',
                      toolDesc: Constants.wolDesc,
                      onPressed: state.isWifiConnected
                          ? () => Navigator.pushNamed(context, '/tools/wol')
                          : null,
                    ),
                    const SizedBox(height: Constants.listSpacing),
                    ToolCard(
                      toolName: 'IP Geolocation',
                      toolDesc: Constants.ipGeoDesc,
                      isPremium: !_isPremiumAvail,
                      onPressed: _isPremiumAvail
                          ? () => Navigator.pushNamed(context, '/tools/ip_geo')
                          : () => showPremiumBottomSheet(context),
                    ),
                    const SizedBox(height: Constants.listSpacing),
                    ToolCard(
                      toolName: 'Whois',
                      toolDesc: Constants.whoisDesc,
                      isPremium: !_isPremiumAvail,
                      onPressed: _isPremiumAvail
                          ? () => Navigator.pushNamed(context, '/tools/whois')
                          : () => showPremiumBottomSheet(context),
                    ),
                    const SizedBox(height: Constants.listSpacing),
                    ToolCard(
                      toolName: 'DNS Lookup',
                      toolDesc: Constants.dnsDesc,
                      isPremium: !_isPremiumAvail,
                      onPressed: _isPremiumAvail
                          ? () => Navigator.pushNamed(
                                context,
                                '/tools/dns_lookup',
                              )
                          : () => showPremiumBottomSheet(context),
                    ),
                    const SizedBox(height: Constants.listSpacing),
                    if (kDebugMode) const DebugSection(),
                    if (!_isPremiumGranted && _isBannerAdReady)
                      Container(
                        alignment: Alignment.center,
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                  ],
                );
              },
              iosBuilder: (context) {
                return Column(
                  children: [
                    const WifiStatusCard(),
                    const CarrierStatusCard(),
                    CupertinoListSection.insetGrouped(
                      hasLeading: false,
                      header: const Text('Utilities'),
                      children: [
                        ToolCard(
                          toolName: 'Ping',
                          toolDesc: Constants.pingDesc,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/tools/ping',
                            arguments: '',
                          ),
                        ),
                        //! lan_scanner not supported on iOS yet
                        // ToolCard(
                        //   toolName: 'LAN Scanner',
                        //   toolDesc: Constants.lanScannerDesc,
                        //   onPressed: state.isWifiConnected
                        //       ? () => Navigator.pushNamed(context, '/tools/lan')
                        //       : null,
                        // ),
                        ToolCard(
                          toolName: 'Wake on LAN',
                          toolDesc: Constants.wolDesc,
                          onPressed: state.isWifiConnected
                              ? () => Navigator.pushNamed(context, '/tools/wol')
                              : null,
                        ),
                        ToolCard(
                          toolName: 'IP Geolocation',
                          toolDesc: Constants.ipGeoDesc,
                          isPremium: !_isPremiumAvail,
                          onPressed: _isPremiumAvail
                              ? () => Navigator.pushNamed(
                                    context,
                                    '/tools/ip_geo',
                                  )
                              : () => showPremiumBottomSheet(context),
                        ),
                        ToolCard(
                          toolName: 'Whois',
                          toolDesc: Constants.whoisDesc,
                          isPremium: !_isPremiumAvail,
                          onPressed: _isPremiumAvail
                              ? () => Navigator.pushNamed(
                                    context,
                                    '/tools/whois',
                                  )
                              : () => showPremiumBottomSheet(context),
                        ),
                        ToolCard(
                          toolName: 'DNS Lookup',
                          toolDesc: Constants.dnsDesc,
                          isPremium: !_isPremiumAvail,
                          onPressed: _isPremiumAvail
                              ? () => Navigator.pushNamed(
                                    context,
                                    '/tools/dns_lookup',
                                  )
                              : () => showPremiumBottomSheet(context),
                        ),
                      ],
                    ),
                    if (kDebugMode) const DebugSection(),
                    if (!_isPremiumGranted && _isBannerAdReady)
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: _bannerAd.size.width.toDouble(),
                            height: _bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          ),
                          const SizedBox(height: Constants.listSpacing),
                        ],
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showPremiumBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.platform == TargetPlatform.iOS) {
      showCupertinoModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        builder: (_) => PremiumBottomSheetBody(
          paywall: _paywall,
        ),
      );
    } else {
      showMaterialModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        builder: (_) => PremiumBottomSheetBody(
          paywall: _paywall,
        ),
      );
    }
  }

  void _setUpIapAndListenForChanges() {
    final iapBox = Hive.box<bool>('iap');

    // Grants premium when debug or profile mode is enabled
    _isPremiumGranted = iapBox.get(
      'isPremiumGranted',
      defaultValue: kDebugMode || kProfileMode,
    )!;
    _isPremiumTempGranted =
        iapBox.get('isPremiumTempGranted', defaultValue: false)!;

    iapBox.watch(key: 'isPremiumGranted').listen((event) {
      setState(() {
        _isPremiumGranted = event.value as bool;
      });
    });
    iapBox.watch(key: 'isPremiumTempGranted').listen((event) {
      setState(() {
        _isPremiumTempGranted = event.value as bool;
      });
    });
  }

  Future<void> _setupIapPaywall() async {
    try {
      _paywall = await Adapty().getPaywall(id: 'premium_paywall');
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get paywalls: $e');
      }

      unawaited(Sentry.captureException(e));
    }
  }
}
