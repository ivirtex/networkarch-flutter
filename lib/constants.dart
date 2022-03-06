// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/ip_geo/ip_geo.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';
import 'package:network_arch/whois/whois.dart';

// ignore_for_file: avoid-global-state

abstract class Constants {
  static const String appName = 'NetworkArch';
  static const String appDesc = '''
      NetworkArch is an open-source network diagnostic tool 
      equipped with various useful utilities.
      ''';
  static const String sourceCodeURL =
      'https://github.com/ivirtex/networkarch-flutter';

  static const String usageDesc = 'We never share this data with anyone.';

  static const String overviewBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static final Map<String, Widget Function(BuildContext)> routes = {
    '/introduction': (context) => IntroductionScreen(
          pages: pagesList,
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () => Navigator.of(context).pop(),
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
    '/wifi': (context) => const WifiDetailedView(),
    '/carrier': (context) => const CarrierDetailView(),
    '/tools/ping': (context) => const PingView(),
    '/tools/lan': (context) => const LanScannerView(),
    '/tools/wol': (context) => const WakeOnLanView(),
    '/tools/ip_geo': (context) => const IpGeoView(),
    '/tools/whois': (context) => const WhoisView(),
    '/tools/dns_lookup': (context) => const DnsLookupView(),
  };

  // Styles
  static const EdgeInsets listPadding = EdgeInsets.all(10.0);

  static const EdgeInsets bodyPadding = EdgeInsets.all(10.0);

  static const double listSpacing = 10.0;

  static const double linearProgressWidth = 50.0;

  static const Divider listDivider = Divider(
    height: 2,
    indent: 12,
    endIndent: 0,
  );

  // Colors
  static const Color seedColor = Color.fromARGB(255, 1, 77, 128);

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
  );
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: seedColor,
  );

  static const Color iOSlightBgColor = CupertinoColors.systemGrey5;
  static const Color iOSdarkBgColor = CupertinoColors.black;
  static const CupertinoDynamicColor iOSCardColor = CupertinoColors.systemGrey5;
  static const CupertinoDynamicColor iOSBtnColor = CupertinoColors.systemGrey4;

  static Color getPlatformBgColor(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Platform.isIOS
        ? (isDarkModeOn ? iOSdarkBgColor : iOSlightBgColor)
        : Theme.of(context).colorScheme.background;
  }

  static Color getPlatformCardColor(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Platform.isIOS
        ? Constants.iOSCardColor.resolveFrom(context)
        : isDarkModeOn
            ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
            : Theme.of(context).colorScheme.surface.withOpacity(0.8);
  }

  static Color getPlatformBtnColor(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Platform.isIOS
        ? Constants.iOSBtnColor.resolveFrom(context)
        : isDarkModeOn
            ? Theme.of(context).colorScheme.surface.withOpacity(0.6)
            : Theme.of(context).colorScheme.surface;
  }

  static Color getPlatformIconColor(BuildContext context) {
    return Platform.isIOS
        ? CupertinoDynamicColor.resolve(CupertinoColors.white, context)
        : Theme.of(context).colorScheme.onSurface;
  }

  static Color getPlatformTextColor(BuildContext context) {
    return Platform.isIOS
        ? CupertinoDynamicColor.resolve(CupertinoColors.white, context)
        : Theme.of(context).colorScheme.onBackground;
  }

  // Description styles
  static final TextStyle descStyleLight = TextStyle(
    color: Colors.grey[600],
  );

  static final TextStyle descStyleDark = TextStyle(
    color: Colors.grey[400],
  );

  // Tools descriptions
  static const String pingDesc =
      'Send ICMP pings to specific IP address or domain';

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

  static const String unknownError = 'Unknown error';

  static const String unknownHostError = 'Unknown host';

  static const String requestTimedOutError = 'Request timed out';

  // Permissions descriptions
  static const String locationPermissionDesc =
      'We need your location permission in order to access Wi-Fi information';

  static const String phoneStatePermissionDesc =
      'We need your phone permission in order to access carrier information';

  // Permissions snackbars
  static const String _permissionGranted = 'Permission granted.';

  static const String _permissionDenied =
      '''Permission denied, the app may not function properly, check the app's settings.''';

  static const String _permissionDefault =
      'Something gone wrong, check app permissions.';

  static void showPermissionGrantedNotification(
    BuildContext context,
  ) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    if (isDarkModeOn) {
      _permissionGrantedNotification.background =
          Theme.of(context).colorScheme.surfaceVariant;
    }

    _permissionGrantedNotification.show(context);
  }

  static final ElegantNotification _permissionGrantedNotification =
      ElegantNotification.success(
    title: const Text('Success'),
    description: const Text(_permissionGranted),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
  );

  // -----------------------------------------------

  static void showPermissionDeniedNotification(
    BuildContext context,
  ) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    if (isDarkModeOn) {
      _permissionDeniedNotification.background =
          Theme.of(context).colorScheme.surfaceVariant;
    }

    _permissionDeniedNotification.show(context);
  }

  static final ElegantNotification _permissionDeniedNotification =
      ElegantNotification.error(
    title: const Text('Error'),
    description: const Text(_permissionDenied),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
    toastDuration: const Duration(milliseconds: 4000),
    height: 140.0,
    action: const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'Open Settings',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
    onActionPressed: () {
      openAppSettings();
    },
  );

  // -----------------------------------------------

  static void showPermissionDefaultNotification(
    BuildContext context,
  ) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    if (isDarkModeOn) {
      _permissionDefaultNotification.background =
          Theme.of(context).colorScheme.surfaceVariant;
    }

    _permissionDefaultNotification.show(context);
  }

  static final ElegantNotification _permissionDefaultNotification =
      ElegantNotification.error(
    title: const Text('Warning'),
    description: const Text(_permissionDefault),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
  );

  // -----------------------------------------------

  // Wake On Lan snackbars
  static const String _wolValidationError =
      '''The IP address or MAC address is not valid, please check it and try again.''';

  static final ElegantNotification wolValidationErrorNotification =
      ElegantNotification.error(
    title: const Text('Validation error'),
    description: const Text(_wolValidationError),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
    toastDuration: const Duration(milliseconds: 4000),
  );
}
