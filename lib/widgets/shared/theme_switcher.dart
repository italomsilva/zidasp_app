// lib/widgets/shared/theme_switcher.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zidasp_app/providers/theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool showLabel;
  final double iconSize;
  
  const ThemeSwitcher({
    Key? key,
    this.showLabel = false,
    this.iconSize = 24,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return IconButton(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            size: iconSize,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              themeProvider.isDarkMode ? 'Claro' : 'Escuro',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
      tooltip: 'Alternar tema (${themeProvider.themeName})',
    );
  }
}