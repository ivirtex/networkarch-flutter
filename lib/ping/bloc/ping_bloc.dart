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
    on<PingStopped>(_onStopped);
  }

  final PingRepository _pingRepository;

  @override
  Future<void> close() {
    _pingRepository.subscription?.cancel();

    return super.close();
  }

  void _onStarted(PingStarted event, Emitter<PingState> emit) {
    final stream = _pingRepository.getPingStream(host: event.host);

    emit(PingRunInProgress(stream));
  }

  void _onStopped(PingStopped event, Emitter<PingState> emit) {
    final subscription = _pingRepository.subscription;

    subscription?.cancel();
    emit(PingRunComplete());
  }
}
