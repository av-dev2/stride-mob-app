import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/timeline_item.dart';
import '../widgets/section_header.dart';

/// Activity timeline — date-grouped feed of app events.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Today'),
            const TimelineItem(
              dotColor: AppTheme.secondary,
              icon: LucideIcons.smartphone,
              title: 'Payment synced',
              description: 'TZS 150,000 from M-Pesa — Auto-captured from SMS',
              timestamp: '2:45 PM',
            ),
            TimelineItem(
              dotColor: const Color(0xFF10B981),
              icon: LucideIcons.checkCircle,
              title: 'Payment reconciled',
              description: 'SINV-00045 matched with TZS 150,000 payment',
              timestamp: '2:46 PM',
            ),
            const TimelineItem(
              dotColor: AppTheme.primary,
              icon: LucideIcons.filePlus,
              title: 'Payment entry created',
              description: 'PE-00032 created for John Doe — TZS 150,000',
              timestamp: '2:46 PM',
            ),
            const TimelineItem(
              dotColor: AppTheme.secondary,
              icon: LucideIcons.smartphone,
              title: 'Payment synced',
              description: 'TZS 80,000 from TigoPesa — Manual entry',
              timestamp: '11:20 AM',
            ),
            const SizedBox(height: 8),
            const SectionHeader(title: 'Yesterday'),
            TimelineItem(
              dotColor: const Color(0xFF10B981),
              icon: LucideIcons.checkCircle,
              title: 'Payment reconciled',
              description: 'SINV-00044 matched with TZS 200,000 payment',
              timestamp: '4:30 PM',
            ),
            const TimelineItem(
              dotColor: AppTheme.primary,
              icon: LucideIcons.filePlus,
              title: 'Payment entry created',
              description: 'PE-00031 created for ABC Transport — TZS 200,000',
              timestamp: '4:31 PM',
            ),
            TimelineItem(
              dotColor: const Color(0xFF8B5CF6),
              icon: LucideIcons.userPlus,
              title: 'Customer synced',
              description: 'New customer "XYZ Logistics" synced from ERPNext',
              timestamp: '9:15 AM',
            ),
            const SizedBox(height: 8),
            const SectionHeader(title: 'This Week'),
            const TimelineItem(
              dotColor: AppTheme.secondary,
              icon: LucideIcons.smartphone,
              title: 'Payment synced',
              description: 'TZS 300,000 from Bank Transfer',
              timestamp: 'Mon 10:00 AM',
            ),
            const TimelineItem(
              dotColor: AppTheme.error,
              icon: LucideIcons.alertTriangle,
              title: 'Sync error',
              description: 'Failed to parse SMS — unknown payment format',
              timestamp: 'Mon 9:45 AM',
              isLast: true,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
