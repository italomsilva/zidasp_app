import 'package:flutter/material.dart';
import 'package:zidasp_app/theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool hasBorder;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double elevation;
  
  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.hasBorder = false,
    this.borderColor,
    this.onTap,
    this.elevation = 2.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: elevation,
      shape: hasBorder 
          ? RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor ?? AppColors.shrimpAlert,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(16),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
