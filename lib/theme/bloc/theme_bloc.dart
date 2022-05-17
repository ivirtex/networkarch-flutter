// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(scheme: CustomFlexScheme.brandBlue)) {
    on<ThemeSchemeChangedEvent>(_onThemeSchemeChanged);
    on<ThemeDynamicSchemeChangedEvent>(_onThemeDynamicSchemeChanged);
    on<ThemeModeChangedEvent>(_onThemeModeChanged);
  }

  void _onThemeSchemeChanged(
    ThemeSchemeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(scheme: event.scheme));
  }

  void _onThemeDynamicSchemeChanged(
    ThemeDynamicSchemeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(dynamicScheme: event.dynamicScheme));
  }

  void _onThemeModeChanged(
    ThemeModeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(mode: event.themeMode));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson(state);
  }
}
