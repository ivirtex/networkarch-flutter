// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:network_arch/ip_geo/models/ip_geo_response.dart';
import 'package:network_arch/ip_geo/repository/ip_geo_repository.dart';

part 'ip_geo_event.dart';
part 'ip_geo_state.dart';

class IpGeoBloc extends Bloc<IpGeoEvent, IpGeoState> {
  IpGeoBloc(IpGeoRepository ipGeoRepository)
      : _ipGeoRepository = ipGeoRepository,
        super(IpGeoInitial()) {
    on<IpGeoRequested>(_onRequested);
  }

  final IpGeoRepository _ipGeoRepository;

  Future<void> _onRequested(
    IpGeoRequested event,
    Emitter<IpGeoState> emit,
  ) async {
    emit(IpGeoLoadInProgress());

    try {
      final IpGeoResponse response =
          await _ipGeoRepository.getIpGeolocation(event.ip);

      emit(IpGeoLoadSuccess(response));
    } on Exception {
      emit(IpGeoLoadFailure());
    }
  }
}
