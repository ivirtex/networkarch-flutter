part of 'ping_bloc.dart';

@immutable
abstract class PingEvent {}

class PingStarted extends PingEvent {
  PingStarted(this.host);

  final String host;
}

class PingStopped extends PingEvent {
  PingStopped();
}
