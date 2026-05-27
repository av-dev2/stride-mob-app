import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full-width gradient CTA button.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: onPressed != null ? AppTheme.primaryGradient : null,
          color: onPressed == null ? AppTheme.surfaceContainerHigh : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: onPressed != null ? AppTheme.ambientShadow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.onPrimary,
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, color: AppTheme.onPrimary, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
