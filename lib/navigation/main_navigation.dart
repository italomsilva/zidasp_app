// lib/navigation/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/modules/pond/pages/dashboard/dashboard_page.dart';
import 'package:zidasp_app/widgets/shared/theme_switcher.dart';
import '../core/theme/theme_controller.dart';
import '../modules/tide/pages/tide_page.dart';
import '../modules/auth/pages/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);
  
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  late final List<Widget> _pages = [
    const DashboardPage(),
    const TidePage(),
    const ProfilePage(),
  ];
  
  final List<String> _titles = [
    'Dashboard',
    'Marés',
    'Perfil',
  ];
  
  @override
  Widget build(BuildContext context) {
    final themeController = inject<ThemeController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: const [
          ThemeSwitcher(),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: themeController.isDarkMode.value 
            ? Colors.white 
            : const Color(0xFFFF6B6B),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waves),
            label: 'Marés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}