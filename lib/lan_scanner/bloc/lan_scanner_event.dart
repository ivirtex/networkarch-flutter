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

class LanScannerHostFound extends LanScannerEvent {
  LanScannerHostFound(this.host);

  final HostModel host;
}

class LanScannerStopped extends LanScannerEvent {
  LanScannerStopped();
}

class LanScannerCompleted extends LanScannerEvent {
  LanScannerCompleted();
}
