import 'package:flutter/cupertino.dart';
import 'package:network_tools/network_tools.dart';

class LanScannerModel extends ChangeNotifier {
  String? _ip;
  String? _subnet;
  int _port = 80;

  double _progress = 0;
  bool isScannerRunning = false;
  Set<ActiveHost> hosts = Set<ActiveHost>();

  void configure({required String? ip}) {
    _ip = ip;

    if (ip != null) {
      _subnet = ip.substring(0, ip.lastIndexOf('.'));
    }
  }

  set setIP(String ip) => _ip;
  set setSubnet(String subnet) => _subnet;
  set setPort(int port) => _port;

  String? get getIP => _ip;
  String? get getSubnet => _subnet;
  int get getPort => _port;
  double get getProgress => _progress;

  Stream<ActiveHost> getStream() {
    print("IP: $_ip, Subnet: $_subnet");

    if (_ip != null && _subnet != null) {
      final stream = HostScanner.discover(_subnet!,
          firstSubnet: 1, lastSubnet: 255, progressCallback: (progress) {
        print('Progress for host discovery : $progress');
        _progress = progress;
      });

      return stream.asBroadcastStream();
    } else {
      throw "Can't discover the network without connection with Wi-Fi";
    }
  }
}
