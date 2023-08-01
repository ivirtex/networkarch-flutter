// Package imports:
import 'package:carrier_info/carrier_info.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';

class CarrierDataProvider {
  Future<CarrierInfoModel?> getCellularData() async {
    final android = await CarrierInfo.getAndroidInfo();
    final ios = await CarrierInfo.getIosInfo();

    return CarrierInfoModel(
      androidCarrierData: android,
      iosCarrierData: ios,
    );
  }

  Future<PermissionStatus> getPermissionStatus() {
    return Permission.phone.status;
  }
}
