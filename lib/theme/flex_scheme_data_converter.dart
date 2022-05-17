// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

class FlexSchemeDataConverter
    implements JsonConverter<FlexSchemeData, Map<String, dynamic>> {
  const FlexSchemeDataConverter();

  @override
  FlexSchemeData fromJson(Map<String, dynamic> json) {
    return FlexSchemeData(
      name: json['name'] as String,
      description: json['description'] as String,
      light: const FlexSchemeColorConverter()
          .fromJson(json['light'] as Map<String, dynamic>),
      dark: const FlexSchemeColorConverter()
          .fromJson(json['dark'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson(FlexSchemeData instance) {
    return {
      'name': instance.name,
      'description': instance.description,
      'light': const FlexSchemeColorConverter().toJson(instance.light),
      'dark': const FlexSchemeColorConverter().toJson(instance.dark),
    };
  }
}
