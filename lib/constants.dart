// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class Constants {
  static ThemeData themeDataLight = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData themeDataDark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static CupertinoThemeData cupertinoThemeData = const CupertinoThemeData();

  // Colors
  // static Color lightBgColor = Colors.grey[200]!;
  static Color lightBgColor = CupertinoColors.systemGrey6;

  // static Color darkBgColor = Colors.grey[800]!;
  static Color darkBgColor = CupertinoColors.systemGrey5;

  // Description styles
  static TextStyle descStyleLight = TextStyle(color: Colors.grey[600]);

  static TextStyle descStyleDark = TextStyle(color: Colors.grey[400]);

  // Tools descriptions
  static const String pingDesc =
      'Send packets to specific IP address or domain';

  static const String lanScannerDesc =
      'Discover network devices in local network';

  static const String wolDesc = 'Send magic packets on your local network';

  static const String ipGeoDesc =
      'Get the geolocation of a specific IP address';

  static const String whoisDesc = 'Look up information about a specific domain';

  static const String dnsDesc = 'Get the DNS records of a specific domain';

  // Error descriptions
  static const String defaultError = "Couldn't read the data";

  static const String simError = 'No SIM card';

  static const String noReplyError = 'No reply received from the host';

  static const String unknownError = 'No reply received from the host';

  static const String unknownHostError = 'No reply received from the host';

  static const String requestTimedOutError = 'No reply received from the host';

  // Permissions descriptions
  static const String locationPermissionDesc =
      'We need your location permission in order to access Wi-Fi information';

  // Permissions snackbars
  static const String _permissioGranted = 'Permission granted.';

  static const String _permissionDenied =
      '''Permission denied, the app may not function properly, check the app's settings.''';

  static const String _permissionDefault =
      'Something gone wrong, check app permissions.';

  static SnackBar permissionGrantedSnackBar = SnackBar(
    content: Row(
      children: const [
        FaIcon(
          FontAwesomeIcons.checkCircle,
          color: Colors.green,
        ),
        SizedBox(width: 10),
        Expanded(child: Text(_permissioGranted)),
      ],
    ),
  );

  static SnackBar permissionDeniedSnackBar = SnackBar(
    duration: const Duration(seconds: 10),
    action: SnackBarAction(
      onPressed: () {
        openAppSettings();
      },
      label: 'Settings',
    ),
    content: Row(
      children: const [
        FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.red,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(_permissionDenied),
        ),
      ],
    ),
  );

  static SnackBar permissionDefaultSnackBar = SnackBar(
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      onPressed: () {
        openAppSettings();
      },
      label: 'Settings',
    ),
    content: Row(
      children: const [
        FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.red,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(_permissionDefault),
        ),
      ],
    ),
  );

  // Wake On Lan snackbars
  static const String _wolValidationError =
      '''The IP address or MAC address is not valid, please check it and try again.''';

  static SnackBar wolValidationFault = SnackBar(
    content: Row(
      children: const [
        FaIcon(
          FontAwesomeIcons.timesCircle,
          color: Colors.red,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            _wolValidationError,
          ),
        ),
      ],
    ),
  );
}
