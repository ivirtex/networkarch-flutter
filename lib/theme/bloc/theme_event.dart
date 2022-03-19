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

  final FlexScheme scheme;

  @override
  List<Object> get props => [scheme];
}
