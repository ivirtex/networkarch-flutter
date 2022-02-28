// Dart imports:
import 'dart:async';

// Package imports:
import 'package:lan_scanner/lan_scanner.dart';

class LanScannerRepository {
  LanScannerRepository();

  final LanScanner _scanner = LanScanner();
  StreamSubscription<HostModel>? _subscription;

  // ignore: avoid_setters_without_getters
  set subscription(StreamSubscription<HostModel> subscription) {
    _subscription = subscription;
  }

  void dispose() {
    _subscription?.cancel();
  }

  Stream<HostModel> getLanScannerStream({
    required String subnet,
    ProgressCallback? callback,
  }) {
    return _scanner.icmpScan(
      subnet,
      progressCallback: callback,
      scanThreads: 15,
    );
  }
}
