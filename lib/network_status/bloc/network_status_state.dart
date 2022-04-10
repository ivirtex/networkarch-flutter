part of 'network_status_bloc.dart';

class NetworkStatusState extends Equatable {
  const NetworkStatusState({
    this.wifiStatus = NetworkStatus.inital,
    this.carrierStatus = NetworkStatus.inital,
    this.extIpStatus = NetworkStatus.inital,
    this.wifiInfo,
    this.carrierInfo,
    this.extIP,
    this.error,
  });

  final NetworkStatus wifiStatus;
  final NetworkStatus carrierStatus;
  final NetworkStatus extIpStatus;
  final WifiInfoModel? wifiInfo;
  final CarrierInfoModel? carrierInfo;
  final String? extIP;
  final Object? error;

  bool get isWifiConnected => wifiInfo?.isWifiConnected ?? false;
  bool get isCarrierConnected => carrierInfo?.isCarrierConnected ?? false;

  @override
  List<Object?> get props => [
        wifiStatus,
        carrierStatus,
        extIpStatus,
        wifiInfo,
        carrierInfo,
        extIP,
        error,
      ];

  NetworkStatusState copyWith({
    NetworkStatus? wifiStatus,
    NetworkStatus? carrierStatus,
    NetworkStatus? extIpStatus,
    WifiInfoModel? wifiInfo,
    CarrierInfoModel? carrierInfo,
    String? extIP,
    Object? error,
  }) {
    return NetworkStatusState(
      wifiStatus: wifiStatus ?? this.wifiStatus,
      carrierStatus: carrierStatus ?? this.carrierStatus,
      extIpStatus: extIpStatus ?? this.extIpStatus,
      wifiInfo: wifiInfo ?? this.wifiInfo,
      carrierInfo: carrierInfo ?? this.carrierInfo,
      extIP: extIP ?? this.extIP,
      error: error ?? this.error,
    );
  }
}

enum NetworkStatus { inital, loading, success, failure, permissionIssue }
