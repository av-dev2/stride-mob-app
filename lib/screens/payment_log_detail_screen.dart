import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/status_chip.dart';
import '../widgets/gradient_button.dart';
import '../widgets/reconcile_bottom_sheet.dart';
import '../models/payment_log.dart';
import '../models/sales_invoice.dart';
import '../providers/payment_log_provider.dart';

/// Individual payment log detail — shows full info + reconcile CTA.
class PaymentLogDetailScreen extends StatelessWidget {
  final PaymentLog log;

  const PaymentLogDetailScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StatusChip(
              type: log.reconciled ? StatusType.reconciled : StatusType.unreconciled,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TZS ${currencyFormat.format(log.paidAmount)}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detail fields
            _DetailSection(
              children: [
                _DetailRow(
                  icon: LucideIcons.calendar,
                  label: 'Posting Date',
                  value: DateFormat('dd MMMM yyyy').format(log.postingDate),
                ),
                _DetailRow(
                  icon: LucideIcons.clock,
                  label: 'Posting Time',
                  value: log.postingTime,
                ),
                _DetailRow(
                  icon: LucideIcons.creditCard,
                  label: 'Payment Method',
                  value: log.paymentMethod,
                ),
                _DetailRow(
                  icon: LucideIcons.user,
                  label: 'Paid To',
                  value: log.paidTo,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            if (log.description.isNotEmpty) ...[
              Text('Description', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.tonalCardDecoration(
                  color: AppTheme.surfaceContainerLow,
                ),
                child: Text(
                  log.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Reconcile CTA
            if (!log.reconciled) ...[
              const SizedBox(height: 8),
              GradientButton(
                label: 'Reconcile Payment',
                icon: LucideIcons.arrowLeftRight,
                onPressed: () => _showReconcileSheet(context),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Match this payment against outstanding invoices',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showReconcileSheet(BuildContext context) {
    // Mock invoices for demo
    final mockInvoices = [
      SalesInvoice(
        name: 'SINV-00045',
        customerName: log.paidTo,
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        grandTotal: 200000,
        outstandingAmount: 150000,
        status: 'Overdue',
      ),
      SalesInvoice(
        name: 'SINV-00046',
        customerName: log.paidTo,
        dueDate: DateTime.now().add(const Duration(days: 10)),
        grandTotal: 100000,
        outstandingAmount: 100000,
        status: 'Unpaid',
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => ReconcileBottomSheet(
          paymentAmount: log.paidAmount,
          customerName: log.paidTo,
          invoices: mockInvoices,
          onSubmit: (selected) {
            context.read<PaymentLogProvider>().reconcile(log.name);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment reconciled successfully!'),
                backgroundColor: AppTheme.secondary,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final List<_DetailRow> children;
  const _DetailSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.tonalCardDecoration(
        color: AppTheme.surfaceContainerLowest,
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          return Column(
            children: [
              entry.value,
              if (entry.key < children.length - 1)
                Divider(height: 1, color: AppTheme.outlineVariant.withOpacity(0.2)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.outline),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
