import 'package:network_arch/network_status/models/models.dart';

class NetworkInfoModel {
  NetworkInfoModel({
    required this.wifiInfo,
    required this.carrierInfo,
    this.externalIP,
  });

  final WifiInfoModel wifiInfo;
  final CarrierInfoModel carrierInfo;
  final String? externalIP;
}
