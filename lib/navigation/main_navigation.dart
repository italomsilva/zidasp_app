import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zidasp_app/core/di.dart';
import 'package:zidasp_app/core/sesssion/session_controller.dart';
import 'package:zidasp_app/modules/pond/pages/pond_list_page.dart';
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
    const PondListPage(),
    const TidePage(),
    const ProfilePage(),
  ];
  
  final List<String> _titles = [
    'Viveiros',
    'Marés',
    'Perfil',
  ];
  
  @override
  Widget build(BuildContext context) {
    final themeController = inject<ThemeController>();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles[_selectedIndex], style: TextStyle(fontWeight: FontWeight.bold)),
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
            icon: FaIcon(FontAwesomeIcons.shrimp),
            label: 'Viveiros',
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