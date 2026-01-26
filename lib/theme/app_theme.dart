import 'package:flutter/material.dart';

class AppColors {
  // Tema Claro
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightText = Color(0xFF2C3E50);
  static const Color lightTextSecondary = Color(0xFF7F8C8D);
  
  // Tema Escuro
  static const Color darkBackground = Color(0xFF121A2A); // Azul Petróleo
  static const Color darkSurface = Color(0xFF1A2436);
  static const Color darkText = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFFBDC3C7);
  
  // Cores da Marca
  static const Color shrimpAlert = Color(0xFFFF7A6B); // Salmão/Coral
  static const Color healthGreen = Color(0xFF2ECC71); // Verde Esmeralda
  static const Color neutralBlue = Color(0xFF3498DB);
  static const Color neutralYellow = Color(0xFFF1C40F);
  
  // Cores de Status
  static const Color success = healthGreen;
  static const Color warning = Color(0xFFF39C12);
  static const Color danger = shrimpAlert;
  static const Color info = Color(0xFF17A2B8);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightSurface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      foregroundColor: AppColors.lightText,
      iconTheme: const IconThemeData(color: AppColors.lightText),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.shrimpAlert,
      secondary: AppColors.healthGreen,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      foregroundColor: AppColors.darkText,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.shrimpAlert,
      secondary: AppColors.healthGreen,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
    ),
  );
}