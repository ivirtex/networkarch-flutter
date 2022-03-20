// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/package_info/cubit/package_info_cubit.dart';
import 'package:network_arch/package_info/views/package_info_view.dart';
import 'package:network_arch/settings/settings.dart';
import 'package:network_arch/shared/content_list_view.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/theme.dart';

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
    canLaunch(Constants.sourceCodeURL)
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
        RoundedList(
          padding: EdgeInsets.zero,
          header: 'Theme settings',
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
                flexSchemeData:
                    FlexColor.schemesList[themeBloc.state.scheme.index],
                optionButtonBorderRadius: 10.0,
              ),
            ),
            ThemePopupMenu(
              schemeIndex: themeBloc.state.scheme.index,
              onChanged: (index) {
                setState(() {
                  themeBloc.add(
                    ThemeSchemeChangedEvent(scheme: FlexScheme.values[index]),
                  );
                });
              },
            ),
          ],
        ),
        const SizedBox(height: Constants.listSpacing),
        RoundedList(
          padding: EdgeInsets.zero,
          header: 'Help',
          children: [
            SettingsTile(
              title: const Text('Go to onboarding screen'),
              subtitle: const Text('Resolve permissions issues'),
              icon: Icons.info_rounded,
              onTap: () => Navigator.pushNamed(context, '/introduction'),
            ),
            SettingsTile(
              title: const Text('Send feedback'),
              subtitle: const Text('Something is not working?'),
              icon: Icons.feedback_rounded,
              onTap: () => _sendFeedback(context),
            ),
            SettingsTile(
              title: const Text('Source code'),
              subtitle: const Text('Feel free to contribute!'),
              icon: FontAwesomeIcons.github,
              onTap: _canLaunchUrl ? _openSourceCode : null,
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
    if (!await launch(Constants.sourceCodeURL)) throw 'Could not launch URL';
  }
}
