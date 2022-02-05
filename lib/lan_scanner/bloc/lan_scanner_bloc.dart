// Dart imports:
// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';

// Project imports:
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';

part 'lan_scanner_event.dart';
part 'lan_scanner_state.dart';

class LanScannerBloc extends Bloc<LanScannerEvent, LanScannerState> {
  LanScannerBloc(this._lanScannerRepository)
      : super(const LanScannerInitial()) {
    on<LanScannerStarted>(_onStarted);
    on<LanScannerProgressUpdated>(_onProgressUpdated);
    on<LanScannerNewHostDetected>(_onNewHostDetected);
    on<LanScannerStopped>(_onStopped);
  }

  final LanScannerRepository _lanScannerRepository;

  @override
  Future<void> close() {
    _lanScannerRepository.dispose();

    return super.close();
  }

  Future<void> _onStarted(
    LanScannerStarted event,
    Emitter<LanScannerState> emit,
  ) async {
    final ip = await NetworkInfo().getWifiIP();
    final subnet = ipToSubnet(ip!);

    final stream = _lanScannerRepository.getLanScannerStream(
      subnet: subnet,
      callback: (progress) {
        add(LanScannerProgressUpdated(progress));
      },
    );

    await emit.onEach(
      stream,
      onData: (HostModel host) {
        add(LanScannerNewHostDetected(host));
      },
    );

    emit(const LanScannerRunComplete());
  }

  void _onNewHostDetected(
    LanScannerNewHostDetected event,
    Emitter<LanScannerState> emit,
  ) {
    emit(LanScannerRunHostFound(event.host));
  }

  void _onProgressUpdated(
    LanScannerProgressUpdated event,
    Emitter<LanScannerState> emit,
  ) {
    emit(LanScannerRunProgressUpdate(event.progress));
  }

  void _onStopped(LanScannerStopped event, Emitter<LanScannerState> emit) {
    _lanScannerRepository.dispose();

    emit(const LanScannerRunComplete());
  }
}
