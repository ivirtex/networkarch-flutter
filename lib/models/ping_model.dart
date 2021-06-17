// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

class PingModel extends ChangeNotifier {
  Ping _ping = Ping('192.168.0.1');

  bool isPingingStarted = false;
  List<PingData> pingData = [];

  void setHost(String host) {
    _ping = Ping(host);
    notifyListeners();
  }

  void clearData() {
    pingData.clear();
    notifyListeners();
  }

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }
}
