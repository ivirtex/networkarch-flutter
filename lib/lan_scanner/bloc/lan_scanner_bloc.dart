// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:lan_scanner/lan_scanner.dart';

part 'lan_scanner_event.dart';
part 'lan_scanner_state.dart';

class LanScannerBloc extends Bloc<LanScannerEvent, LanScannerState> {
  LanScannerBloc() : super(const LanScannerInitial()) {
    on<LanScannerStarted>(_onStarted);
    on<LanScannerProgressUpdated>(_onProgressUpdated);
    on<LanScannerHostFound>(_onHostFound);
    on<LanScannerStopped>(_onStopped);
    on<LanScannerCompleted>(_onCompleted);
  }

  Future<void> _onStarted(
    LanScannerStarted event,
    Emitter<LanScannerState> emit,
  ) async {
    final ip = await NetworkInfo().getWifiIP();
    final subnet = ip!.substring(0, ip.lastIndexOf('.'));

    final scanner = LanScanner();

    if (Platform.isIOS) {
      await scanner.quickIcmpScanSync(subnet);
    } else {
      await scanner.quickIcmpScanAsync(subnet);
    }

    emit(const LanScannerRunStart());
  }

  void _onProgressUpdated(
    LanScannerProgressUpdated event,
    Emitter<LanScannerState> emit,
  ) {
    emit(LanScannerRunProgressUpdate(event.progress));
  }

  void _onHostFound(
    LanScannerHostFound event,
    Emitter<LanScannerState> emit,
  ) {
    emit(LanScannerRunNewHost(event.host));
  }

  void _onStopped(LanScannerStopped event, Emitter<LanScannerState> emit) {
    emit(const LanScannerRunStop());
  }

  void _onCompleted(
    LanScannerCompleted event,
    Emitter<LanScannerState> emit,
  ) {
    emit(const LanScannerRunComplete());
  }
}
