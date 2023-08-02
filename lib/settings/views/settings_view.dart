// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/package_info/package_info.dart';
import 'package:network_arch/settings/widgets/android_theme_switcher.dart';
import 'package:network_arch/settings/widgets/ios_theme_switcher.dart';
import 'package:network_arch/shared/shared.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    hide PlatformWidget;

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _canLaunchUrl = true;

  bool _arePurchasesRestoring = false;

  @override
  void initState() {
    super.initState();

    context.read<PackageInfoCubit>().fetchPackageInfo();
    canLaunchUrl(Uri.parse(Constants.sourceCodeURL))
        .then((canLaunch) => _canLaunchUrl = canLaunch);
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
      largeTitle: const Text('Settings'),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ContentListView(
      children: [
        PlatformWidget(
          androidBuilder: (context) {
            return Column(
              children: [
                const AndroidThemeSwitcher(),
                const SmallDescription(text: 'Help'),
                ActionCard(
                  title: 'Restore purchases',
                  desc: 'Restore purchases made in the past',
                  icon: const FaIcon(Icons.workspace_premium_rounded),
                  onTap: _restorePurchases,
                ),
                const SizedBox(height: Constants.listSpacing),
                ActionCard(
                  title: 'Onboarding screen',
                  desc: 'Resolve permissions issues',
                  icon: const FaIcon(Icons.info_outline_rounded),
                  onTap: () => Hive.box<bool>('settings')
                      .put('hasIntroductionBeenShown', false),
                ),
                const SizedBox(height: Constants.listSpacing),
                ActionCard(
                  title: 'Send feedback',
                  desc: 'Something is not working?',
                  icon: const FaIcon(Icons.feedback_outlined),
                  onTap: () => _sendFeedback(context),
                ),
                const SizedBox(height: Constants.listSpacing),
                ActionCard(
                  title: 'Source code',
                  desc: 'Feel free to contribute!',
                  icon: const FaIcon(FontAwesomeIcons.github),
                  onTap: _canLaunchUrl ? _openSourceCode : null,
                ),
                const SizedBox(height: Constants.listSpacing),
              ],
            );
          },
          iosBuilder: (context) {
            return Column(
              children: [
                CupertinoListSection.insetGrouped(
                  header: const Text('Theme'),
                  children: const [
                    CupertinoListTile.notched(
                      leading: Icon(CupertinoIcons.sun_max),
                      title: IosThemeSwitcher(),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('Help'),
                  children: [
                    ActionCard(
                      title: 'Restore purchases',
                      desc: 'Restore purchases made in the past',
                      icon: const FaIcon(CupertinoIcons.shopping_cart),
                      cupertinoTrailing: _arePurchasesRestoring
                          ? const CupertinoActivityIndicator()
                          : const CupertinoListTileChevron(),
                      onTap: _arePurchasesRestoring ? null : _restorePurchases,
                    ),
                    ActionCard(
                      title: 'Onboarding screen',
                      desc: 'Resolve permissions issues',
                      icon: const FaIcon(CupertinoIcons.info),
                      onTap: () => Hive.box<bool>('settings')
                          .put('hasIntroductionBeenShown', false),
                    ),
                    ActionCard(
                      title: 'Source code',
                      desc: 'Feel free to contribute!',
                      icon: const FaIcon(FontAwesomeIcons.github),
                      onTap: _canLaunchUrl ? _openSourceCode : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        PlatformWidget(
          androidBuilder: (context) => Column(
            children: [
              ActionCard(
                title: 'Send feedback',
                desc: 'Spotted a bug or something is not working?',
                icon: const FaIcon(
                  FontAwesomeIcons.bug,
                  color: Colors.red,
                ),
                onTap: () => _sendFeedback(context),
              ),
              const SizedBox(height: Constants.listSpacing),
            ],
          ),
          iosBuilder: (context) => CupertinoListSection.insetGrouped(
            children: [
              ActionCard(
                title: 'Send feedback',
                desc: 'Spotted a bug or something is not working?',
                icon: const FaIcon(
                  CupertinoIcons.ant,
                  color: CupertinoColors.systemRed,
                ),
                onTap: () => _sendFeedback(context),
              ),
            ],
          ),
        ),
        // Compensate for the padding on iOS.
        const PackageInfoView(),
      ],
    );
  }

  void _sendFeedback(BuildContext context) {
    Wiredash.of(context).show(inheritMaterialTheme: true);
  }

  Future<void> _openSourceCode() async {
    if (!await launchUrl(Uri.parse(Constants.sourceCodeURL))) {
      throw Exception('Could not launch URL');
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _arePurchasesRestoring = true;
    });

    try {
      final restorePurchasesResult = await Adapty().restorePurchases();

      if (restorePurchasesResult.accessLevels['premium']?.isActive ?? false) {
        await Hive.box<bool>('iap').put('isPremiumGranted', true);
      }
    } catch (e) {
      unawaited(Sentry.captureException(e));
    }

    setState(() {
      _arePurchasesRestoring = false;
    });

    // ignore: use_build_context_synchronously
    await showPlatformDialog<void>(
      context: context,
      builder: (context) {
        return PlatformAlertDialog(
          title: const Text('Restore purchases'),
          content: const Text('Purchases have been restored.'),
          actions: [
            PlatformDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
