// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(const PermissionsState()) {
    on<PermissionsStatusRefreshRequested>(_onRefreshPermissionsStatus);
    on<PermissionsLocationRequested>(_onRequestLocationPermission);
    on<PermissionsPhoneStateRequested>(_onRequestPhoneStatePermission);
  }

  Future<void> _onRefreshPermissionsStatus(
    PermissionsStatusRefreshRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    const location = Permission.locationWhenInUse;
    const phoneState = Permission.phone;

    final locationStatus = await location.status;
    final phoneStateStatus = await phoneState.status;

    emit(
      PermissionsState(
        locationStatus: locationStatus,
        phoneStateStatus: phoneStateStatus,
      ),
    );
  }

  Future<void> _onRequestLocationPermission(
    PermissionsLocationRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    const permission = Permission.locationWhenInUse;

    final status = await permission.request();

    emit(
      state.copyWith(
        locationStatus: status,
        latestRequested: permission,
      ),
    );
  }

  Future<void> _onRequestPhoneStatePermission(
    PermissionsPhoneStateRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    const permission = Permission.phone;

    final status = await permission.request();

    emit(
      state.copyWith(
        phoneStateStatus: status,
        latestRequested: permission,
      ),
    );
  }
}
