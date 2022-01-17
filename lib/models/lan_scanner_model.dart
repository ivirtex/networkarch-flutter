// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:lan_scanner/lan_scanner.dart';

class LanScannerModel extends ChangeNotifier {
  final LanScanner _scanner = LanScanner();

  String? _ip;
  String? subnet;
  final int port = 80;
  final Duration timeout = const Duration(seconds: 5);

  bool isScannerViewActive = false;
  Set<HostModel> hosts = <HostModel>{};
  double scanProgress = 0.0;

  void configure({required String? ip}) {
    _ip = ip;

    if (ip != null) {
      subnet = ip.substring(0, ip.lastIndexOf('.'));
    }
  }

  bool getIsScannerRunning() {
    return _scanner.isScanInProgress;
  }

  Stream<HostModel> getStream() {
    if (_ip != null && subnet != null) {
      return _scanner.icmpScan(
        subnet,
        progressCallback: (progress) {
          log('Scan progress: $progress');
        },
      );
    } else {
      throw "Can't discover the network without connection with Wi-Fi";
    }
  }
}
