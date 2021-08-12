// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_arch/services/utils/scanner_mode.dart';

class LanScannerModel extends ChangeNotifier {
  final LanScanner _scanner = LanScanner();

  String? _ip;
  String? subnet;
  final int port = 80;
  final Duration timeout = const Duration(seconds: 5);

  bool isScannerViewActive = false;
  Set<DeviceModel> hosts = <DeviceModel>{};
  ScannerMode mode = ScannerMode.quick;
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

  Stream<DeviceModel> getStream() {
    if (_ip != null && subnet != null) {
      switch (mode) {
        case ScannerMode.quick:
          final stream = _scanner.quickScan(
            subnet: subnet,
            timeout: timeout,
          );

          return stream;
        case ScannerMode.precise:
          final stream = _scanner.preciseScan(subnet,
              progressCallback: (ProgressModel progress) {
            print('Scan progress: ${progress.percent}');
            print('Current IP: ${progress.currIP}\n');

            scanProgress = progress.percent;
          });

          return stream;
      }
    } else {
      throw "Can't discover the network without connection with Wi-Fi";
    }
  }
}
