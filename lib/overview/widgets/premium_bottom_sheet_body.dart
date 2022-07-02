// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/in_app_purchases.dart';

// Package imports:
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    hide PlatformWidget;


class PremiumBottomSheetBody extends StatefulWidget {
  const PremiumBottomSheetBody({super.key});

  @override
  State<PremiumBottomSheetBody> createState() => _PremiumBottomSheetBodyState();
}

class _PremiumBottomSheetBodyState extends State<PremiumBottomSheetBody> {
  late Future<bool> isIapAvailableFuture;

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  @override
  void initState() {
    super.initState();

    _setUpAds();
    isIapAvailableFuture = InAppPurchase.instance.isAvailable();
  }

  @override
  void dispose() {
    super.dispose();

    _rewardedAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Text(
                'Help to maintain our servers',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Subscribe and get unlimited access to the following features:',
                ),
              ),
              const SizedBox(height: Constants.listSpacing),
              const AdvantageCard(
                title: 'IP Geolocation',
                subtitle: Constants.ipGeoDesc,
                icon: Icons.location_on_rounded,
              ),
              const SizedBox(height: Constants.listSpacing),
              const AdvantageCard(
                title: 'Whois',
                subtitle: Constants.whoisDesc,
                icon: Icons.info_rounded,
              ),
              const SizedBox(height: Constants.listSpacing),
              const AdvantageCard(
                title: 'DNS Lookup',
                subtitle: Constants.dnsDesc,
                icon: Icons.search_rounded,
              ),
              const SizedBox(height: Constants.listSpacing),
              const AdvantageCard(
                title: 'No ads',
                subtitle: 'No ads, no distractions.',
                icon: Icons.ad_units_rounded,
              ),
              const SizedBox(height: Constants.listSpacing),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Or watch a short ad to get one-time access to these tools.',
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  FutureBuilder(
                    future: isIapAvailableFuture,
                    builder: (context, AsyncSnapshot<bool> isIapAvailable) {
                      if (isIapAvailable.connectionState ==
                          ConnectionState.waiting) {
                        return const ListCircularProgressIndicator();
                      }

                      if (isIapAvailable.hasError) {
                        return AdaptiveButton.filled(
                          child: const Text('Error'),
                        );
                      }

                      return AdaptiveButton.filled(
                        onPressed: isIapAvailable.data!
                            ? () => _handleSubscribe(context)
                            : null,
                        child: const Text('Subscribe'),
                      );
                    },
                  ),
                  const SizedBox(width: Constants.listSpacing),
                  AdaptiveButton(
                    onPressed: _isRewardedAdReady
                        ? () => _handleWatchAd(context)
                        : null,
                    child: _isRewardedAdReady
                        ? const Text('Watch ad')
                        : const Text('Loading ad'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      iosBuilder: (_) => CupertinoOnboarding(
        onPressedOnLastPage: () => _handleSubscribe(context),
        bottomButtonChild: const Text('Subscribe'),
        widgetAboveBottomButton: CupertinoButton(
          onPressed: _isRewardedAdReady ? () => _handleWatchAd(context) : null,
          child: _isRewardedAdReady
              ? const Text('Watch ad')
              : const Text('Loading ad'),
        ),
        pages: [
          WhatsNewPage(
            title: const Text('Help to maintain our servers'),
            features: const [
              WhatsNewFeature(
                title: Text('IP Geolocation'),
                description: Text(Constants.ipGeoDesc),
                icon: Icon(CupertinoIcons.location),
              ),
              WhatsNewFeature(
                title: Text('Whois'),
                description: Text(Constants.whoisDesc),
                icon: Icon(CupertinoIcons.info),
              ),
              WhatsNewFeature(
                title: Text('DNS Lookup'),
                description: Text(Constants.dnsDesc),
                icon: Icon(CupertinoIcons.search),
              ),
              WhatsNewFeature(
                title: Text('No ads'),
                description: Text('No ads, no distractions.'),
                icon: Icon(CupertinoIcons.device_phone_portrait),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _setUpAds() async {
    await RewardedAd.load(
      adUnitId: getPremiumAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          if (kDebugMode) {
            print('Failed to load a rewarded ad: ${err.message}');
          }

          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  Future<void> _handleSubscribe(BuildContext context) async {
    final response =
        await InAppPurchase.instance.queryProductDetails(kProductIds);

    final products = response.productDetails;

    if (response.notFoundIDs.isNotEmpty) {
      await showPlatformDialog<void>(
        context: context,
        builder: (context) {
          return PlatformAlertDialog(
            title: const Text('Error'),
            content: const Text('There was an error during the purchase.'),
            actions: [
              PlatformDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );

      return;
    }

    await InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: products.first,
      ),
    );
  }

  void _handleWatchAd(BuildContext context) {
    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) async {
        if (kDebugMode) {
          print('User earned reward ${reward.type}');
        }

        await Hive.box<bool>('iap').put('isPremiumTempGranted', true);

        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }
}

class AdvantageCard extends StatelessWidget {
  const AdvantageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DataCard(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                Icon(
                  icon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String getPremiumAdUnitId() {
  return kReleaseMode
      ? Platform.isIOS
          ? Constants.premiumAccessIOSAdUnitId
          : Constants.premiumAccessAndroidAdUnitId
      : Constants.testRewardedAdUnitId;
}
