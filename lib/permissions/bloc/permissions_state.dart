part of 'permissions_bloc.dart';

class PermissionsState extends Equatable {
  const PermissionsState({
    this.locationStatus,
    this.phoneStateStatus,
    this.latestRequested,
  });

  final PermissionStatus? locationStatus;
  final PermissionStatus? phoneStateStatus;
  final Permission? latestRequested;

  @override
  List<Object?> get props => [locationStatus, phoneStateStatus];

  PermissionsState copyWith({
    PermissionStatus? locationStatus,
    PermissionStatus? phoneStateStatus,
    Permission? latestRequested,
  }) {
    return PermissionsState(
      locationStatus: locationStatus ?? this.locationStatus,
      phoneStateStatus: phoneStateStatus ?? this.phoneStateStatus,
      latestRequested: latestRequested ?? this.latestRequested,
    );
  }
}
