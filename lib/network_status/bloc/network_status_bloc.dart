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
    emit(state.copyWith(status: NetworkStatus.loading));

    // TODO: Add separate streams for each data provider,
    // so connection status for wifi and carrier can be set separately.
    await emit.onEach<NetworkInfoModel>(
      _repository.getNetworkInfoStream(),
      onData: (NetworkInfoModel networkInfo) {
        emit(
          state.copyWith(
            status: NetworkStatus.success,
            carrierInfo: networkInfo.carrierInfo,
            wifiInfo: networkInfo.wifiInfo,
          ),
        );
      },
      // getNetworkInfoStream() stream doesn't add any errors to the sink for now.
      onError: (Object error, StackTrace stackTrace) {
        emit(
          state.copyWith(
            status: NetworkStatus.failure,
            error: error,
          ),
        );
      },
    );
  }

  Future<void> _onExtIPRequested(
    NetworkStatusExtIPRequested event,
    Emitter<NetworkStatusState> emit,
  ) async {
    emit(state.copyWith(extIpStatus: ExtIpStatus.loading));

    final ip = await _repository.fetchExternalIp();

    emit(
      state.copyWith(
        extIP: ip,
        extIpStatus: ip != null ? ExtIpStatus.success : ExtIpStatus.failure,
      ),
    );
  }
}
