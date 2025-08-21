import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeTheme(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class LoadTheme extends ThemeEvent {}

// States
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

// Cubit
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';
  
  ThemeCubit() : super(ThemeInitial()) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      final themeMode = ThemeMode.values[themeIndex];
      emit(ThemeLoaded(themeMode));
    } catch (e) {
      emit(const ThemeLoaded(ThemeMode.system));
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
      emit(ThemeLoaded(themeMode));
    } catch (e) {
      // Handle error silently
    }
  }

  void toggleTheme() {
    final currentState = state;
    if (currentState is ThemeLoaded) {
      final newThemeMode = currentState.themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
      changeTheme(newThemeMode);
    }
  }
} 