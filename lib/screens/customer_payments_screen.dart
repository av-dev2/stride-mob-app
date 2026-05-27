import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/status_chip.dart';
import '../models/customer.dart';

/// Customer payments with filter chips (Paid/Pending/Postponed/All).
class CustomerPaymentsScreen extends StatefulWidget {
  final Customer customer;
  final String? initialFilter;

  const CustomerPaymentsScreen({
    super.key,
    required this.customer,
    this.initialFilter,
  });

  @override
  State<CustomerPaymentsScreen> createState() => _CustomerPaymentsScreenState();
}

class _CustomerPaymentsScreenState extends State<CustomerPaymentsScreen> {
  late String? _selectedFilter;
  final currencyFormat = NumberFormat('#,##0', 'en_US');

  // Mock payment data
  final List<Map<String, dynamic>> _allPayments = [
    {'period': 1, 'amount': 200000.0, 'status': 'Paid', 'from': '2026-01-15', 'to': '2026-02-14', 'due': '2026-01-15', 'sinv': 'SINV-00041', 'pe': 'PE-00028'},
    {'period': 2, 'amount': 200000.0, 'status': 'Paid', 'from': '2026-02-15', 'to': '2026-03-14', 'due': '2026-02-15', 'sinv': 'SINV-00042', 'pe': 'PE-00029'},
    {'period': 3, 'amount': 200000.0, 'status': 'Paid', 'from': '2026-03-15', 'to': '2026-04-14', 'due': '2026-03-15', 'sinv': 'SINV-00043', 'pe': 'PE-00030'},
    {'period': 4, 'amount': 200000.0, 'status': 'Pending', 'from': '2026-04-15', 'to': '2026-05-14', 'due': '2026-04-15', 'sinv': 'SINV-00044'},
    {'period': 5, 'amount': 200000.0, 'status': 'Pending', 'from': '2026-05-15', 'to': '2026-06-14', 'due': '2026-05-15'},
    {'period': 6, 'amount': 200000.0, 'status': 'Postponed', 'from': '2026-06-15', 'to': '2026-07-14', 'due': '2026-06-15'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  List<Map<String, dynamic>> get filteredPayments {
    if (_selectedFilter == null) return _allPayments;
    return _allPayments.where((p) => p['status'] == _selectedFilter).toList();
  }

  double get totalFiltered => filteredPayments.fold(0.0, (sum, p) => sum + (p['amount'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customer.customerName}\'s Payments'),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', isSelected: _selectedFilter == null, onTap: () => setState(() => _selectedFilter = null)),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Paid', isSelected: _selectedFilter == 'Paid', onTap: () => setState(() => _selectedFilter = 'Paid')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Pending', isSelected: _selectedFilter == 'Pending', onTap: () => setState(() => _selectedFilter = 'Pending')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Postponed', isSelected: _selectedFilter == 'Postponed', onTap: () => setState(() => _selectedFilter = 'Postponed')),
                ],
              ),
            ),
          ),
          // Summary card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.tonalCardDecoration(
                color: AppTheme.surfaceContainerLow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Amount', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 2),
                      Text(
                        'TZS ${currencyFormat.format(totalFiltered)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Text(
                    '${filteredPayments.length} period${filteredPayments.length != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
          // Payment list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredPayments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final p = filteredPayments[index];
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
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.tonalCardDecoration(
                    color: AppTheme.surfaceContainerLowest,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Period ${p['period']}', style: Theme.of(context).textTheme.titleSmall),
                          StatusChip(type: statusType),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 14, color: AppTheme.outline),
                          const SizedBox(width: 6),
                          Text('${p['from']} — ${p['to']}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.clock, size: 14, color: AppTheme.outline),
                          const SizedBox(width: 6),
                          Text('Due: ${p['due']}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TZS ${currencyFormat.format(p['amount'])}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (p['sinv'] != null || p['pe'] != null)
                            Row(
                              children: [
                                if (p['sinv'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(p['sinv'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant)),
                                  ),
                                if (p['pe'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(p['pe'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant)),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
