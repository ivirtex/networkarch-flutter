part of 'ip_geo_bloc.dart';

abstract class IpGeoState extends Equatable {
  const IpGeoState();

  @override
  List<Object> get props => [];
}

class IpGeoInitial extends IpGeoState {}

class IpGeoLoadInProgress extends IpGeoState {}

class IpGeoLoadSuccess extends IpGeoState {
  const IpGeoLoadSuccess(this.ipGeoModel);

  final IpGeoResponse ipGeoModel;

  @override
  List<Object> get props => [ipGeoModel];
}

class IpGeoLoadFailure extends IpGeoState {}
