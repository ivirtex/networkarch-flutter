// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/list_model.dart';

class PingModel extends ChangeNotifier {
  Ping _ping = Ping('');

  bool isPingingStarted = false;
  late AnimatedListModel<PingData?> pingData;
  String? _host;

  void setHost(String? host) {
    _ping = Ping(host ?? '');
    _host = host;

    notifyListeners();
  }

  String? get getHost => _host;

  PingData getData({required int atIndex}) {
    return pingData[atIndex]!;
  }

  void clearData() {
    pingData.clear();

    notifyListeners();
  }

  void stopStream() {
    _ping.stop();
  }

  String getErrorDesc(PingError error) {
    switch (error.error) {
      case ErrorType.Unknown:
        return Constants.unknownError;
      case ErrorType.UnknownHost:
        return Constants.unknownHostError;
      case ErrorType.RequestTimedOut:
        return Constants.requestTimedOutError;
      case ErrorType.NoReply:
        return Constants.noReplyError;
    }
  }

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }
}
