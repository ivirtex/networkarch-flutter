// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/package_info/cubit/package_info_cubit.dart';
import 'package:network_arch/package_info/views/package_info_view.dart';
import 'package:network_arch/shared/content_list_view.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/theme.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // TODO: Implement system theme toggle
  late bool _isDarkModeSwitched;

  Future<PackageInfo>? packageInfo;
  bool canLaunchUrl = true;

  @override
  void initState() {
    super.initState();

    _isDarkModeSwitched =
        context.read<ThemeBloc>().state.mode == ThemeMode.dark;
    context.read<PackageInfoCubit>().fetchPackageInfo();
    canLaunch(Constants.sourceCodeURL)
        .then((canLaunch) => canLaunchUrl = canLaunch);
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
              leading: FaIcon(
                FontAwesomeIcons.adjust,
                color: Constants.getPlatformIconColor(context),
              ),
              title: const Text('Dark Mode'),
              trailing: Switch.adaptive(
                value: _isDarkModeSwitched,
                onChanged: _handleDarkModeSwitched,
              ),
            ),
          ],
        ),
        const SizedBox(height: Constants.listSpacing),
        RoundedList(
          header: 'Help',
          children: [
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.infoCircle,
                color: Constants.getPlatformIconColor(context),
              ),
              title: const Text('Go to introduction screen'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Constants.getPlatformIconColor(context),
              ),
              onTap: () => Navigator.pushNamed(context, '/introduction'),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.envelope,
                color: Constants.getPlatformIconColor(context),
              ),
              title: const Text('Send feedback'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Constants.getPlatformIconColor(context),
              ),
              onTap: () => _sendFeedback(context),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.github,
                color: Constants.getPlatformIconColor(context),
              ),
              title: const Text('Source code'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Constants.getPlatformIconColor(context),
              ),
              onTap: canLaunchUrl ? _openSourceCode : null,
            ),
          ],
        ),
        const SizedBox(height: Constants.listSpacing),
        const PackageInfoView(),
      ],
    );
  }

  void _handleDarkModeSwitched(bool isSwitched) {
    setState(() {
      _isDarkModeSwitched = isSwitched;
    });

    context.read<ThemeBloc>().add(
          _isDarkModeSwitched
              ? UpdateToDarkThemeEvent()
              : UpdateToLightThemeEvent(),
        );
  }

  void _sendFeedback(BuildContext context) {
    BetterFeedback.of(context).showAndUploadToSentry();
  }

  Future<void> _openSourceCode() async {
    if (!await launch(Constants.sourceCodeURL)) throw 'Could not launch URL';
  }
}
