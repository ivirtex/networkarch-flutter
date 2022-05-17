// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:json_annotation/json_annotation.dart';

class FlexSchemeColorConverter
    implements JsonConverter<FlexSchemeColor, Map<String, int>> {
  const FlexSchemeColorConverter();

  @override
  FlexSchemeColor fromJson(Map<String, dynamic> json) {
    return FlexSchemeColor(
      primary: Color(json['primary'] as int),
      primaryContainer: Color(json['primaryContainer'] as int),
      secondary: Color(json['secondary'] as int),
      secondaryContainer: Color(json['secondaryContainer'] as int),
      tertiary: Color(json['tertiary'] as int),
      tertiaryContainer: Color(json['tertiaryContainer'] as int),
      error: Color(json['error'] as int),
      errorContainer: Color(json['errorContainer'] as int),
    );
  }

  @override
  Map<String, int> toJson(FlexSchemeColor instance) {
    return {
      'primary': instance.primary.value,
      'primaryContainer': instance.primaryContainer.value,
      'secondary': instance.secondary.value,
      'secondaryContainer': instance.secondaryContainer.value,
      'tertiary': instance.tertiary.value,
      'tertiaryContainer': instance.tertiaryContainer.value,
      'error': instance.error!.value,
      'errorContainer': instance.errorContainer!.value,
    };
  }
}
