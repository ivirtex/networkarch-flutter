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
  // TODO: Start listening to the stream by default
  NetworkStatusBloc(this._repository) : super(const NetworkStatusInitial()) {
    on<NetworkStatusStreamStarted>(_onStarted);
    on<NetworkStatusUpdatedEvent>(_onUpdated);
    on<NetworkStatusUpdatedWithExtIPEvent>(_onUpdatedWithExtIP);
  }

  final NetworkStatusRepository _repository;

  FutureOr<void> _onStarted(
    NetworkStatusStreamStarted event,
    Emitter<NetworkStatusState> emit,
  ) async {
    emit(const NetworkStatusUpdateInProgress());

    await emit.onEach<NetworkInfoModel>(
      _repository.getNetworkInfoStream(),
      onData: (NetworkInfoModel networkInfo) {
        add(
          NetworkStatusUpdatedEvent(
            wifiInfoModel: networkInfo.wifiInfo,
            carrierInfoModel: networkInfo.carrierInfo,
          ),
        );
      },
    );
  }

  FutureOr<void> _onUpdated(
    NetworkStatusUpdatedEvent event,
    Emitter<NetworkStatusState> emit,
  ) {
    emit(
      NetworkStatusUpdateSuccess(
        wifiInfo: event.wifiInfoModel,
        carrierInfo: event.carrierInfoModel,
      ),
    );
  }

  FutureOr<void> _onUpdatedWithExtIP(
    NetworkStatusUpdatedWithExtIPEvent event,
    Emitter<NetworkStatusState> emit,
  ) {
    emit(
      NetworkStatusUpdateWithExtIPSuccess(
        wifiInfo: event.wifiInfoModel,
        carrierInfo: event.carrierInfoModel,
        extIP: event.extIP,
      ),
    );
  }
}
