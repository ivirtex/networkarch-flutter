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
      case ErrorType.unknown:
        return Constants.unknownError;
      case ErrorType.unknownHost:
        return Constants.unknownHostError;
      case ErrorType.requestTimedOut:
        return Constants.requestTimedOutError;
      case ErrorType.noReply:
        return Constants.noReplyError;
      case ErrorType.timeToLiveExceeded:
        return Constants.unknownError;
    }
  }
}
