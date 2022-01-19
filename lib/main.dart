// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/ip_geo_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/models/ping_model.dart';
import 'package:network_arch/models/toast_notification_model.dart';
import 'package:network_arch/models/wake_on_lan_model.dart';
import 'package:network_arch/screens/cellular_detail_view.dart';
import 'package:network_arch/screens/dashboard.dart';
import 'package:network_arch/screens/ip_geolocation_view.dart';
import 'package:network_arch/screens/lan_scanner_view.dart';
import 'package:network_arch/screens/permissions_view.dart';
import 'package:network_arch/screens/ping_view.dart';
import 'package:network_arch/screens/settings_view.dart';
import 'package:network_arch/screens/wake_on_lan_view.dart';
import 'package:network_arch/screens/wifi_detail_view.dart';
import 'package:network_arch/shared/shared_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PingModel()),
          ChangeNotifierProvider(create: (context) => LanScannerModel()),
          ChangeNotifierProvider(create: (context) => WakeOnLanModel()),
          ChangeNotifierProvider(create: (context) => PermissionsModel()),
          ChangeNotifierProvider(create: (context) => IPGeoModel()),
          Provider(create: (context) => ConnectivityModel()),
          Provider(create: (context) => ToastNotificationModel()),
        ],
        child: EasyDynamicThemeWidget(
          child: const NetworkArch(),
        ),
      ),
    );
  });
}

class NetworkArch extends StatelessWidget {
  const NetworkArch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //! Debug, remove in production
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return MaterialApp(
      title: 'Dashboard',
      theme: Constants.themeDataLight,
      darkTheme: Constants.themeDataDark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      builder: (context, child) {
        return CupertinoTheme(
          data: Constants.cupertinoThemeData,
          child: Material(child: child),
        );
      },
      routes: {
        '/permissions': (context) => const PermissionsView(),
        '/wifi': (context) => const WiFiDetailView(),
        '/cellular': (context) => const CellularDetailView(),
        '/tools/ping': (context) => const PingView(),
        '/tools/lan': (context) => const LanScannerView(),
        '/tools/wol': (context) => const WakeOnLanView(),
        '/tools/ip_geo': (context) => const IPGeolocationView(),
      },
      home: const PlatformAdaptingHomePage(),
    );
  }
}

class PlatformAdaptingHomePage extends StatefulWidget {
  const PlatformAdaptingHomePage({Key? key}) : super(key: key);

  @override
  State<PlatformAdaptingHomePage> createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
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
        titleTextStyle: Theme.of(context).textTheme.headline6,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   systemNavigationBarDividerColor: Colors.white,
        //   systemNavigationBarColor: Colors.white,
        // ),
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
