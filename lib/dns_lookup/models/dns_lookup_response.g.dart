// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsLookupResponse _$DnsLookupResponseFromJson(Map<String, dynamic> json) =>
    DnsLookupResponse(
      json['Status'] as int,
      (json['Question'] as List<dynamic>)
          .map((e) => DnsQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['Answer'] as List<dynamic>)
          .map((e) => DnsRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['Comment'] as String?,
    );

Map<String, dynamic> _$DnsLookupResponseToJson(DnsLookupResponse instance) =>
    <String, dynamic>{
      'Status': instance.status,
      'Question': instance.question.map((e) => e.toJson()).toList(),
      'Answer': instance.answer.map((e) => e.toJson()).toList(),
      'Comment': instance.comment,
    };
