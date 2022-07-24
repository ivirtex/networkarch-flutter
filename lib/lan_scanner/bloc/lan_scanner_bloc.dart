// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:network_info_plus/network_info_plus.dart';

// Project imports:
import 'package:network_arch/lan_scanner/repository/lan_scanner_repository.dart';
import 'package:network_tools/network_tools.dart';

part 'lan_scanner_event.dart';
part 'lan_scanner_state.dart';

class LanScannerBloc extends Bloc<LanScannerEvent, LanScannerState> {
  LanScannerBloc(this._lanScannerRepository)
      : super(const LanScannerInitial()) {
    on<LanScannerStarted>(_onStarted);
    on<LanScannerProgressUpdated>(_onProgressUpdated);
    on<LanScannerHostFound>(_onHostFound);
    on<LanScannerStopped>(_onStopped);
    on<LanScannerCompleted>(_onCompleted);
  }

  final LanScannerRepository _lanScannerRepository;

  Future<void> _onStarted(
    LanScannerStarted event,
    Emitter<LanScannerState> emit,
  ) async {
    final ip = await NetworkInfo().getWifiIP();
    final subnet = ip!.substring(0, ip.lastIndexOf('.'));

    final stream = _lanScannerRepository.getLanScannerStream(
      subnet: subnet,
      callback: (progress) {
        if (!isClosed) {
          add(LanScannerProgressUpdated(progress));
        }
      },
    );

    _lanScannerRepository.subscription = stream.listen(
      (ActiveHost host) {
        add(LanScannerHostFound(host));
      },
      onDone: () {
        add(LanScannerCompleted());
      },
    );
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
    _lanScannerRepository.dispose();

    emit(const LanScannerRunStop());
  }

  void _onCompleted(
    LanScannerCompleted event,
    Emitter<LanScannerState> emit,
  ) {
    emit(const LanScannerRunComplete());
  }
}
