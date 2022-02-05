part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerEvent {}

class LanScannerStarted extends LanScannerEvent {
  LanScannerStarted();
}

class LanScannerProgressUpdated extends LanScannerEvent {
  LanScannerProgressUpdated(this.progress);

  final double progress;
}

class LanScannerNewHostDetected extends LanScannerEvent {
  LanScannerNewHostDetected(this.host);

  final HostModel host;
}

class LanScannerStopped extends LanScannerEvent {
  LanScannerStopped();
}
