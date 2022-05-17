part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeModeChangedEvent extends ThemeEvent {
  const ThemeModeChangedEvent({required this.themeMode});

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

class ThemeSchemeChangedEvent extends ThemeEvent {
  const ThemeSchemeChangedEvent({required this.scheme});

  final CustomFlexScheme scheme;

  @override
  List<Object> get props => [scheme];
}

class ThemeDynamicSchemeChangedEvent extends ThemeEvent {
  const ThemeDynamicSchemeChangedEvent({required this.dynamicScheme});

  final FlexSchemeData dynamicScheme;

  @override
  List<Object> get props => [dynamicScheme];
}
