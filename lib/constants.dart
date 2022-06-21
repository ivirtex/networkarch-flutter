// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/ip_geo/ip_geo.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/overview/overview.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/settings/settings.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';
import 'package:network_arch/whois/whois.dart';

abstract class Constants {
  static const String appName = 'NetworkArch';
  static const String appDesc = '''
      NetworkArch is an open-source network diagnostics tool 
      equipped with various useful utilities.
      ''';
  static const String sourceCodeURL =
      'https://github.com/ivirtex/networkarch-flutter';

  static const String usageDesc = 'We never share this data with anyone.';

  static const String overviewAndroidAdUnitId =
      'ca-app-pub-3222092607864795/3727150533';
  static const String overviewIOSAdUnitId =
      'ca-app-pub-3222092607864795/6714553758';

  static const String premiumAccessAndroidAdUnitId =
      'ca-app-pub-3222092607864795/9965201926';
  static const String premiumAccessIOSAdUnitId =
      'ca-app-pub-3222092607864795/3915633040';

  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  static final Map<String, Widget Function(BuildContext)> routes = {
    '/overview': (context) => const OverviewView(),
    '/settings': (context) => const SettingsView(),
    '/introduction': (context) => IntroductionScreen(
          pages: pagesList,
          isTopSafeArea: true,
          isBottomSafeArea: true,
          controlsPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom,
            horizontal: 16.0,
          ),
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () {
            Hive.box('settings').put('hasIntroductionBeenShown', true);

            Navigator.of(context).pop();
          },
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

  static final Map<String, Widget Function(BuildContext)> iOSroutes = {
    '/overview': (context) => const OverviewView(),
    '/settings': (context) => const SettingsView(),
    '/introduction': (context) => IntroductionScreen(
          pages: pagesList,
          isTopSafeArea: true,
          isBottomSafeArea: true,
          controlsPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom,
            horizontal: 16.0,
          ),
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () {
            Hive.box('settings').put('hasIntroductionBeenShown', true);

            Navigator.of(context).pop();
          },
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
  static const EdgeInsetsDirectional iOSbodyPadding =
      EdgeInsetsDirectional.fromSTEB(18.5, 0.0, 18.5, 6.0);

  static const double listSpacing = 10.0;

  static const double linearProgressWidth = 50.0;

  static const double listDividerIndent = 14.0;

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
      'Discover network devices in the local network';

  static const String wolDesc = 'Send magic packets on your local network';

  static const String ipGeoDesc =
      'Get the geolocation of a specific IP address';

  static const String whoisDesc = 'Lookup information about a specific domain';

  static const String dnsDesc = 'Lookup DNS records of a specific domain';

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
  static const String _permissionGranted = 'Permission granted!';

  static const String _permissionDenied =
      '''Permission denied, the app may not function properly, check the app's settings''';

  static const String _permissionDefault =
      'Something gone wrong, check app permissions';

  static final SnackBar permissionGrantedSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.check_circle_rounded, color: Colors.green),
        SizedBox(width: 10.0),
        Expanded(child: Text(_permissionGranted)),
      ],
    ),
  );

  static final SnackBar permissionDeniedSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.error_rounded, color: Colors.red),
        SizedBox(width: 10.0),
        Expanded(child: Text(_permissionDenied)),
      ],
    ),
    action: SnackBarAction(
      label: 'Open settings',
      onPressed: () => openAppSettings(),
    ),
  );

  static final SnackBar permissionDefaultSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.warning_rounded, color: Colors.orange),
        SizedBox(width: 10.0),
        Expanded(child: Text(_permissionDefault)),
      ],
    ),
    action: SnackBarAction(
      label: 'Open settings',
      onPressed: () => openAppSettings(),
    ),
  );

  static final ElegantNotification permissionGrantedNotification =
      ElegantNotification.success(
    title: const Text('Success'),
    description: const Text(_permissionGranted),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
  );

  static final ElegantNotification permissionDeniedNotification =
      ElegantNotification.error(
    title: const Text('Error'),
    description: const Text(_permissionDenied),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
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

  static final ElegantNotification permissionDefaultNotification =
      ElegantNotification.error(
    title: const Text('Warning'),
    description: const Text(_permissionDefault),
    dismissible: true,
    notificationPosition: NotificationPosition.bottom,
    animation: AnimationType.fromBottom,
  );
}
