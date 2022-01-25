part of 'ping_bloc.dart';

@immutable
abstract class PingState {}

class PingInitial extends PingState {}

class PingRunInProgress extends PingState {
  PingRunInProgress(this.pingStream);

  final Stream<PingData> pingStream;
}

class PingRunComplete extends PingState {}
