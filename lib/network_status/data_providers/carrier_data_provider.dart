// Package imports:
import 'package:carrier_info/carrier_info.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/network_status/models/models.dart';

class CarrierDataProvider {
  Future<CarrierInfoModel> getCellularData() async {
    return CarrierInfoModel(
      allowsVOIP: await CarrierInfo.allowsVOIP,
      carrierName: await CarrierInfo.carrierName,
      isoCountryCode: await CarrierInfo.isoCountryCode,
      mobileCountryCode: await CarrierInfo.mobileCountryCode,
      mobileNetworkCode: await CarrierInfo.mobileNetworkCode,
      networkGeneration: await CarrierInfo.networkGeneration,
      radioType: await CarrierInfo.radioType,
    );
  }

  Future<PermissionStatus> getPermissionStatus() {
    return Permission.phone.status;
  }
}
