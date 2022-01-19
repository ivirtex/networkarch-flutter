// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:dart_ping/dart_ping.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/animated_list_model.dart';
import 'package:network_arch/utils/keyboard_hider.dart';

class PingModel extends ChangeNotifier {
  Ping _ping = Ping('');

  bool isPingingStarted = false;
  late AnimatedListModel<PingData?> pingData;
  Stream<PingData>? _stream;
  StreamSubscription<PingData>? _subscription;
  String? _host;

  void setHost(String host) {
    _ping = Ping(host);
    _host = host;

    // notifyListeners();
  }

  String? get getHost => _host;

  PingData getData({required int atIndex}) {
    return pingData[atIndex]!;
  }

  void clearData() {
    pingData.clear();

    notifyListeners();
  }

  void onDispose() {
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

  Stream<PingData> getStream() {
    return _ping.stream.asBroadcastStream();
  }

  void handleStartButtonPressed(
    BuildContext context,
    TextEditingController controller,
  ) {
    hideKeyboard(context);

    pingData.removeAllElements(context);

    setHost(controller.text);
    isPingingStarted = true;

    _stream = getStream();
    _subscription = _stream!.listen((PingData event) {
      pingData.insert(pingData.length, event);
    });

    controller.clear();
  }

  void handleStopButtonPressed() {
    _ping.stop();
    isPingingStarted = false;

    notifyListeners();
  }
}
