part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerState {
  const LanScannerState();
}

class LanScannerInitial extends LanScannerState {
  const LanScannerInitial();
}

class LanScannerRunStart extends LanScannerState {
  const LanScannerRunStart();
}

class LanScannerRunProgressUpdate extends LanScannerState {
  const LanScannerRunProgressUpdate(this.progress);

  final double progress;
}

class LanScannerRunHostFound extends LanScannerState {
  const LanScannerRunHostFound(this.host);

  final HostModel host;
}

class LanScannerRunStopped extends LanScannerState {
  const LanScannerRunStopped();
}

class LanScannerRunComplete extends LanScannerState {
  const LanScannerRunComplete();
}
