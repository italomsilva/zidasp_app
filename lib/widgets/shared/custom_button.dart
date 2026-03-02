import 'package:flutter/material.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({super.key,
  required this.onClick,
  this.backgroundColor = AppColors.shrimpAlert,
  this.textColor = AppColors.darkText,
  this.isLoading = false,
  required this.text,  
  this.enabled =true
  });

  final VoidCallback onClick;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;
  final String text;
  final bool enabled;
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                        onPressed: (enabled && !isLoading) ? onClick : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          foregroundColor: textColor,
                          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
  }
}