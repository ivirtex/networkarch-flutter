part of 'network_status_bloc.dart';

abstract class NetworkStatusState extends Equatable {
  const NetworkStatusState({this.wifiInfo, this.carrierInfo});

  final WifiInfoModel? wifiInfo;
  final CarrierInfoModel? carrierInfo;

  @override
  List<Object> get props => [wifiInfo.hashCode, carrierInfo.hashCode];
}

class NetworkStatusInitial extends NetworkStatusState {
  const NetworkStatusInitial();
}

class NetworkStatusUpdateInProgress extends NetworkStatusState {
  const NetworkStatusUpdateInProgress();
}

class NetworkStatusUpdateSuccess extends NetworkStatusState {
  const NetworkStatusUpdateSuccess({
    required WifiInfoModel wifiInfo,
    required CarrierInfoModel carrierInfo,
  }) : super(wifiInfo: wifiInfo, carrierInfo: carrierInfo);

  @override
  List<Object> get props => [wifiInfo.hashCode, carrierInfo.hashCode];
}

class NetworkStatusUpdateWithExtIPSuccess extends NetworkStatusState {
  const NetworkStatusUpdateWithExtIPSuccess({
    required WifiInfoModel wifiInfo,
    required CarrierInfoModel carrierInfo,
    required this.extIP,
  }) : super(wifiInfo: wifiInfo, carrierInfo: carrierInfo);

  final String extIP;

  @override
  List<Object> get props => [
        wifiInfo.hashCode,
        carrierInfo.hashCode,
        extIP,
      ];
}

class NetworkStatusUpdateFailure extends NetworkStatusState {
  const NetworkStatusUpdateFailure();
}
