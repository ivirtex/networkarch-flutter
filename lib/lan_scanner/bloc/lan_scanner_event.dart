part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerEvent {
  const LanScannerEvent(this.progress);

  final double progress;
}

class LanScannerStarted extends LanScannerEvent {
  const LanScannerStarted(double progress) : super(progress);
}

class LanScannerStopped extends LanScannerEvent {
  const LanScannerStopped(double progress) : super(progress);
}
