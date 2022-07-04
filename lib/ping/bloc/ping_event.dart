part of 'ping_bloc.dart';

@immutable
abstract class PingEvent {}

class PingStarted extends PingEvent {
  PingStarted(this.target);

  final String target;
}

class PingNewDataAdded extends PingEvent {
  PingNewDataAdded(this.data);

  final PingData data;
}

class PingStopped extends PingEvent {
  PingStopped();
}
