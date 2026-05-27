import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Tappable metric card for dashboard grids.
class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.accentColor = AppTheme.primary,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.tonalCardDecoration(
          color: backgroundColor ?? AppTheme.surfaceContainerLowest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
