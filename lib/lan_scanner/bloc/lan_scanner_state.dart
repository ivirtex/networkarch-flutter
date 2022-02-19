part of 'lan_scanner_bloc.dart';

@immutable
abstract class LanScannerState extends Equatable {
  const LanScannerState();
}

class LanScannerInitial extends LanScannerState {
  const LanScannerInitial();

  @override
  List<Object> get props => [];
}

class LanScannerRunStart extends LanScannerState {
  const LanScannerRunStart();

  @override
  List<Object> get props => [];
}

class LanScannerRunProgressUpdate extends LanScannerState {
  const LanScannerRunProgressUpdate(this.progress);

  final double progress;

  @override
  List<Object> get props => [progress];
}

class LanScannerRunNewHost extends LanScannerState {
  const LanScannerRunNewHost(this.host);

  final HostModel host;

  @override
  List<Object> get props => [host.ip];
}

class LanScannerRunStop extends LanScannerState {
  const LanScannerRunStop();

  @override
  List<Object> get props => [];
}

class LanScannerRunComplete extends LanScannerState {
  const LanScannerRunComplete();

  @override
  List<Object> get props => [];
}
