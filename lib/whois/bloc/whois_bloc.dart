// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:network_arch/whois/repository/whois_repository.dart';

part 'whois_event.dart';
part 'whois_state.dart';

class WhoisBloc extends Bloc<WhoisEvent, WhoisState> {
  WhoisBloc(WhoisRepository whoisRepository)
      : _whoisRepository = whoisRepository,
        super(WhoisInitial()) {
    on<WhoisRequested>(_onWhoisRequested);
  }

  final WhoisRepository _whoisRepository;

  Future<void> _onWhoisRequested(
    WhoisRequested event,
    Emitter<WhoisState> emit,
  ) async {
    emit(WhoisLoadInProgress());

    try {
      final response = await _whoisRepository.getWhois(event.domain);

      emit(WhoisLoadSuccess(response));
    } on Exception {
      emit(WhoisLoadFailure());
    }
  }
}
