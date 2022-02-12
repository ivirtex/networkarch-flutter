import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ip_geo_response.g.dart';

@JsonSerializable()
class IpGeoResponse extends Equatable {
  const IpGeoResponse({
    this.query,
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.as,
  });

  factory IpGeoResponse.fromJson(Map<String, dynamic> json) =>
      _$IpGeoResponseFromJson(json);

  void toJson(Map<String, dynamic> json) => _$IpGeoResponseToJson(this);

  final String? query;
  final String? status;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionName;
  final String? city;
  final String? zip;
  final double? lat;
  final double? lon;
  final String? timezone;
  final String? isp;
  final String? org;
  final String? as;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      query,
      status,
      country,
      countryCode,
      region,
      regionName,
      city,
      zip,
      lat,
      lon,
      timezone,
      isp,
      org,
      as,
    ];
  }
}
