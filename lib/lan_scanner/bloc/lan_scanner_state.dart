part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerState {
  const LanScannerState(this.progress);

  final double progress;
}

class LanScannerInitial extends LanScannerState {
  const LanScannerInitial(double progress) : super(progress);
}

class LanScannerRunStarted extends LanScannerState {
  const LanScannerRunStarted(this.stream, double progress) : super(progress);

  final Stream<HostModel> stream;
}

class LanScannerRunProgressUpdated extends LanScannerState {
  const LanScannerRunProgressUpdated(double progress) : super(progress);
}

class LanScannerRunComplete extends LanScannerState {
  const LanScannerRunComplete(double progress) : super(progress);
}
