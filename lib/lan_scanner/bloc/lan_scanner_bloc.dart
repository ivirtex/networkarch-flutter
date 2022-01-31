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
      : super(const LanScannerInitial(0.0)) {
    on<LanScannerStarted>(_onStarted);
    on<LanScannerProgressUpdated>(_onProgressUpdated);
    on<LanScannerStopped>(_onStopped);
  }

  final LanScannerRepository _lanScannerRepository;

  Future<void> _onStarted(
    LanScannerStarted event,
    Emitter<LanScannerState> emit,
  ) async {
    final ip = await NetworkInfo().getWifiIP();
    final subnet = ipToSubnet(ip!);

    final stream = _lanScannerRepository.getLanScannerStream(
      subnet: subnet,
      callback: event.callback,
    );

    emit(LanScannerRunStart(stream, 0.0));
  }

  void _onProgressUpdated(
    LanScannerProgressUpdated event,
    Emitter<LanScannerState> emit,
  ) {
    if (event.progress == 1.0) {
      emit(const LanScannerRunComplete(1.0));
    } else {
      emit(LanScannerRunProgressUpdate(event.progress));
    }
  }

  void _onStopped(LanScannerStopped event, Emitter<LanScannerState> emit) {
    final subscription = _lanScannerRepository.subscription;

    subscription?.cancel();
    emit(const LanScannerRunComplete(1.0));
  }
}
