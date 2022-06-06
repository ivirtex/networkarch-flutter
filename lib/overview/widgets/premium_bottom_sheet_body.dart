// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/utils/in_app_purchases.dart';

class PremiumBottomSheetBody extends StatefulWidget {
  const PremiumBottomSheetBody({Key? key}) : super(key: key);

  @override
  State<PremiumBottomSheetBody> createState() => _PremiumBottomSheetBodyState();
}

class _PremiumBottomSheetBodyState extends State<PremiumBottomSheetBody> {
  Future<bool> isIapAvailableFuture = InAppPurchase.instance.isAvailable();
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();

    _setUpAds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            Text(
              'Help to maintain our servers',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 22.0),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Subscribe and get unlimited access to the following features:',
                style: Theme.of(context).textTheme.labelLarge,
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
              subtitle: 'No ads, no distractions',
              icon: Icons.ad_units_rounded,
            ),
            const SizedBox(height: Constants.listSpacing),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Or watch a short ad to get one-time access to these tools.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: Constants.listSpacing),
            Row(
              children: [
                const Spacer(),
                FutureBuilder(
                  future: isIapAvailableFuture,
                  builder: (context, AsyncSnapshot<bool> isIapAvailable) {
                    if (isIapAvailable.connectionState ==
                        ConnectionState.waiting) {
                      return const ListCircularProgressIndicator();
                    }

                    if (isIapAvailable.hasError) {
                      return AdaptiveButton.filled(
                        child: const Text('Subscribe'),
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
                  onPressed: () => _handleWatchAd(context),
                  child: const Text('Watch ad'),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setUpAds() async {
    await RewardedAd.load(
      adUnitId: getPremiumAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (kDebugMode) {
            print('$ad loaded.');
          }

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('RewardedAd failed to load: $error');
          }
        },
      ),
    );
  }

  Future<void> _handleSubscribe(BuildContext context) async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(kProductIds);

    final List<ProductDetails> products = response.productDetails;

    InAppPurchase.instance.buyNonConsumable(
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

        await Hive.box('iap').put('isPremiumTempGranted', true);

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
    Key? key,
  }) : super(key: key);

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
            padding: const EdgeInsets.all(10.0),
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10.0),
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
