// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'dns_question.g.dart';

@JsonSerializable()
class DnsQuestion {
  DnsQuestion(this.name, this.type);

  factory DnsQuestion.fromJson(Map<String, dynamic> json) =>
      _$DnsQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$DnsQuestionToJson(this);

  final String name;
  final int type;
}
