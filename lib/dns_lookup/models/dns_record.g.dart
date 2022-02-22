// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsRecord _$DnsRecordFromJson(Map<String, dynamic> json) => DnsRecord(
      json['name'] as String,
      json['type'] as String,
      json['ttl'] as int,
      json['data'] as String,
    );

Map<String, dynamic> _$DnsRecordToJson(DnsRecord instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'ttl': instance.ttl,
      'data': instance.data,
    };
