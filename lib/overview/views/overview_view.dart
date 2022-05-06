// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/bloc/bloc.dart';
import 'package:network_arch/network_status/views/views.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/utils.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({Key? key}) : super(key: key);

  @override
  _OverviewViewState createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final BannerAd banner = BannerAd(
    adUnitId: getAdUnitId(),
    size: AdSize.banner,
    request: const AdRequest(),
    listener: listener,
  );

  late bool isPremiumGranted;
  late bool isPremiumTempGranted;

  bool get isPremiumAvail => isPremiumGranted || isPremiumTempGranted;

  @override
  void initState() {
    super.initState();

    Permission.location.isGranted.then((bool isGranted) {
      if (!isGranted) {
        showElegantNotification(
          context,
          Constants.permissionDeniedNotification,
        );
      }
    });

    context.read<NetworkStatusBloc>().add(NetworkStatusStreamStarted());
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());

    banner.load();

    final iapBox = Hive.box('iap');

    isPremiumGranted =
        iapBox.get('isPremiumGranted', defaultValue: false)! as bool;
    isPremiumTempGranted =
        iapBox.get('isPremiumTempGranted', defaultValue: false)! as bool;

    iapBox.watch(key: 'isPremiumGranted').listen((event) {
      setState(() {
        isPremiumGranted = event.value as bool;
      });
    });
    iapBox.watch(key: 'isPremiumTempGranted').listen((event) {
      setState(() {
        isPremiumTempGranted = event.value as bool;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    banner.dispose();
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

  CupertinoPageScaffold _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text('Overview'),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: banner);

    return BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
      builder: (context, state) {
        return ContentListView(
          children: [
            const SmallDescription(child: 'Networks', leftPadding: 8.0),
            const WifiStatusCard(),
            const SizedBox(height: Constants.listSpacing),
            const CarrierStatusCard(),
            const SizedBox(height: Constants.listSpacing),
            const SmallDescription(child: 'Utilities', leftPadding: 8.0),
            ToolCard(
              toolName: 'Ping',
              toolDesc: Constants.pingDesc,
              onPressed: () =>
                  Navigator.pushNamed(context, '/tools/ping', arguments: ''),
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
              isPremium: !isPremiumAvail,
              onPressed: isPremiumAvail
                  ? () => Navigator.pushNamed(context, '/tools/ip_geo')
                  : () => showPremiumBottomSheet(context),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Whois',
              toolDesc: Constants.whoisDesc,
              isPremium: !isPremiumAvail,
              onPressed: isPremiumAvail
                  ? () => Navigator.pushNamed(context, '/tools/whois')
                  : () => showPremiumBottomSheet(context),
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'DNS Lookup',
              toolDesc: Constants.dnsDesc,
              isPremium: !isPremiumAvail,
              onPressed: isPremiumAvail
                  ? () => Navigator.pushNamed(context, '/tools/dns_lookup')
                  : () => showPremiumBottomSheet(context),
            ),
            const SizedBox(height: Constants.listSpacing),
            if (kDebugMode)
              Column(
                children: [
                  ToolCard(
                    toolName: 'Clear IAP data',
                    toolDesc: '',
                    onPressed: () async {
                      await Hive.box('iap').put('isPremiumGranted', false);
                    },
                  ),
                  const SizedBox(height: Constants.listSpacing),
                  ToolCard(
                    toolName: 'Show success notif',
                    toolDesc: '',
                    onPressed: () {
                      showElegantNotification(
                        context,
                        Constants.permissionGrantedNotification,
                      );
                    },
                  ),
                  const SizedBox(height: Constants.listSpacing),
                  ToolCard(
                    toolName: 'Show failure notif',
                    toolDesc: '',
                    onPressed: () {
                      showElegantNotification(
                        context,
                        Constants.permissionDeniedNotification,
                      );
                    },
                  ),
                  const SizedBox(height: Constants.listSpacing),
                ],
              ),
            if (!isPremiumGranted)
              Container(
                alignment: Alignment.center,
                width: banner.size.width.toDouble(),
                height: banner.size.height.toDouble(),
                child: adWidget,
              ),
          ],
        );
      },
    );
  }

  void showPremiumBottomSheet(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => const PremiumBottomSheetBody(),
      );
    } else {
      showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Color.alphaBlend(
          Theme.of(context).colorScheme.primary.withOpacity(0.03),
          Theme.of(context).colorScheme.surfaceVariant,
        ),
        builder: (context) => const PremiumBottomSheetBody(),
      );
    }
  }
}

String getAdUnitId() {
  return kReleaseMode
      ? Platform.isIOS
          ? Constants.overviewIOSAdUnitId
          : Constants.overviewAndroidAdUnitId
      : Constants.testBannerAdUnitId;
}
