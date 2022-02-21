part of 'network_status_bloc.dart';

class NetworkStatusState extends Equatable {
  const NetworkStatusState({
    this.status = NetworkStatus.inital,
    this.extIpStatus = ExtIpStatus.inital,
    this.wifiInfo,
    this.carrierInfo,
    this.extIP,
    this.error,
  });

  final NetworkStatus status;
  final ExtIpStatus extIpStatus;
  final WifiInfoModel? wifiInfo;
  final CarrierInfoModel? carrierInfo;
  final String? extIP;
  final Object? error;

  @override
  List<Object?> get props =>
      [status, extIpStatus, wifiInfo, carrierInfo, extIP];

  NetworkStatusState copyWith({
    NetworkStatus? status,
    ExtIpStatus? extIpStatus,
    WifiInfoModel? wifiInfo,
    CarrierInfoModel? carrierInfo,
    String? extIP,
    Object? error,
  }) {
    return NetworkStatusState(
      status: status ?? this.status,
      extIpStatus: extIpStatus ?? this.extIpStatus,
      wifiInfo: wifiInfo ?? this.wifiInfo,
      carrierInfo: carrierInfo ?? this.carrierInfo,
      extIP: extIP ?? this.extIP,
      error: error ?? this.error,
    );
  }
}

enum NetworkStatus { inital, loading, success, failure }
enum ExtIpStatus { inital, loading, success, failure }
