// ignore_for_file: sort_constructors_first

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.scheme,
    this.mode = ThemeMode.system,
  });

  final CustomFlexScheme scheme;
  final ThemeMode mode;

  @override
  List<Object> get props => [mode, scheme];

  ThemeState copyWith({
    CustomFlexScheme? scheme,
    ThemeMode? mode,
  }) {
    return ThemeState(
      scheme: scheme ?? this.scheme,
      mode: mode ?? this.mode,
    );
  }

  factory ThemeState.fromJson(Map<String, dynamic> map) {
    return ThemeState(
      scheme: EnumToString.fromString(
        CustomFlexScheme.values,
        map['scheme'] as String,
      )!,
      mode: EnumToString.fromString(
        ThemeMode.values,
        map['mode'] as String,
      )!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheme': scheme.name,
      'mode': mode.name,
    };
  }
}
