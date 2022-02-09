part of 'network_status_bloc.dart';

abstract class NetworkStatusState extends Equatable {
  const NetworkStatusState({this.wifiInfo, this.carrierInfo});

  final WifiInfoModel? wifiInfo;
  final CarrierInfoModel? carrierInfo;

  @override
  List<Object?> get props => [wifiInfo, carrierInfo];
}

class NetworkStatusInitial extends NetworkStatusState {
  const NetworkStatusInitial();
}

class NetworkStatusUpdateInProgress extends NetworkStatusState {
  const NetworkStatusUpdateInProgress();
}

class NetworkStatusUpdate extends NetworkStatusState {
  const NetworkStatusUpdate({
    required WifiInfoModel wifiInfo,
    required CarrierInfoModel carrierInfo,
  }) : super(wifiInfo: wifiInfo, carrierInfo: carrierInfo);
}

class NetworkStatusUpdateWithExtIP extends NetworkStatusState {
  const NetworkStatusUpdateWithExtIP({
    required WifiInfoModel wifiInfo,
    required CarrierInfoModel carrierInfo,
    required this.extIP,
  }) : super(wifiInfo: wifiInfo, carrierInfo: carrierInfo);

  final String extIP;

  @override
  List<Object?> get props => [
        wifiInfo,
        carrierInfo,
        extIP,
      ];
}

class NetworkStatusUpdateFailure extends NetworkStatusState {
  const NetworkStatusUpdateFailure();
}
