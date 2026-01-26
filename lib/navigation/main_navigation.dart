// lib/navigation/main_navigation.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zidasp_app/providers/theme_provider.dart';
import 'package:zidasp_app/screens/dashboard/dashboard_screen.dart';
import 'package:zidasp_app/screens/profile/profile_screen.dart';
import 'package:zidasp_app/screens/tide/tide_screen.dart';
import 'package:zidasp_app/theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);
  
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = const [
    DashboardScreen(),
    TideScreen(),
    ProfileScreen(),
  ];
  
  final List<String> _titles = [
    'Dashboard',
    'Marés',
    'Perfil',
  ];
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          // Botão para alternar tema
          IconButton(
            icon: Icon(themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: themeProvider.isDarkMode 
                ? 'Modo Claro' 
                : 'Modo Escuro',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
  
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.shrimpAlert,
        unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
        type: BottomNavigationBarType.fixed,
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
