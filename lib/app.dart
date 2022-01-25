// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/screens/screens.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'ping/ping.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Dashboard',
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
              defaultTitle: 'Dashboard',
              routes: _cupertinoRoutes,
              builder: (context) => const Dashboard(),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: 'Settings',
              routes: _cupertinoRoutes,
              builder: (context) => const Settings(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }
}

const List<Widget> _pages = <Widget>[
  Dashboard(),
  Settings(),
];

Map<String, Widget Function(BuildContext)> _cupertinoRoutes = {
  '/permissions': (context) => const PermissionsView(),
  '/wifi': (context) => const WiFiDetailView(),
  '/cellular': (context) => const CellularDetailView(),
  '/tools/ping': (context) => const PingView(),
  '/tools/lan': (context) => const LanScannerView(),
  '/tools/wol': (context) => const WakeOnLanView(),
  '/tools/ip_geo': (context) => const IPGeolocationView(),
};
