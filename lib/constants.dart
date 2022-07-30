// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
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

  static const String privacyPolicyURL =
      'https://ivirtex.dev/projects/networkarch/privacyPolicy';

  static const String termsOfUseURL =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  static const String wifiFeatureTitle = 'Wi-Fi';
  static const String wifiFeatureDesc =
      'Explore detailed information about your Wi-Fi network.';

  static const String carrierFeatureTitle = 'Carrier';
  static const String carrierFeatureDesc =
      'Explore detailed information about your cellular network.';

  static const String utilitiesFeatureTitle = 'Utilities';
  static const String utilitiesFeatureDesc =
      'Test your network thanks to various diagnostic tools such as ping, Wake on LAN, LAN Scanner and more.';

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
            horizontal: 16,
          ),
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () {
            Hive.box<bool>('settings').put('hasIntroductionBeenShown', true);

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
  static const EdgeInsets listPadding = EdgeInsets.all(10);

  static const EdgeInsets bodyPadding = EdgeInsets.all(10);
  static const EdgeInsets iOSbodyPadding =
      EdgeInsets.fromLTRB(18.5, 0, 18.5, 6);

  static const EdgeInsets cupertinoListTileWithIconPadding =
      EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );

  static const double listSpacing = 10;

  static const double linearProgressWidth = 50;

  static const double listDividerIndent = 14;

  // Description styles
  static final TextStyle descStyleLight = TextStyle(
    color: Colors.grey[600],
  );

  static final TextStyle descStyleDark = TextStyle(
    color: Colors.grey[400],
  );

  // Tools descriptions
  static const String pingDesc =
      'Send ICMP pings to specific IP address or domain.';

  static const String lanScannerDesc =
      'Discover network devices in the local network.';

  static const String wolDesc = 'Send magic packets in your local network.';

  static const String ipGeoDesc = 'Get the geolocation of any IP address.';

  static const String whoisDesc = 'Lookup information about any domain.';

  static const String dnsDesc = 'Lookup DNS records of any domain.';

  // Error descriptions
  static const String defaultError = 'Error while loading data';

  static const String simError = 'No SIM card';

  static const String noReplyError = 'No reply received from the host';

  static const String unknownError = 'Unknown error';

  static const String unknownHostError = 'Unknown host';

  static const String requestTimedOutError = 'Request timed out';

  // Permissions descriptions
  static const String locationPermissionDesc =
      'We need your location permission in order to access Wi-Fi information.';

  static const String phoneStatePermissionDesc =
      'We need your phone permission in order to access carrier information.';

  // Permissions messages
  static const String _permissionGranted = 'Permission succesfully granted.';

  static const String _permissionDenied =
      '''Permission denied, the app may not function properly, check the app's settings.''';

  static const String _permissionDefault =
      'Something gone wrong, check app permissions.';

  static final SnackBar permissionGrantedSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.check_circle_rounded, color: Colors.green),
        SizedBox(width: 10),
        Expanded(child: Text(_permissionGranted)),
      ],
    ),
  );

  static final SnackBar permissionDeniedSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.error_rounded, color: Colors.red),
        SizedBox(width: 10),
        Expanded(child: Text(_permissionDenied)),
      ],
    ),
    action: const SnackBarAction(
      label: 'Open settings',
      onPressed: openAppSettings,
    ),
  );

  static final SnackBar permissionDefaultSnackbar = SnackBar(
    content: Row(
      children: const [
        Icon(Icons.warning_rounded, color: Colors.orange),
        SizedBox(width: 10),
        Expanded(child: Text(_permissionDefault)),
      ],
    ),
    action: const SnackBarAction(
      label: 'Open settings',
      onPressed: openAppSettings,
    ),
  );

  static CupertinoAlertDialog permissionGrantedCupertinoDialog(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Permission granted'),
        content: const Text(_permissionGranted),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static CupertinoAlertDialog permissionDeniedCupertinoDialog(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Permission denied'),
        content: const Text(_permissionDenied),
        actions: [
          const CupertinoDialogAction(
            onPressed: openAppSettings,
            child: Text('Open settings'),
          ),
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static CupertinoAlertDialog permissionDefaultCupertinoDialog(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Something gone wrong'),
        content: const Text(_permissionDefault),
        actions: [
          const CupertinoDialogAction(
            onPressed: openAppSettings,
            child: Text('Open settings'),
          ),
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  // WOL iOS dialogs
  static const String _wolIpValidationError =
      'Provided IPv4 address is invalid, check your data and try again.';

  static CupertinoAlertDialog wolIpValidationError(BuildContext context) =>
      CupertinoAlertDialog(
        title: const Text('Error'),
        content: const Text(_wolIpValidationError),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static const String _wolMacValidationError =
      'Provided MAC address is invalid, check your data and try again.';

  static CupertinoAlertDialog wolMacValidationError(BuildContext context) =>
      CupertinoAlertDialog(
        title: const Text('Error'),
        content: const Text(_wolMacValidationError),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static const String _wolIpAndMacValidationError =
      'Provided IPv4 and MAC address are invalid, check your data and try again.';

  static CupertinoAlertDialog wolIpAndMacValidationError(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Error'),
        content: const Text(_wolIpAndMacValidationError),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
}
