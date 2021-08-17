// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class PingModel extends ChangeNotifier {
  late Ping _ping;

  bool isPingingStarted = false;
  List<PingData?> pingData = [];
  String? _host;

  void setHost(String? host) {
    _ping = Ping(host ?? '');
    _host = host;
    notifyListeners();
  }

  String? get getHost => _host;

  void clearData() {
    pingData.clear();
    notifyListeners();
  }

  void stopStream() {
    _ping.stop();
  }

  String getErrorDesc(PingError error) {
    switch (error) {
      case PingError.Unknown:
        return Constants.unknownError;
      case PingError.UnknownHost:
        return Constants.unknownHostError;
      case PingError.RequestTimedOut:
        return Constants.requestTimedOutError;
    }
  }

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }
}
