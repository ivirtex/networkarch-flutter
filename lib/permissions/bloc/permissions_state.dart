part of 'permissions_bloc.dart';

abstract class PermissionsState extends Equatable {
  const PermissionsState();

  @override
  List<Object> get props => [];
}

class PermissionsInitial extends PermissionsState {}

class PermissionsStatusChange extends PermissionsState {
  const PermissionsStatusChange({
    required this.permission,
    required this.status,
  });

  final Permission permission;
  final PermissionStatus status;

  @override
  List<Object> get props => [permission, status];
}
