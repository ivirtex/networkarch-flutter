// Package imports:
import 'package:carrier_info/carrier_info.dart';
import 'package:equatable/equatable.dart';

class CarrierInfoModel extends Equatable {
  const CarrierInfoModel({
    required this.androidCarrierData,
    required this.iosCarrierData,
  });

  final AndroidCarrierData? androidCarrierData;
  final IosCarrierData? iosCarrierData;

  bool get isCarrierConnected =>
      androidCarrierData?.isSmsCapable ??
      false ||
          iosCarrierData!.carrierData
              .any((element) => element.mobileNetworkCode != '');

  @override
  List<Object?> get props => [
        androidCarrierData,
        iosCarrierData,
      ];
}
