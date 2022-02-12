part of 'ip_geo_bloc.dart';

abstract class IpGeoEvent extends Equatable {
  const IpGeoEvent();

  @override
  List<Object> get props => [];
}

class IpGeoRequested extends IpGeoEvent {
  const IpGeoRequested({required this.ip});

  final String ip;

  @override
  List<Object> get props => [ip];
}
