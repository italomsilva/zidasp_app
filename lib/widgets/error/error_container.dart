import 'package:flutter/material.dart';
import 'package:zidasp_app/core/theme/app_theme.dart';

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    super.key,
    required this.errorMessage,
    this.handleRefresh,
    this.icon,
  });

  final String errorMessage;
  final VoidCallback? handleRefresh;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 48,
              color: AppColors.shrimpAlert.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: handleRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.shrimpAlert,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
