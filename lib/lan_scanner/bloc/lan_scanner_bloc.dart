// Dart imports:
// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    final subnet = ipToSubnet(ip!);

    final stream = _lanScannerRepository.getLanScannerStream(
      subnet: subnet,
      callback: (progress) {
        if (!isClosed) {
          add(LanScannerProgressUpdated(progress));
        }
      },
    );

    // await emit.forEach(
    //   stream,
    //   onData: (HostModel host) {
    //     return LanScannerRunHostFound(host);
    //   },
    // );

    _lanScannerRepository.subscription = stream.listen(
      (HostModel host) {
        add(LanScannerHostFound(host));
      },
      onDone: () {
        add(LanScannerCompleted());
      },
    );

    // emit(const LanScannerRunComplete());
  }

  void _onProgressUpdated(
    LanScannerProgressUpdated event,
    Emitter<LanScannerState> emit,
  ) {
    emit(LanScannerRunProgressUpdate(event.progress));
  }

  FutureOr<void> _onHostFound(
    LanScannerHostFound event,
    Emitter<LanScannerState> emit,
  ) {
    emit(LanScannerRunNewHost(event.host));
  }

  void _onStopped(LanScannerStopped event, Emitter<LanScannerState> emit) {
    _lanScannerRepository.dispose();

    emit(const LanScannerRunStop());
  }

  FutureOr<void> _onCompleted(
    LanScannerCompleted event,
    Emitter<LanScannerState> emit,
  ) {
    emit(const LanScannerRunComplete());
  }
}
