// Flutter imports:
import 'package:flutter/material.dart';

abstract class Constants {
  static ThemeData themeDataLight = ThemeData(
    brightness: Brightness.light,
    accentColor: Colors.black,
    textTheme: TextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData themeDataDark = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.white,
    textTheme: TextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static TextStyle networkTypeTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  // Tools descriptions
  static String pingDesc = "Send packets to specific IP address or domain";
  static String lanScannerDesc = "Discover network devices in local network";
  static String wolDesc = "Send magic packets on your local network";
  static String ipGeoDesc = "Get the geolocation of a specific IP address";
  static String whoisDesc = "Look up information about a specific domain";
  static String dnsDesc = "Get the DNS records of a specific domain";
}
