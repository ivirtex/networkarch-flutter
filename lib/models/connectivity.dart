// Dart imports:
import 'dart:async';

// Package imports:
import 'package:carrier_info/carrier_info.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Connectivity {
  Stream<Map<int, Object>> _wifiInfoStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));

      //TODO: Put in seperate class
      // Await for all class values before yielding them
      var data = await Future.wait([
        NetworkInfo().getWifiBSSID(), // 0
        NetworkInfo().getWifiIP(), // 1
        NetworkInfo().getWifiName(), // 2
      ]);

      yield data.asMap();
    }
  }

  Stream<CarrierData> _cellularInfoStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));

      yield await CarrierInfo.all;
    }
  }

  Stream<Map<int, Object>> get getWifiInfoStream {
    return _wifiInfoStream();
  }

  Stream<CarrierData> get getCellularInfoStream {
    return _cellularInfoStream();
  }
}

// class SynchronousNetworkInfo {
//   SynchronousNetworkInfo(NetworkInfo networkInfo);

//   var locationServiceAuthorizationStatus;
//   var locationServiceAuthorization;
//   var wifiBSSID;
//   var wifiIP;
//   var wifiName;
// }
