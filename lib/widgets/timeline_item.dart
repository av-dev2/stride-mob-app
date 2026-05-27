import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Activity timeline node with colored dot and content.
class TimelineItem extends StatelessWidget {
  final Color dotColor;
  final IconData icon;
  final String title;
  final String description;
  final String timestamp;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.dotColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: AppTheme.outlineVariant.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 16, color: dotColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        timestamp,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
