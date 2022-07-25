// Dart imports:
import 'dart:async';
import 'dart:isolate';

// Package imports:
import 'package:network_tools/network_tools.dart';

class LanScannerRepository {
  LanScannerRepository();

  Future<void> startScanning(List<dynamic> args) async {
    final responsePort = args[0] as SendPort;
    final subnet = args[1] as String;

    final stream = HostScanner.discover(
      subnet,
      progressCallback: responsePort.send,
      resultsInIpAscendingOrder: false,
    );

    await for (final host in stream) {
      responsePort.send(host);
    }

    return;
  }
}
