// Package imports:
import 'package:network_info_plus/network_info_plus.dart';

// Project imports:
import 'package:network_arch/network_status/models/models.dart';

class WifiDataProvider {
  NetworkInfo networkInfo = NetworkInfo();

  Future<WifiInfoModel> getWifiData() async {
    return WifiInfoModel(
      wifiSSID: await networkInfo.getWifiName(),
      wifiBSSID: await networkInfo.getWifiBSSID(),
      wifiIPv4: await networkInfo.getWifiIP(),
      wifiIPv6: await networkInfo.getWifiIPv6(),
      wifiBroadcast: await networkInfo.getWifiBroadcast(),
      wifiGateway: await networkInfo.getWifiGatewayIP(),
      wifiSubmask: await networkInfo.getWifiSubmask(),
    );
  }
}
