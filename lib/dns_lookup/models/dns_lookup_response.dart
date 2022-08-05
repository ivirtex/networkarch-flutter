// Package imports:
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:network_arch/dns_lookup/models/dns_question.dart';
import 'package:network_arch/dns_lookup/models/dns_record.dart';

part 'dns_lookup_response.g.dart';

@JsonSerializable(explicitToJson: true)
class DnsLookupResponse extends Equatable {
  const DnsLookupResponse(
    this.status,
    this.question,
    this.answer,
    this.comment,
  );

  factory DnsLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$DnsLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DnsLookupResponseToJson(this);

  @JsonKey(name: 'Status')
  final int status;

  @JsonKey(name: 'Question')
  final List<DnsQuestion> question;

  @JsonKey(name: 'Answer')
  final List<DnsRecord> answer;

  @JsonKey(name: 'Comment')
  final String? comment;

  @override
  List<Object?> get props => [status, question, answer, comment];
}
