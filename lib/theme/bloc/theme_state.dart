// ignore_for_file: sort_constructors_first

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    this.mode = ThemeMode.system,
    this.scheme = FlexScheme.blue,
  });

  final ThemeMode mode;
  final FlexScheme scheme;

  @override
  List<Object> get props => [mode, scheme];

  ThemeState copyWith({
    ThemeMode? mode,
    FlexScheme? scheme,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      scheme: scheme ?? this.scheme,
    );
  }

  factory ThemeState.fromJson(Map<String, dynamic> map) {
    return ThemeState(
      mode: EnumToString.fromString(ThemeMode.values, map['mode'] as String)!,
      scheme:
          EnumToString.fromString(FlexScheme.values, map['scheme'] as String)!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'scheme': scheme.name,
    };
  }
}
