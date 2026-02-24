// lib/main.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/theme/theme_controller.dart';
import 'core/di.dart';
import 'navigation/main_navigation.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ZidaspApp());
}

class ZidaspApp extends StatelessWidget {
  const ZidaspApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Pega o controller de tema
    final themeController = di.get<ThemeController>();
    
    // Watch faz o rebuild quando o signal mudar
    return Watch(
      (context) {
        final themeMode = themeController.themeMode.value;
        
        return MaterialApp(
          title: 'Zidasp',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainNavigation(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}