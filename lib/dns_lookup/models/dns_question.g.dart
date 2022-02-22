// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DnsQuestion _$DnsQuestionFromJson(Map<String, dynamic> json) => DnsQuestion(
      json['name'] as String,
      json['type'] as int,
    );

Map<String, dynamic> _$DnsQuestionToJson(DnsQuestion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };
