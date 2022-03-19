// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeModeChangedEvent>(_onThemeModeChanged);
    on<ThemeSchemeChangedEvent>(_onThemeSchemeChanged);
  }

  void _onThemeModeChanged(
    ThemeModeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(mode: event.themeMode));
  }

  void _onThemeSchemeChanged(
    ThemeSchemeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(scheme: event.scheme));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson();
  }
}
