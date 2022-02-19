// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

abstract class Themes {
  static final ThemeData lightThemeData = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Constants.lightBgColor,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final ThemeData darkThemeData = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Constants.darkBgColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final CupertinoThemeData cupertinoThemeData = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    scaffoldBackgroundColor: const CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGrey6,
      darkColor: CupertinoColors.black,
    ),
    barBackgroundColor: CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGrey6.withOpacity(0.8),
      darkColor: CupertinoColors.black.withOpacity(0.8),
    ),
  );
}
