// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/package_info/cubit/package_info_cubit.dart';
import 'package:network_arch/package_info/views/package_info_view.dart';
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

  @override
  void initState() {
    super.initState();

    _isDarkModeSwitched =
        context.read<ThemeBloc>().state.mode == ThemeMode.dark;
    context.read<PackageInfoCubit>().fetchPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  SingleChildScrollView _buildAndroid(BuildContext context) {
    return SingleChildScrollView(
      child: _buildBody(context),
    );
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

  Padding _buildBody(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: Constants.bodyPadding,
      child: Column(
        children: [
          RoundedList(
            header: 'Theme',
            children: [
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.adjust,
                  color: isDarkModeOn ? Colors.white : Colors.black,
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
          const PackageInfoView(),
        ],
      ),
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
}
