part of 'whois_bloc.dart';

abstract class WhoisEvent extends Equatable {
  const WhoisEvent();

  @override
  List<Object> get props => [];
}

class WhoisRequested extends WhoisEvent {
  const WhoisRequested({required this.domain});

  final String domain;

  @override
  List<Object> get props => [domain];
}
