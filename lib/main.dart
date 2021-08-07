// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/screens/lan_scanner_view.dart';
import 'package:network_arch/screens/permissions_view.dart';
import 'package:network_arch/services/widgets/platform_widget.dart';
import 'constants.dart';
import 'models/connectivity_model.dart';
import 'models/ping_model.dart';
import 'screens/dashboard.dart';
import 'screens/ping_view.dart';

void main() {
  // Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PingModel()),
        ChangeNotifierProvider(create: (context) => LanScannerModel()),
        ChangeNotifierProvider(create: (context) => PermissionsModel()),
        Provider(create: (context) => ConnectivityModel()),
      ],
      child: EasyDynamicThemeWidget(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: (context) {
      return MaterialApp(
        title: 'Dashboard',
        theme: Constants.themeDataLight,
        darkTheme: Constants.themeDataDark,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => Dashboard(),
          '/permissions': (context) => PermissionsView(),
          '/tools/ping': (context) => const PingView(),
          '/tools/lan': (context) => const LanScannerView(),
        },
      );
    }, iosBuilder: (context) {
      return CupertinoApp(
        title: 'Dashboard',
        theme: Constants.cupertinoThemeData,
        initialRoute: '/',
        routes: {
          '/': (context) => Dashboard(),
          '/permissions': (context) => PermissionsView(),
          '/tools/ping': (context) => const PingView(),
          '/tools/lan': (context) => const LanScannerView(),
        },
      );
    });
  }
}
