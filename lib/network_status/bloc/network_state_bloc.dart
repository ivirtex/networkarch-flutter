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

part 'network_state_event.dart';
part 'network_state_state.dart';

class NetworkStateBloc extends Bloc<NetworkStateEvent, NetworkState> {
  NetworkStateBloc(this._repository) : super(const NetworkState()) {
    on<NetworkStateStreamStarted>(_onStarted);
    on<NetworkStateExtIPRequested>(_onExtIPRequested);
  }

  final NetworkStatusRepository _repository;

  Future<void> _onStarted(
    NetworkStateStreamStarted event,
    Emitter<NetworkState> emit,
  ) async {
    emit(state.copyWith(status: NetworkStatus.loading));

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
    );
  }

  Future<void> _onExtIPRequested(
    NetworkStateExtIPRequested event,
    Emitter<NetworkState> emit,
  ) async {
    emit(state.copyWith(extIpStatus: ExtIpStatus.loading));

    final ip = await _repository.fetchExternalIp();

    emit(state.copyWith(extIP: ip, extIpStatus: ExtIpStatus.success));
  }
}
