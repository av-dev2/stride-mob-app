import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Payment/reconciliation status chip with 5 variants.
enum StatusType {
  reconciled,
  unreconciled,
  paid,
  pending,
  postponed,
}

class StatusChip extends StatelessWidget {
  final StatusType type;
  final String? label;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.type,
    this.label,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label ?? config.defaultLabel,
        style: TextStyle(
          color: config.fg,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _ChipConfig _getConfig() {
    switch (type) {
      case StatusType.reconciled:
        return _ChipConfig(
          bg: AppTheme.secondaryContainer,
          fg: AppTheme.onSecondaryContainer,
          defaultLabel: 'Reconciled',
        );
      case StatusType.unreconciled:
        return _ChipConfig(
          bg: AppTheme.errorContainer,
          fg: AppTheme.onErrorContainer,
          defaultLabel: 'Unreconciled',
        );
      case StatusType.paid:
        return _ChipConfig(
          bg: AppTheme.tertiaryFixed,
          fg: AppTheme.onTertiaryFixed,
          defaultLabel: 'Paid',
        );
      case StatusType.pending:
        return _ChipConfig(
          bg: AppTheme.surfaceContainerHighest,
          fg: AppTheme.outline,
          defaultLabel: 'Pending',
        );
      case StatusType.postponed:
        return _ChipConfig(
          bg: AppTheme.inverseSurface,
          fg: AppTheme.inverseOnSurface,
          defaultLabel: 'Postponed',
        );
    }
  }
}

class _ChipConfig {
  final Color bg;
  final Color fg;
  final String defaultLabel;
  const _ChipConfig({required this.bg, required this.fg, required this.defaultLabel});
}
