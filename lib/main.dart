// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'constants.dart';
import 'models/connectivity.dart';
import 'models/ping_model.dart';
import 'screens/dashboard.dart';
import 'screens/ping_view.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => PingModel()),
        Provider(create: (context) => Connectivity())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      themeMode: ThemeMode.system,
      theme: Constants.themeDataLight,
      darkTheme: Constants.themeDataDark,
      initialRoute: '/',
      routes: {
        '/': (context) => Dashboard(),
        '/tools/ping': (context) => PingView(),
      },
    );
  }
}
