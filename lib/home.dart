// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/overview/views/overview_view.dart';
import 'package:network_arch/permissions/permissions.dart';
import 'package:network_arch/settings/settings.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  bool? hasIntroductionBeenShown;
  StreamSubscription<BoxEvent>? hasIntroductionBeenShownSubscription;

  @override
  void initState() {
    super.initState();

    final settingsBox = Hive.box<bool>('settings');

    hasIntroductionBeenShown = settingsBox.get(
      'hasIntroductionBeenShown',
      defaultValue: false,
    );
    if (!hasIntroductionBeenShown!) {
      showCupertinoModalBottomSheet<void>(
        context: context,
        builder: (context) => const IosOnboarding(),
      );
    }

    hasIntroductionBeenShownSubscription =
        settingsBox.watch(key: 'hasIntroductionBeenShown').listen((event) {
      if (event.value is bool) {
        setState(() {
          hasIntroductionBeenShown = event.value as bool;
        });
      }

      if (!hasIntroductionBeenShown!) {
        showCupertinoModalBottomSheet<void>(
          context: context,
          builder: (context) => const IosOnboarding(),
        );
      }
    });

    context
        .read<PermissionsBloc>()
        .add(const PermissionsStatusRefreshRequested());
  }

  @override
  void dispose() {
    super.dispose();

    hasIntroductionBeenShownSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return hasIntroductionBeenShown!
        ? PlatformWidget(
            androidBuilder: _androidBuilder,
            iosBuilder: _iosBuilder,
          )
        : PlatformWidget(
            androidBuilder: Constants.routes['/introduction'],
            iosBuilder: _iosBuilder,
          );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0
            ? const Text('Overview')
            : const Text('Settings'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Overview',
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: 'Overview',
              routes: Constants.routes,
              builder: Constants.routes['/overview'],
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: 'Settings',
              routes: Constants.routes,
              builder: Constants.routes['/settings'],
            );
          default:
            throw Exception('Unexpected tab');
        }
      },
    );
  }
}

const List<Widget> _pages = <Widget>[
  OverviewView(),
  SettingsView(),
];
