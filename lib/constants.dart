// Flutter imports:
import 'package:flutter/material.dart';

abstract class Constants {
  static ThemeData themeDataLight = ThemeData().copyWith(
    brightness: Brightness.light,
    accentColor: Colors.black,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData themeDataDark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    accentColor: Colors.white,
    appBarTheme: AppBarTheme(
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
  static const String pingDesc =
      "Send packets to specific IP address or domain";

  static const String lanScannerDesc =
      "Discover network devices in local network";

  static const String wolDesc = "Send magic packets on your local network";

  static const String ipGeoDesc =
      "Get the geolocation of a specific IP address";

  static const String whoisDesc = "Look up information about a specific domain";

  static const String dnsDesc = "Get the DNS records of a specific domain";

  static const String simError = "Couldn't detect the SIM card";

  static const String defaultError = "Couldn't read the data";
}
