part of 'network_state_bloc.dart';

enum NetworkStatus { inital, loading, success, failure }
enum ExtIpStatus { inital, loading, success, failure }

class NetworkState extends Equatable {
  const NetworkState({
    this.status = NetworkStatus.inital,
    this.extIpStatus = ExtIpStatus.inital,
    this.wifiInfo,
    this.carrierInfo,
    this.extIP,
  });

  final NetworkStatus status;
  final ExtIpStatus extIpStatus;
  final WifiInfoModel? wifiInfo;
  final CarrierInfoModel? carrierInfo;
  final String? extIP;

  @override
  List<Object?> get props =>
      [status, extIpStatus, wifiInfo, carrierInfo, extIP];

  NetworkState copyWith({
    NetworkStatus? status,
    ExtIpStatus? extIpStatus,
    WifiInfoModel? wifiInfo,
    CarrierInfoModel? carrierInfo,
    String? extIP,
  }) {
    return NetworkState(
      status: status ?? this.status,
      extIpStatus: extIpStatus ?? this.extIpStatus,
      wifiInfo: wifiInfo ?? this.wifiInfo,
      carrierInfo: carrierInfo ?? this.carrierInfo,
      extIP: extIP ?? this.extIP,
    );
  }
}
