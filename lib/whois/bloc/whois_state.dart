part of 'whois_bloc.dart';

abstract class WhoisState extends Equatable {
  const WhoisState();

  @override
  List<Object> get props => [];
}

class WhoisInitial extends WhoisState {}

class WhoisLoadInProgress extends WhoisState {}

class WhoisLoadSuccess extends WhoisState {
  const WhoisLoadSuccess(this.response);

  final String response;
}

class WhoisLoadFailure extends WhoisState {}
