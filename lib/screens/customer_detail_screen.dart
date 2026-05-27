import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/status_chip.dart';
import '../models/customer.dart';
import 'customer_payments_screen.dart';

/// Customer detail — info card, payment metrics, recent payments.
class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.customerName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer info header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.tonalCardDecoration(
                color: AppTheme.surfaceContainerLowest,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryContainer,
                    child: Text(
                      customer.customerName.isNotEmpty
                          ? customer.customerName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppTheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.customerName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            customer.customerType,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (customer.mobileNo != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(LucideIcons.phone, size: 14, color: AppTheme.outline),
                              const SizedBox(width: 6),
                              Text(customer.mobileNo!, style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ],
                        if (customer.emailId != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.mail, size: 14, color: AppTheme.outline),
                              const SizedBox(width: 6),
                              Text(customer.emailId!, style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment metric cards (tappable)
            const SectionHeader(title: 'Payment Summary'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToPayments(context, 'Paid'),
                    child: const _MiniMetric(
                      value: '5',
                      label: 'Paid',
                      color: AppTheme.tertiaryFixed,
                      textColor: AppTheme.onTertiaryFixed,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToPayments(context, 'Pending'),
                    child: const _MiniMetric(
                      value: '2',
                      label: 'Pending',
                      color: AppTheme.surfaceContainerHighest,
                      textColor: AppTheme.outline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToPayments(context, 'Postponed'),
                    child: const _MiniMetric(
                      value: '1',
                      label: 'Postponed',
                      color: AppTheme.inverseSurface,
                      textColor: AppTheme.inverseOnSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent payments
            SectionHeader(
              title: 'Recent Payments',
              trailing: 'View All',
              onTrailingTap: () => _navigateToPayments(context, null),
            ),
            ..._buildRecentPayments(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _navigateToPayments(BuildContext context, String? filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerPaymentsScreen(
          customer: customer,
          initialFilter: filter,
        ),
      ),
    );
  }

  List<Widget> _buildRecentPayments(BuildContext context) {
    // Mock data
    final payments = [
      {'period': 'Period 3', 'amount': 'TZS 200,000', 'status': 'Paid', 'date': 'May 15, 2026'},
      {'period': 'Period 4', 'amount': 'TZS 200,000', 'status': 'Pending', 'date': 'Jun 15, 2026'},
      {'period': 'Period 5', 'amount': 'TZS 200,000', 'status': 'Postponed', 'date': 'Jul 15, 2026'},
    ];

    return payments.map((p) {
      StatusType statusType;
      switch (p['status']) {
        case 'Paid':
          statusType = StatusType.paid;
          break;
        case 'Postponed':
          statusType = StatusType.postponed;
          break;
        default:
          statusType = StatusType.pending;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.tonalCardDecoration(
            color: AppTheme.surfaceContainerLowest,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['period']!, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(p['date']!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text(p['amount']!, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 10),
              StatusChip(type: statusType),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _MiniMetric extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color textColor;

  const _MiniMetric({
    required this.value,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
