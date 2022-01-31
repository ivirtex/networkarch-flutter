part of 'network_status_bloc.dart';

abstract class NetworkStatusEvent extends Equatable {
  const NetworkStatusEvent();

  @override
  List<Object> get props => [];
}

class NetworkStatusStreamStarted extends NetworkStatusEvent {}

class NetworkStatusUpdatedEvent extends NetworkStatusEvent {
  const NetworkStatusUpdatedEvent({
    required this.wifiInfoModel,
    required this.carrierInfoModel,
  });

  final WifiInfoModel wifiInfoModel;
  final CarrierInfoModel carrierInfoModel;
}

class NetworkStatusUpdatedWithExtIPEvent extends NetworkStatusEvent {
  const NetworkStatusUpdatedWithExtIPEvent({
    required this.wifiInfoModel,
    required this.carrierInfoModel,
    required this.extIP,
  });

  final WifiInfoModel wifiInfoModel;
  final CarrierInfoModel carrierInfoModel;
  final String extIP;
}
