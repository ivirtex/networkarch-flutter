// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class PingRepository {
  PingRepository();

  Ping? ping;
  StreamSubscription<PingData>? _subscription;

  Stream<PingData> getPingStream({required String host}) {
    ping = Ping(host);

    return ping!.stream;
  }

  // ignore: avoid_setters_without_getters
  set subscription(StreamSubscription<PingData> subscription) {
    _subscription = subscription;
  }

  void dispose() {
    _subscription?.cancel();
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
}
