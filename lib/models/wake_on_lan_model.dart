// Flutter imports:
import 'dart:async';

import 'package:flutter/foundation.dart';

// Package imports:
import 'package:wake_on_lan/wake_on_lan.dart';

class WakeOnLanModel extends ChangeNotifier {
  late String ipv4;
  late String mac;

  final StreamController<WolResponse> _controller = StreamController();
  List<WolResponse> wolResponses = [];

  Future<void> sendPacket() async {
    if (MACAddress.validate(mac) && IPv4Address.validate(ipv4)) {
      final MACAddress macAddress = MACAddress.from(mac);
      final IPv4Address ipv4Address = IPv4Address.from(ipv4);
      final WakeOnLAN wol = WakeOnLAN.from(ipv4Address, macAddress, port: 1234);

      await wol.wake().then((_) {
        print('sent');

        _controller.add(WolResponse(ipv4, mac));
      });
    }
  }

  Stream<WolResponse> getStream() {
    return _controller.stream;
  }
}

class WolResponse {
  WolResponse(this.ipv4, this.mac);

  final String ipv4;
  final String mac;
}
