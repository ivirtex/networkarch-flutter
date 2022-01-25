// // Dart imports:
// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// // Flutter imports:
// import 'package:flutter/cupertino.dart';

// // Package imports:
// import 'package:lan_scanner/lan_scanner.dart';

// // Project imports:
// import 'package:network_arch/models/animated_list_model.dart';

// class LanScannerModel extends ChangeNotifier {
//   final LanScanner _scanner = LanScanner();

//   String? _ip;
//   String? subnet;
//   final Duration timeout = const Duration(seconds: 5);

//   bool isScannerViewActive = false;
//   late AnimatedListModel<InternetAddress> hosts;
//   double scanProgress = 0.0;

//   late Stream<HostModel>? _stream;
//   StreamSubscription<HostModel>? _subscription;

//   void updateProgress(double progress) {
//     scanProgress = progress;

//     notifyListeners();
//   }

//   void configure({required String? ip}) {
//     _ip = ip;

//     if (ip != null) {
//       subnet = ip.substring(0, ip.lastIndexOf('.'));
//     }
//   }

//   bool getIsScannerRunning() {
//     return _scanner.isScanInProgress;
//   }

//   Stream<HostModel> getStream() {
//     if (_ip != null && subnet != null) {
//       return _scanner.icmpScan(
//         subnet,
//         progressCallback: (progress) {
//           log('Scan progress: $progress');

//           updateProgress(double.parse(progress));
//         },
//       );
//     } else {
//       throw "Can't discover the network without connection with Wi-Fi";
//     }
//   }

//   Future<void> handleStartButtonPressed(BuildContext context) async {
//     await hosts.removeAllElements(context);
//     notifyListeners();

//     _stream = getStream();
//     _subscription = _stream!.listen((HostModel host) {
//       final address = InternetAddress(host.ip);

//       log('Found host: ${host.ip}');

//       hosts.insert(hosts.length, address);
//     });
//   }

//   Future<void> handleStopButtonPressed(BuildContext context) async {
//     updateProgress(0.0);

//     await _subscription?.cancel();
//   }
// }
