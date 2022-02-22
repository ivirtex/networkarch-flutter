// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsLookupResponse _$DnsLookupResponseFromJson(Map<String, dynamic> json) =>
    DnsLookupResponse(
      json['status'] as int,
      (json['question'] as List<dynamic>)
          .map((e) => DnsQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['answer'] as List<dynamic>)
          .map((e) => DnsRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['comment'] as String?,
    );

Map<String, dynamic> _$DnsLookupResponseToJson(DnsLookupResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'question': instance.question,
      'answer': instance.answer,
      'comment': instance.comment,
    };
