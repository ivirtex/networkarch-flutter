part of 'network_status_bloc.dart';

abstract class NetworkStatusEvent {
  const NetworkStatusEvent();
}

class NetworkStatusStreamStarted extends NetworkStatusEvent {}

class NetworkStatusExtIPRequested extends NetworkStatusEvent {}
