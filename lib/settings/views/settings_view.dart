// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
  late int _labelIndex;

  bool _canLaunchUrl = true;

  @override
  void initState() {
    super.initState();

    _labelIndex = context.read<ThemeBloc>().state.mode.index;
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
    return ContentListView(
      children: [
        RoundedList(
          header: 'Theme',
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 16, right: 8),
              leading: Icon(
                Icons.dark_mode_rounded,
                color: Themes.getPlatformIconColor(context),
              ),
              title: const Text('Mode'),
              trailing: SizedBox(
                child: ToggleSwitch(
                  totalSwitches: 3,
                  initialLabelIndex: _labelIndex,
                  labels: const ['System', 'Light', 'Dark'],
                  cornerRadius: 10.0,
                  activeBgColor: [
                    Theme.of(context).colorScheme.primary,
                  ],
                  onToggle: _onToggle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Constants.listSpacing),
        RoundedList(
          header: 'Help',
          children: [
            SettingsTile(
              title: 'Go to onboarding screen',
              icon: Icons.info_rounded,
              onTap: () => Navigator.pushNamed(context, '/introduction'),
            ),
            SettingsTile(
              title: 'Send feedback',
              icon: Icons.feedback_rounded,
              onTap: () => _sendFeedback(context),
            ),
            SettingsTile(
              title: 'View source code',
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

  void _onToggle(int? index) {
    switch (index) {
      case 0:
        context.read<ThemeBloc>().add(UpdateToSystemThemeEvent());
        _labelIndex = 0;
        break;
      case 1:
        context.read<ThemeBloc>().add(UpdateToLightThemeEvent());
        _labelIndex = 1;
        break;

      case 2:
        context.read<ThemeBloc>().add(UpdateToDarkThemeEvent());
        _labelIndex = 2;
        break;
    }
  }

  Future<void> _openSourceCode() async {
    if (!await launch(Constants.sourceCodeURL)) throw 'Could not launch URL';
  }
}
