import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/payment_log_card.dart';
import '../providers/payment_log_provider.dart';
import 'payment_log_list_screen.dart';
import 'payment_log_detail_screen.dart';

/// Payment Log summary — reconciled/unreconciled counts + recent logs.
class PaymentLogScreen extends StatelessWidget {
  const PaymentLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentLogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Logs'),
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          await provider.fetchCounts();
          await provider.fetchLogs();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentLogListScreen(reconciled: true),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: AppTheme.tonalCardDecoration(
                          color: AppTheme.secondaryContainer.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${provider.reconciledCount}',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppTheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Reconciled',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.onSecondaryContainer),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentLogListScreen(reconciled: false),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: AppTheme.tonalCardDecoration(
                          color: AppTheme.errorContainer.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${provider.unreconciledCount}',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppTheme.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Unreconciled',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.onErrorContainer,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.onErrorContainer),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent logs
              SectionHeader(
                title: 'Recent Logs',
                trailing: 'View All',
                onTrailingTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentLogListScreen(),
                  ),
                ),
              ),
              if (provider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (provider.logs.isEmpty)
                _buildEmptyState(context)
              else
                ...provider.logs.take(5).map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PaymentLogCard(
                      log: log,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentLogDetailScreen(log: log),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.ambientShadow,
        ),
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Manual entry
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(LucideIcons.plus, color: AppTheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.receipt, size: 32, color: AppTheme.outline),
            ),
            const SizedBox(height: 16),
            Text(
              'No payment logs yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Payment logs will appear here once synced',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
