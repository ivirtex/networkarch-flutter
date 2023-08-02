// Package imports:
import 'package:equatable/equatable.dart';

class CarrierInfoModel extends Equatable {
  const CarrierInfoModel({
    required this.allowsVOIP,
    this.carrierName,
    this.isoCountryCode,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.mobileNetworkOperator,
    this.networkGeneration,
    this.radioType,
  });

  final bool allowsVOIP;
  final String? carrierName;
  final String? isoCountryCode;
  final String? mobileCountryCode;
  final String? mobileNetworkCode;
  final String? mobileNetworkOperator;
  final String? networkGeneration;
  final String? radioType;

  bool get isCarrierConnected => carrierName != null;

  @override
  List<Object?> get props => [
        allowsVOIP,
        carrierName,
        isoCountryCode,
        mobileCountryCode,
        mobileNetworkCode,
        mobileNetworkOperator,
        networkGeneration,
        radioType,
      ];
}
