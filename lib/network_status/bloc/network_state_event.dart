part of 'network_state_bloc.dart';

abstract class NetworkStateEvent {
  const NetworkStateEvent();
}

class NetworkStateStreamStarted extends NetworkStateEvent {}

class NetworkStateExtIPRequested extends NetworkStateEvent {}
