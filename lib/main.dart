// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:provider/provider.dart';

// Project imports:
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
        Provider(create: (context) => PingModel()),
        Provider(create: (context) => ConnectivityModel()),
      ],
      child: EasyDynamicThemeWidget(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: Constants.themeDataLight,
      darkTheme: Constants.themeDataDark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => Dashboard(),
        '/tools/ping': (context) => PingView(),
      },
    );
  }
}
