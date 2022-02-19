part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class PermissionsStatusRefreshRequested extends PermissionsEvent {
  const PermissionsStatusRefreshRequested();
}

class PermissionsLocationRequested extends PermissionsEvent {
  const PermissionsLocationRequested();

  @override
  List<Object> get props => [];
}

class PermissionsPhoneStateRequested extends PermissionsEvent {
  const PermissionsPhoneStateRequested();

  @override
  List<Object> get props => [];
}
