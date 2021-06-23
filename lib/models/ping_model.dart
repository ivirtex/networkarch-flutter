// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

class PingModel extends ChangeNotifier {
  Ping _ping = Ping("");

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

  void stopStream() {
    _ping.stop();
    notifyListeners();
  }

  String getErrorDesc(ErrorType error) {
    switch (error) {
      case ErrorType.NoReply:
        return "No reply received from the host";
        break;
      case ErrorType.Unknown:
        return "Unknown address";
        break;
      case ErrorType.UnknownHost:
        return "Unknown host";
        break;
      case ErrorType.RequestTimedOut:
        return "Request timed out";
        break;
    }

    return null;
  }

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }
}
