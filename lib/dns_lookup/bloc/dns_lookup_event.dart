part of 'dns_lookup_bloc.dart';

abstract class DnsLookupEvent extends Equatable {
  const DnsLookupEvent();

  @override
  List<Object> get props => [];
}

class DnsLookupRequested extends DnsLookupEvent {
  const DnsLookupRequested({required this.hostname, required this.type});

  final String hostname;
  final int type;

  @override
  List<Object> get props => [hostname, type];
}
