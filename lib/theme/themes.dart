// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

abstract class Themes {
  static ThemeData getLightThemeDataFor(FlexScheme flexScheme) {
    return FlexThemeData.light(
      scheme: flexScheme,
      useSubThemes: true,
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: 7,
    );
  }

  static ThemeData getDarkThemeDataFor(FlexScheme flexScheme) {
    return FlexThemeData.dark(
      scheme: flexScheme,
      useSubThemes: true,
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog,
      blendLevel: 7,
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
