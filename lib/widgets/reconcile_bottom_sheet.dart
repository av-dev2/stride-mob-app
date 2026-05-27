import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/sales_invoice.dart';
import 'gradient_button.dart';

/// Full-height bottom sheet for reconciling a payment against invoices.
class ReconcileBottomSheet extends StatefulWidget {
  final double paymentAmount;
  final String customerName;
  final List<SalesInvoice> invoices;
  final void Function(List<SalesInvoice> selected)? onSubmit;

  const ReconcileBottomSheet({
    super.key,
    required this.paymentAmount,
    required this.customerName,
    required this.invoices,
    this.onSubmit,
  });

  @override
  State<ReconcileBottomSheet> createState() => _ReconcileBottomSheetState();
}

class _ReconcileBottomSheetState extends State<ReconcileBottomSheet> {
  final Set<String> _selectedIds = {};
  final currencyFormat = NumberFormat('#,##0', 'en_US');

  double get selectedTotal => widget.invoices
      .where((i) => _selectedIds.contains(i.name))
      .fold(0.0, (sum, i) => sum + i.outstandingAmount);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppTheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              children: [
                const Icon(LucideIcons.arrowLeftRight, size: 20, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text('Reconcile Payment', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Payment summary card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.tonalCardDecoration(color: AppTheme.surfaceContainerLow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Amount', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      'TZS ${currencyFormat.format(widget.paymentAmount)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Customer', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(widget.customerName, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Outstanding Sales Invoices', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text('Select invoices to reconcile against', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Invoice list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.invoices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final inv = widget.invoices[index];
                final isSelected = _selectedIds.contains(inv.name);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedIds.remove(inv.name);
                    } else {
                      _selectedIds.add(inv.name);
                    }
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.secondaryContainer.withOpacity(0.3)
                          : AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: AppTheme.secondary.withOpacity(0.4), width: 1.5)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? LucideIcons.checkSquare : LucideIcons.square,
                          size: 22,
                          color: isSelected ? AppTheme.secondary : AppTheme.outlineVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(inv.name, style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 2),
                              Text(
                                'Due: ${DateFormat('dd MMM yyyy').format(inv.dueDate)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'TZS ${currencyFormat.format(inv.outstandingAmount)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: inv.status == 'Overdue'
                                    ? AppTheme.errorContainer
                                    : AppTheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                inv.status,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: inv.status == 'Overdue'
                                      ? AppTheme.onErrorContainer
                                      : AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Running total
          Container(
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: AppTheme.tonalCardDecoration(color: AppTheme.surfaceContainerLow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Selected Total', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  'TZS ${currencyFormat.format(selectedTotal)} / TZS ${currencyFormat.format(widget.paymentAmount)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: (selectedTotal - widget.paymentAmount).abs() < 1
                        ? AppTheme.secondary
                        : AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientButton(
              label: 'Submit — Create Payment Entry',
              onPressed: _selectedIds.isNotEmpty
                  ? () {
                      final selected = widget.invoices
                          .where((i) => _selectedIds.contains(i.name))
                          .toList();
                      widget.onSubmit?.call(selected);
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'This will create a Payment Entry in ERPNext and mark this log as reconciled',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
