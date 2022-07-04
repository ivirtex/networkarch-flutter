// Package imports:
// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:network_arch/ping/repository/ping_repository.dart';

part 'ping_event.dart';
part 'ping_state.dart';

class PingBloc extends Bloc<PingEvent, PingState> {
  PingBloc(this._pingRepository) : super(PingInitial()) {
    on<PingStarted>(_onStarted);
    on<PingNewDataAdded>(_onNewDataAdded);
    on<PingStopped>(_onStopped);
  }

  final PingRepository _pingRepository;
  String? target;

  @override
  Future<void> close() {
    _pingRepository.dispose();

    return super.close();
  }

  void _onStarted(PingStarted event, Emitter<PingState> emit) {
    final stream = _pingRepository.getPingStream(host: event.target);
    target = event.target;

    _pingRepository.subscription = stream.listen((ping) {
      add(PingNewDataAdded(ping));
    });
  }

  void _onNewDataAdded(PingNewDataAdded event, Emitter<PingState> emit) {
    emit(PingRunNewData(event.data));
  }

  void _onStopped(PingStopped event, Emitter<PingState> emit) {
    _pingRepository.dispose();

    emit(PingRunComplete());
  }
}
