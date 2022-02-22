import 'package:json_annotation/json_annotation.dart';

part 'dns_record.g.dart';

@JsonSerializable()
class DnsRecord {
  DnsRecord(this.name, this.type, this.ttl, this.data);

  factory DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

  Map<String, dynamic> toJson() => _$DnsRecordToJson(this);

  final String name;
  final String type;
  final int ttl;
  final String data;
}
