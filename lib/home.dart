// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

  bool? _hasIntroductionBeenShown;
  StreamSubscription<BoxEvent>? _hasIntroductionBeenShownSubscription;

  @override
  void initState() {
    super.initState();

    final settingsBox = Hive.box<bool>('settings');

    _hasIntroductionBeenShown = settingsBox.get(
      'hasIntroductionBeenShown',
      defaultValue: false,
    );

    _hasIntroductionBeenShownSubscription =
        settingsBox.watch(key: 'hasIntroductionBeenShown').listen((event) {
      if (event.value is bool) {
        setState(() {
          _hasIntroductionBeenShown = event.value as bool;
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!_hasIntroductionBeenShown!) {
          showCupertinoModalBottomSheet<void>(
            context: context,
            isDismissible: false,
            builder: (context) => const IosOnboarding(),
          );
        }
      });
    });

    setupIAP();

    context
        .read<PermissionsBloc>()
        .add(const PermissionsStatusRefreshRequested());
  }

  @override
  void dispose() {
    super.dispose();

    _hasIntroductionBeenShownSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _hasIntroductionBeenShown!
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

  Future<void> setupIAP() async {
    try {
      final purchaserInfo = await Adapty.getPurchaserInfo(forceUpdate: true);
      if (purchaserInfo.accessLevels['premium']?.isActive ?? false) {
        if (kDebugMode) {
          print('Granting access to premium features...');
        }

        await Hive.box<bool>('iap').put('isPremiumGranted', true);
      } else {
        await Hive.box<bool>('iap').put('isPremiumGranted', false);
      }
    } catch (e) {
      unawaited(Sentry.captureException(e));
    }
  }
}

const List<Widget> _pages = <Widget>[
  OverviewView(),
  SettingsView(),
];
