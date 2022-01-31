part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerState {
  const LanScannerState(this.progress);

  final double progress;
}

class LanScannerInitial extends LanScannerState {
  const LanScannerInitial(double progress) : super(progress);
}

class LanScannerRunStart extends LanScannerState {
  const LanScannerRunStart(this.stream, double progress) : super(progress);

  final Stream<HostModel> stream;
}

class LanScannerRunProgressUpdate extends LanScannerState {
  const LanScannerRunProgressUpdate(double progress) : super(progress);
}

class LanScannerRunComplete extends LanScannerState {
  const LanScannerRunComplete(double progress) : super(progress);
}
