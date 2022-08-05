// Package imports:
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dns_record.g.dart';

@JsonSerializable()
class DnsRecord extends Equatable {
  const DnsRecord(this.name, this.type, this.ttl, this.data);

  factory DnsRecord.fromJson(Map<String, dynamic> json) =>
      _$DnsRecordFromJson(json);

  Map<String, dynamic> toJson() => _$DnsRecordToJson(this);

  final String name;
  final int type;
  @JsonKey(name: 'TTL')
  final int ttl;
  final String data;

  @override
  List<Object?> get props => [name, type, ttl, data];
}
