// lib/main.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();
  runApp(const ZidaspApp());
}

class ZidaspApp extends StatelessWidget {
  const ZidaspApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeController = inject<ThemeController>();
    
    return Watch(
      (context) {
        final themeMode = themeController.themeMode.value;
        
        return MaterialApp(
          title: 'Zidasp',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const MainNavigation(),
        );
      },
    );
  }
}