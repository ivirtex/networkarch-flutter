part of 'ping_bloc.dart';

@immutable
abstract class PingState {}

class PingInitial extends PingState {}

class PingRunNewData extends PingState {
  PingRunNewData(this.pingData);

  final PingData pingData;
}

class PingRunComplete extends PingState {}
