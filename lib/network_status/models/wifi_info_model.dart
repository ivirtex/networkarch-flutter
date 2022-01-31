// Package imports:
import 'package:network_info_plus/network_info_plus.dart';

class WifiInfoModel {
  WifiInfoModel({
    this.locationServiceAuthorizationStatus,
    this.locationServiceAuthorization,
    this.wifiSSID,
    this.wifiBSSID,
    this.wifiIPv4,
    this.wifiIPv6,
    this.wifiBroadcast,
    this.wifiGateway,
    this.wifiSubmask,
  });

  final LocationAuthorizationStatus? locationServiceAuthorizationStatus;
  final LocationAuthorizationStatus? locationServiceAuthorization;
  final String? wifiSSID;
  final String? wifiBSSID;
  final String? wifiIPv4;
  final String? wifiIPv6;
  final String? wifiBroadcast;
  final String? wifiGateway;
  final String? wifiSubmask;
}
