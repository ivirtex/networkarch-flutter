// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_error.dart';
import 'package:adapty_flutter/models/adapty_paywall.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared.dart';

class PremiumBottomSheetBody extends StatefulWidget {
  const PremiumBottomSheetBody({Key? key}) : super(key: key);

  @override
  State<PremiumBottomSheetBody> createState() => _PremiumBottomSheetBodyState();
}

class _PremiumBottomSheetBodyState extends State<PremiumBottomSheetBody> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();

    RewardedAd.load(
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
                ElevatedButton(
                  onPressed: () => _handleSubscribe(context),
                  child: const Text('Subscribe'),
                ),
                const SizedBox(width: Constants.listSpacing),
                ElevatedButton(
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

  Future<void> _handleSubscribe(BuildContext context) async {
    AdaptyPaywall? paywall;

    try {
      final paywallResult = await Adapty.getPaywalls();
      final paywalls = paywallResult.paywalls;

      paywall = paywalls?.first;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    final product = paywall?.products?.first;

    if (product != null) {
      try {
        final result = await Adapty.makePurchase(product);

        if (result.purchaserInfo?.accessLevels['premium']?.isActive ?? false) {
          await Hive.box('iap').put('isPremiumGranted', true);

          if (!mounted) return;
          Navigator.pop(context);
        }
      } on AdaptyError catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void _handleWatchAd(BuildContext context) {
    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) async {
        if (kDebugMode) {
          print('User earned reward $reward');
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
                Column(
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
