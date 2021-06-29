// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

class PingModel extends ChangeNotifier {
  Ping _ping = Ping("");

  bool isPingingStarted = false;
  List<PingData?> pingData = [];
  String host = "";

  set setHost(String host) {
    _ping = Ping(host);
    this.host = host;
    notifyListeners();
  }

  void clearData() {
    pingData.clear();
    notifyListeners();
  }

  void stopStream() {
    _ping.stop();
  }

  String getErrorDesc(ErrorType error) {
    switch (error) {
      case ErrorType.NoReply:
        return "No reply received from the host";
      case ErrorType.Unknown:
        return "Unknown address";
      case ErrorType.UnknownHost:
        return "Unknown host";
      case ErrorType.RequestTimedOut:
        return "Request timed out";
    }
  }

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }
}
