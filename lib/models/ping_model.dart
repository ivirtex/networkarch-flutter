// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class PingModel extends ChangeNotifier {
  Ping _ping = Ping("1.1.1.1");

  bool isPingingStarted = false;
  List<PingData?> pingData = [];
  String _host = "";

  set setHost(String host) {
    _ping = Ping(host);
    _host = host;
    notifyListeners();
  }

  get getHost => _host;

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
        return Constants.noReplyError;
      case ErrorType.Unknown:
        return Constants.unknownError;
      case ErrorType.UnknownHost:
        return Constants.unknownHostError;
      case ErrorType.RequestTimedOut:
        return Constants.requestTimedOutError;
    }
  }

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }
}
