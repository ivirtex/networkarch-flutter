// Dart imports:
// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:network_arch/network_status/models/models.dart';
import 'package:network_arch/network_status/repository/repository.dart';

part 'network_status_event.dart';
part 'network_status_state.dart';

class NetworkStatusBloc extends Bloc<NetworkStatusEvent, NetworkStatusState> {
  NetworkStatusBloc(this._repository) : super(const NetworkStatusState()) {
    on<NetworkStatusStreamStarted>(_onStarted);
    on<NetworkStatusExtIPRequested>(_onExtIPRequested);
  }

  final NetworkStatusRepository _repository;

  Future<void> _onStarted(
    NetworkStatusStreamStarted event,
    Emitter<NetworkStatusState> emit,
  ) async {
    emit(
      state.copyWith(
        wifiStatus: NetworkStatus.loading,
        carrierStatus: NetworkStatus.loading,
      ),
    );

    await Future.wait([
      emit.onEach(
        _repository.getWifiInfoStream(),
        onData: (WifiInfoModel wifiData) {
          emit(
            state.copyWith(
              wifiStatus: NetworkStatus.success,
              wifiInfo: wifiData,
            ),
          );
        },
        // getWifiInfoStream() adds error only if permission is denied
        onError: (Object error, StackTrace stackTrace) {
          emit(
            state.copyWith(
              wifiStatus: error as NetworkStatus,
              error: error,
            ),
          );
        },
      ),
      emit.onEach(
        _repository.getCarrierInfoStream(),
        onData: (CarrierInfoModel carrierData) {
          emit(
            state.copyWith(
              carrierStatus: NetworkStatus.success,
              carrierInfo: carrierData,
            ),
          );
        },
        // getCarrierInfoStream() adds error only if permission is denied
        onError: (Object error, StackTrace stackTrace) {
          emit(
            state.copyWith(
              carrierStatus: error as NetworkStatus,
              error: error,
            ),
          );
        },
      ),
    ]);
  }

  Future<void> _onExtIPRequested(
    NetworkStatusExtIPRequested event,
    Emitter<NetworkStatusState> emit,
  ) async {
    emit(state.copyWith(extIpStatus: NetworkStatus.loading));

    final ip = await _repository.fetchExternalIp();

    emit(
      state.copyWith(
        extIP: ip,
        extIpStatus: ip != null ? NetworkStatus.success : NetworkStatus.failure,
      ),
    );
  }
}
