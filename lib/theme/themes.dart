// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';

abstract class Themes {
  static final ThemeData lightThemeData = ThemeData(
    colorScheme: Constants.lightColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Constants.lightColorScheme.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  static final ThemeData darkThemeData = ThemeData(
    colorScheme: Constants.darkColorScheme,
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: Constants.darkColorScheme.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static final CupertinoThemeData cupertinoLightThemeData = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGrey6,
      darkColor: CupertinoColors.black,
    ),
    barBackgroundColor: CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGrey6.withOpacity(0.8),
      darkColor: CupertinoColors.black.withOpacity(0.8),
    ),
  );

  static final CupertinoThemeData cupertinoDarkThemeData = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    brightness: Brightness.dark,
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
