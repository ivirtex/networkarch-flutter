// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:lan_scanner/lan_scanner.dart';

class LanScannerModel extends ChangeNotifier {
  LanScanner _scanner = LanScanner();

  String? _ip;
  String? _subnet;
  int _port = 80;
  Duration _timeout = Duration(seconds: 5);

  bool isScannerViewActive = false;
  Set<DeviceAddress> hosts = Set<DeviceAddress>();

  void configure({required String? ip}) {
    _ip = ip;

    if (ip != null) {
      _subnet = ip.substring(0, ip.lastIndexOf('.'));
    }
  }

  bool getIsScannerRunning() {
    return _scanner.isScanInProgress;
  }

  set setIP(String ip) => _ip;
  set setSubnet(String subnet) => _subnet;
  set setPort(int port) => _port;
  set setDuration(Duration timeoutDuration) => _timeout;

  String? get getIP => _ip;
  String? get getSubnet => _subnet;
  Duration get getTimeout => _timeout;

  Stream<DeviceAddress> getStream() {
    if (_ip != null && _subnet != null) {
      final stream = _scanner.preciseScan(
          subnet: _subnet,
          timeout: _timeout,
          progressCallback: (progress) {
            print(progress);
          });

      return stream;
    } else {
      throw "Can't discover the network without connection with Wi-Fi";
    }
  }
}
