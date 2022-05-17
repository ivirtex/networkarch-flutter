// ignore_for_file: sort_constructors_first

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.scheme,
    this.dynamicScheme,
    this.mode = ThemeMode.system,
  });

  final CustomFlexScheme scheme;
  final FlexSchemeData? dynamicScheme;
  final ThemeMode mode;

  @override
  List<Object?> get props => [scheme, dynamicScheme, mode];

  ThemeState copyWith({
    CustomFlexScheme? scheme,
    FlexSchemeData? dynamicScheme,
    ThemeMode? mode,
  }) {
    return ThemeState(
      scheme: scheme ?? this.scheme,
      dynamicScheme: dynamicScheme ?? this.dynamicScheme,
      mode: mode ?? this.mode,
    );
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      scheme: EnumToString.fromString(
        CustomFlexScheme.values,
        json['scheme'] as String,
      )!,
      dynamicScheme: const FlexSchemeDataConverter()
          .fromJson(json['dynamicScheme'] as Map<String, dynamic>),
      mode: EnumToString.fromString(
        ThemeMode.values,
        json['mode'] as String,
      )!,
    );
  }

  Map<String, dynamic> toJson(ThemeState instance) {
    return dynamicScheme != null
        ? {
            'scheme': instance.scheme.name,
            'dynamicScheme':
                const FlexSchemeDataConverter().toJson(instance.dynamicScheme!),
            'mode': instance.mode.name,
          }
        : {
            'scheme': instance.scheme.name,
            'mode': instance.mode.name,
          };
  }
}
