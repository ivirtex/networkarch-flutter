part of 'lan_scanner_bloc.dart';

abstract class LanScannerEvent {}

class LanScannerStarted extends LanScannerEvent {
  LanScannerStarted();
}

class LanScannerProgressUpdated extends LanScannerEvent {
  LanScannerProgressUpdated(this.progress);

  final double progress;
}

class LanScannerHostFound extends LanScannerEvent {
  LanScannerHostFound(this.host);

  final Host host;
}

class LanScannerStopped extends LanScannerEvent {
  LanScannerStopped();
}

class LanScannerCompleted extends LanScannerEvent {
  LanScannerCompleted();
}
