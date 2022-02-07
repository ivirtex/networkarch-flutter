part of 'permissions_bloc.dart';

abstract class PermissionsState extends Equatable {
  const PermissionsState();

  @override
  List<Object> get props => [];
}

class PermissionsInitial extends PermissionsState {}

class PermissionsLocationStatusChange extends PermissionsState {
  const PermissionsLocationStatusChange({
    required this.status,
  });

  final PermissionStatus status;

  @override
  List<Object> get props => [status];
}
