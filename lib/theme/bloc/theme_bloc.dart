// Flutter imports:
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.light)) {
    on<UpdateToLightThemeEvent>(_onUpdateToLightThemeEvent);
    on<UpdateToDarkThemeEvent>(_onUpdateToDarkThemeEvent);
  }

  void _onUpdateToLightThemeEvent(
    UpdateToLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(const ThemeState(ThemeMode.light));
  }

  void _onUpdateToDarkThemeEvent(
    UpdateToDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(const ThemeState(ThemeMode.dark));
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
