part of 'dns_lookup_bloc.dart';

abstract class DnsLookupState extends Equatable {
  const DnsLookupState();

  @override
  List<Object> get props => [];
}

class DnsLookupInitial extends DnsLookupState {}

class DnsLookupLoadInProgress extends DnsLookupState {}

class DnsLookupLoadSuccess extends DnsLookupState {
  const DnsLookupLoadSuccess(this.response);

  final DnsLookupResponse response;

  @override
  List<Object> get props => [response];
}

class DnsLookupLoadFailure extends DnsLookupState {}
