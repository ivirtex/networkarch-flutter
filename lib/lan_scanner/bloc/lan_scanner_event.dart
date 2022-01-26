part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerEvent {}

class LanScannerStarted extends LanScannerEvent {
  LanScannerStarted({required this.callback});

  final ProgressCallback callback;
}

class LanScannerProgressUpdated extends LanScannerEvent {
  LanScannerProgressUpdated(this.progress);

  final double progress;
}

class LanScannerStopped extends LanScannerEvent {
  LanScannerStopped();
}
