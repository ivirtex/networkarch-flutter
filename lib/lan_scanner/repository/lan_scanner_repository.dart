// Dart imports:
import 'dart:async';

// Package imports:
import 'package:network_tools/network_tools.dart';

class LanScannerRepository {
  LanScannerRepository();

  StreamSubscription<ActiveHost>? _subscription;

  // ignore: avoid_setters_without_getters
  set subscription(StreamSubscription<ActiveHost> subscription) {
    _subscription = subscription;
  }

  void dispose() {
    _subscription?.cancel();
  }

  Stream<ActiveHost> getLanScannerStream({
    required String subnet,
    ProgressCallback? callback,
  }) {
    return HostScanner.discover(subnet, progressCallback: callback);
  }
}
