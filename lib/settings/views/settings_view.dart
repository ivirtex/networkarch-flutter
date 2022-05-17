// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/package_info/cubit/package_info_cubit.dart';
import 'package:network_arch/package_info/views/package_info_view.dart';
import 'package:network_arch/shared/shared.dart';
import 'package:network_arch/theme/theme.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    hide PlatformWidget;

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _canLaunchUrl = true;

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

  CupertinoPageScaffold _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const CupertinoSliverNavigationBar(
            stretch: true,
            border: null,
            largeTitle: Text('Settings'),
          ),
        ],
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();

    return ContentListView(
      children: [
        const SmallDescription(child: 'Theme settings'),
        DataCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: FlexThemeModeSwitch(
                  themeMode: themeBloc.state.mode,
                  onThemeModeChanged: (mode) {
                    setState(() {
                      themeBloc.add(ThemeModeChangedEvent(themeMode: mode));
                    });
                  },
                  flexSchemeData: Themes
                      .schemesListWithDynamic[themeBloc.state.scheme.index],
                  optionButtonBorderRadius: 10.0,
                ),
              ),
              ThemePopupMenu(
                schemeIndex: themeBloc.state.scheme.index,
                onChanged: (index) async {
                  // Await for popup menu to close (to avoid jank)
                  await Future.delayed(const Duration(milliseconds: 300));

                  setState(() {
                    themeBloc.add(
                      ThemeSchemeChangedEvent(
                        scheme: CustomFlexScheme.values[index],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
        const SmallDescription(child: 'Help'),
        Column(
          children: [
            ActionCard(
              title: 'Go to onboarding screen',
              desc: 'Resolve permissions issues',
              icon: Icons.lock_outline_rounded,
              onTap: () => Navigator.pushNamed(context, '/introduction'),
            ),
            const SizedBox(height: Constants.listSpacing),
            ActionCard(
              title: 'Send feedback',
              desc: 'Something is not working?',
              icon: Icons.feedback_outlined,
              onTap: () => _sendFeedback(context),
            ),
            const SizedBox(height: Constants.listSpacing),
            ActionCard(
              title: 'Source code',
              desc: 'Feel free to contribute!',
              icon: FontAwesomeIcons.github,
              onTap: _canLaunchUrl ? _openSourceCode : null,
            ),
            const SizedBox(height: Constants.listSpacing),
            ActionCard(
              title: 'Restore purchases',
              desc: 'Restore purchases made in the past',
              icon: Icons.workspace_premium_rounded,
              onTap: () => _restorePurchases(),
            ),
          ],
        ),
        const SizedBox(height: Constants.listSpacing),
        const PackageInfoView(),
      ],
    );
  }

  void _sendFeedback(BuildContext context) {
    BetterFeedback.of(context).showAndUploadToSentry();
  }

  Future<void> _openSourceCode() async {
    if (!await launchUrl(Uri.parse(Constants.sourceCodeURL))) {
      throw 'Could not launch URL';
    }
  }

  Future<void> _restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();

    showPlatformDialog(
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
