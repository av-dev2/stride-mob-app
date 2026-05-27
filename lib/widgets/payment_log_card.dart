import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/payment_log.dart';
import 'status_chip.dart';

/// Payment log list item card — no borders, tonal layering.
class PaymentLogCard extends StatelessWidget {
  final PaymentLog log;
  final VoidCallback? onTap;

  const PaymentLogCard({
    super.key,
    required this.log,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.tonalCardDecoration(
          color: AppTheme.surfaceContainerLowest,
        ),
        child: Row(
          children: [
            // Payment method icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryFixed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getMethodIcon(log.paymentMethod),
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.paymentMethod,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd MMM yyyy').format(log.postingDate),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TZS ${currencyFormat.format(log.paidAmount)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    log.paidTo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Status + chevron
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusChip(
                  type: log.reconciled ? StatusType.reconciled : StatusType.unreconciled,
                ),
                const SizedBox(height: 8),
                const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.outlineVariant),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMethodIcon(String method) {
    final m = method.toLowerCase();
    if (m.contains('m-pesa') || m.contains('mpesa')) return LucideIcons.smartphone;
    if (m.contains('bank')) return LucideIcons.building2;
    if (m.contains('cash')) return LucideIcons.banknote;
    return LucideIcons.creditCard;
  }
}
