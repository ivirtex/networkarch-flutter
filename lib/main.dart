import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: Dashboard(),
    );
  }
}
