// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

abstract class Themes {
  static List<FlexSchemeData> schemesListWithDynamic = [
    // Fallback scheme that will get replaced if device supports dynamic colors
    FlexSchemeData(
      name: 'Fallback',
      description:
          'Fallback scheme if your device does not support dynamic colors (Android 12+)',
      light: FlexSchemeColor.from(
        primary: Colors.blue,
        brightness: Brightness.light,
      ),
      dark: FlexSchemeColor.from(
        primary: Colors.blue,
        brightness: Brightness.dark,
      ),
    ),

    ...FlexColor.schemesList,
  ];

  static ThemeData getLightThemeDataFor(CustomFlexScheme flexScheme) {
    return FlexThemeData.light(
      colors: schemesListWithDynamic[flexScheme.index].light,
      useMaterial3: true,
      useMaterial3ErrorColors: true,
      subThemesData: const FlexSubThemesData(),
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0,
      blendLevel: 5,
    );
  }

  static ThemeData getDarkThemeDataFor(CustomFlexScheme flexScheme) {
    return FlexThemeData.dark(
      colors: schemesListWithDynamic[flexScheme.index].dark,
      useMaterial3: true,
      useMaterial3ErrorColors: true,
      subThemesData: const FlexSubThemesData(),
      surfaceMode: FlexSurfaceMode.level,
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0,
      blendLevel: 20,
    );
  }

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

  static const Color iOSlightBgColor = CupertinoColors.systemGrey5;
  static const Color iOSdarkBgColor = CupertinoColors.black;
  static const CupertinoDynamicColor iOSCardColor = CupertinoColors.systemGrey5;
  static const CupertinoDynamicColor iOSBtnColor = CupertinoColors.systemGrey4;

  static Color getPlatformIconColor(BuildContext context) {
    return Platform.isIOS
        ? CupertinoDynamicColor.resolve(CupertinoColors.white, context)
        : Theme.of(context).colorScheme.onSurface;
  }
}
