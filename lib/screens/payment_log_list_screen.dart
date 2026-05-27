import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/payment_log_card.dart';
import '../providers/payment_log_provider.dart';
import 'payment_log_detail_screen.dart';

/// Filtered payment log list — shows reconciled or unreconciled logs.
class PaymentLogListScreen extends StatefulWidget {
  final bool? reconciled;

  const PaymentLogListScreen({super.key, this.reconciled});

  @override
  State<PaymentLogListScreen> createState() => _PaymentLogListScreenState();
}

class _PaymentLogListScreenState extends State<PaymentLogListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentLogProvider>().fetchLogs(reconciled: widget.reconciled);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentLogProvider>();
    final title = widget.reconciled == true
        ? 'Reconciled'
        : widget.reconciled == false
            ? 'Unreconciled'
            : 'All Logs';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(title),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${provider.logs.length}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Container(
              decoration: AppTheme.tonalCardDecoration(color: AppTheme.surfaceContainerLow),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by name, amount...',
                  prefixIcon: Icon(LucideIcons.search, size: 18, color: AppTheme.outline),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          // List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.inbox, size: 48, color: AppTheme.outlineVariant),
                            const SizedBox(height: 12),
                            Text('No logs found', style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final log = provider.logs[index];
                          return PaymentLogCard(
                            log: log,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentLogDetailScreen(log: log),
                              ),
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
