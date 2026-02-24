// lib/controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  // Signal que armazena o tema atual
  final themeMode = signal<ThemeMode>(ThemeMode.system);
  
  // Computed que diz se é modo escuro - CORRIGIDO
  late final isDarkMode = computed(() {
    final mode = themeMode.value;
    if (mode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return mode == ThemeMode.dark;
  });
  
  // Nome do tema para exibição - CORRIGIDO
  late final themeName = computed(() {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  });
  
  ThemeController() {
    _loadTheme();
  }
  
  // Carrega o tema salvo
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('app_theme');
      
      if (savedTheme != null) {
        if (savedTheme == 'ThemeMode.light') {
          themeMode.value = ThemeMode.light;
        } else if (savedTheme == 'ThemeMode.dark') {
          themeMode.value = ThemeMode.dark;
        } else {
          themeMode.value = ThemeMode.system;
        }
      }
    } catch (e) {
      print('Erro ao carregar tema: $e');
    }
  }
  
  // Salva o tema
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_theme', themeMode.value.toString());
    } catch (e) {
      print('Erro ao salvar tema: $e');
    }
  }
  
  // Muda o tema
  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _saveTheme();
  }
  
  // Alterna entre claro/escuro
  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
    _saveTheme();
  }
}