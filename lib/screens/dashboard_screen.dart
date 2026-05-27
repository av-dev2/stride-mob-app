import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_header.dart';
import '../providers/payment_log_provider.dart';
import '../providers/customer_provider.dart';
import 'settings_screen.dart';

/// Home dashboard — overview of key metrics and recent activity.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _syncEnabled = true;

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentLogProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good Morning'
        : now.hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stride'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, size: 22),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          await paymentProvider.fetchCounts();
          await customerProvider.fetchCustomers();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(now),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Sync toggle card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.tonalCardDecoration(
                  color: AppTheme.surfaceContainerLowest,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _syncEnabled
                            ? AppTheme.secondary.withOpacity(0.1)
                            : AppTheme.outline.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        LucideIcons.smartphone,
                        color: _syncEnabled ? AppTheme.secondary : AppTheme.outline,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMS Payment Sync',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _syncEnabled ? 'Monitoring incoming messages' : 'Sync is paused',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _syncEnabled,
                      onChanged: (val) => setState(() => _syncEnabled = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Metrics grid
              const SectionHeader(title: 'Overview'),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: [
                  MetricCard(
                    value: '${customerProvider.totalCount}',
                    label: 'Customers',
                    icon: LucideIcons.users,
                    accentColor: AppTheme.primary,
                  ),
                  MetricCard(
                    value: '${paymentProvider.totalCount}',
                    label: 'Payment Logs',
                    icon: LucideIcons.receipt,
                    accentColor: AppTheme.secondary,
                  ),
                  MetricCard(
                    value: '${paymentProvider.reconciledCount}',
                    label: 'Reconciled',
                    icon: LucideIcons.checkCircle,
                    accentColor: const Color(0xFF10B981),
                  ),
                  MetricCard(
                    value: '${paymentProvider.unreconciledCount}',
                    label: 'Unreconciled',
                    icon: LucideIcons.alertCircle,
                    accentColor: AppTheme.error,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent activity
              const SectionHeader(title: 'Recent Activity', trailing: 'See All'),
              ..._buildRecentActivity(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRecentActivity(BuildContext context) {
    final activities = [
      {'type': 'synced', 'title': 'Payment synced', 'desc': 'TZS 150,000 from M-Pesa', 'time': '2 min ago'},
      {'type': 'reconciled', 'title': 'Log reconciled', 'desc': 'SINV-00045 matched', 'time': '15 min ago'},
      {'type': 'created', 'title': 'Payment entry created', 'desc': 'PE-00032 for John Doe', 'time': '1 hour ago'},
    ];

    return activities.map((a) {
      Color dotColor;
      IconData icon;
      switch (a['type']) {
        case 'synced':
          dotColor = AppTheme.secondary;
          icon = LucideIcons.smartphone;
          break;
        case 'reconciled':
          dotColor = const Color(0xFF10B981);
          icon = LucideIcons.checkCircle;
          break;
        default:
          dotColor = AppTheme.primary;
          icon = LucideIcons.filePlus;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: AppTheme.tonalCardDecoration(
            color: AppTheme.surfaceContainerLowest,
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Icon(icon, size: 18, color: dotColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['title']!, style: Theme.of(context).textTheme.titleSmall),
                    Text(a['desc']!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text(a['time']!, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      );
    }).toList();
  }
}
