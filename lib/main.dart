import 'package:flutter/material.dart';

import 'constants.dart';
import 'screens/dashboard.dart';
import 'screens/ping.dart';

void main() {
  runApp(MyApp());
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
        '/tools/ping': (context) => Ping(),
      },
    );
  }
}
