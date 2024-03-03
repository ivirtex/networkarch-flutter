// ignore_for_file: use_build_context_synchronously

// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/shared/shared.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    hide PlatformWidget;

class PremiumBottomSheetBody extends StatefulWidget {
  const PremiumBottomSheetBody({
    required this.paywall,
    super.key,
  });

  final AdaptyPaywall? paywall;

  @override
  State<PremiumBottomSheetBody> createState() => _PremiumBottomSheetBodyState();
}

class _PremiumBottomSheetBodyState extends State<PremiumBottomSheetBody> {
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  bool _isPurchasing = false;

  List<AdaptyPaywallProduct>? products;

  @override
  void initState() {
    super.initState();

    _setUpAdsForPaywall();
    if (widget.paywall != null) {
      Adapty().logShowPaywall(paywall: widget.paywall!);

      fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    products = await Adapty().getPaywallProducts(paywall: widget.paywall!);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => SafeArea(
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
                  AdaptiveButton.filled(
                    onPressed: _handleSubscribe,
                    child: const Text('Subscribe'),
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
      iosBuilder: (context) => CupertinoOnboarding(
        onPressedOnLastPage: widget.paywall != null ? _handleSubscribe : null,
        bottomButtonColor: _isPurchasing
            ? CupertinoColors.quaternarySystemFill.resolveFrom(context)
            : null,
        bottomButtonChild: _isPurchasing
            ? const SizedBox(
                // Maintain same height in both widgets.
                height: 19,
                child: CupertinoActivityIndicator(),
              )
            : const Text('Subscribe'),
        widgetAboveBottomButton: CupertinoButton(
          onPressed: _isRewardedAdReady ? () => _handleWatchAd(context) : null,
          child: _isRewardedAdReady
              ? const Text('Watch ad')
              : const Text('Loading ad'),
        ),
        pages: [
          WhatsNewPage(
            title: const Text('Help to maintain our servers'),
            titleToBodySpacing: 20,
            titleTopIndent: 40,
            features: [
              if (products != null)
                Text(
                  'Subscribe for ${products?.first.price} per ${products?.first.subscriptionDetails?.subscriptionPeriod} and get unlimited access to the following features:',
                )
              else
                const Text(
                  'Subscribe and get unlimited access to the following features:',
                ),
              const WhatsNewFeature(
                title: Text('IP Geolocation'),
                description: Text(Constants.ipGeoDesc),
                icon: Icon(CupertinoIcons.location),
              ),
              const WhatsNewFeature(
                title: Text('Whois'),
                description: Text(Constants.whoisDesc),
                icon: Icon(CupertinoIcons.info),
              ),
              const WhatsNewFeature(
                title: Text('DNS Lookup'),
                description: Text(Constants.dnsDesc),
                icon: Icon(CupertinoIcons.search),
              ),
              const WhatsNewFeature(
                title: Text('No ads'),
                description: Text('No ads, no distractions.'),
                icon: Icon(CupertinoIcons.device_phone_portrait),
              ),
              Row(
                children: [
                  CupertinoButton(
                    onPressed: _openPrivacyPolicy,
                    child: const Text('Privacy Policy'),
                  ),
                  CupertinoButton(
                    onPressed: _openTermsOfUse,
                    child: const Text('Terms of Use'),
                  ),
                ],
              ),
              const Text(
                'Or watch a short ad to get one-time access to these tools.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe() async {
    final product = products?.first;

    setState(() {
      _isPurchasing = true;
    });

    AdaptyProfile? adaptyProfile;

    try {
      adaptyProfile = await Adapty().makePurchase(product: product!);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to make purchase: $e');
      }
    }

    setState(() {
      _isPurchasing = false;
    });

    if (adaptyProfile?.accessLevels['premium']?.isActive ?? false) {
      await Hive.box<bool>('iap').put('isPremiumGranted', true);

      await showPlatformDialog<void>(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: const Text('Success'),
          content: const Text('Thank you for your purchase! :)'),
          actions: [
            PlatformDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pop(context);
    }
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

  Future<void> _openPrivacyPolicy() async {
    if (!await launchUrl(Uri.parse(Constants.privacyPolicyURL))) {
      throw Exception('Could not launch URL');
    }
  }

  Future<void> _openTermsOfUse() async {
    if (!await launchUrl(Uri.parse(Constants.termsOfUseURL))) {
      throw Exception('Could not launch URL');
    }
  }

  Future<void> _setUpAdsForPaywall() async {
    await RewardedAd.load(
      adUnitId: _getPremiumAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: _onAdFailedToLoad,
      ),
    );
  }

  String _getPremiumAdUnitId() {
    return kReleaseMode
        ? Platform.isIOS
            ? Constants.premiumAccessIOSAdUnitId
            : Constants.premiumAccessAndroidAdUnitId
        : Constants.testRewardedAdUnitId;
  }

  void _onAdFailedToLoad(LoadAdError err) {
    if (kDebugMode) {
      print('Failed to load a rewarded ad: ${err.message}');
    }

    setState(() {
      _isRewardedAdReady = false;
    });
  }
}
