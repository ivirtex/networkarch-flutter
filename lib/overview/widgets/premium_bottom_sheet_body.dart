// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_paywall.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/network_status/widgets/adaptive_button.dart';
import 'package:network_arch/shared/shared.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    hide PlatformWidget;

class PremiumBottomSheetBody extends StatefulWidget {
  const PremiumBottomSheetBody({
    required this.rewardedAd,
    required this.isRewardedAdReady,
    required this.paywall,
    super.key,
  });

  final RewardedAd? rewardedAd;
  final bool isRewardedAdReady;
  final AdaptyPaywall? paywall;

  @override
  State<PremiumBottomSheetBody> createState() => _PremiumBottomSheetBodyState();
}

class _PremiumBottomSheetBodyState extends State<PremiumBottomSheetBody> {
  bool _isPurchasing = false;

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
                  AdaptiveButton.filled(
                    child: const Text('Subscribe'),
                    onPressed: () => _handleSubscribe(context),
                  ),
                  const SizedBox(width: Constants.listSpacing),
                  AdaptiveButton(
                    onPressed: widget.isRewardedAdReady
                        ? () => _handleWatchAd(context)
                        : null,
                    child: widget.isRewardedAdReady
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
        onPressedOnLastPage:
            widget.paywall != null ? () => _handleSubscribe(context) : null,
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
          onPressed:
              widget.isRewardedAdReady ? () => _handleWatchAd(context) : null,
          child: widget.isRewardedAdReady
              ? const Text('Watch ad')
              : const Text('Loading ad'),
        ),
        pages: [
          WhatsNewPage(
            title: const Text('Help to maintain our servers'),
            titleToBodySpacing: 20,
            titleTopIndent: 40,
            features: [
              if (widget.paywall != null)
                Text(
                  'Subscribe for ${widget.paywall?.products?.first.localizedPrice} per ${widget.paywall?.products?.first.localizedSubscriptionPeriod} and get unlimited access to the following features:',
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

  Future<void> _handleSubscribe(BuildContext context) async {
    final product = widget.paywall?.products?.first;

    if (product != null) {
      setState(() {
        _isPurchasing = true;
      });

      try {
        final makePurchaseResult = await Adapty.makePurchase(product);

        if (makePurchaseResult
                .purchaserInfo?.accessLevels['premium']?.isActive ??
            false) {
          await Hive.box<bool>('iap').put('isPremiumGranted', true);

          setState(() {
            _isPurchasing = false;
          });

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
      } catch (e) {
        if (kDebugMode) {
          print('Failed to make purchase: $e');
        }

        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  void _handleWatchAd(BuildContext context) {
    widget.rewardedAd?.show(
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
