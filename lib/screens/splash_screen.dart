import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

/// Stride onboarding / splash screen.
class SplashScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const SplashScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Brand header
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.ambientShadow,
                ),
                child: const Icon(
                  LucideIcons.zap,
                  color: AppTheme.onPrimary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Stride',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Payment tracking for Vehicle Renting MS',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 48),
              // Feature cards
              const _FeatureCard(
                icon: LucideIcons.smartphone,
                iconColor: AppTheme.primary,
                title: 'Auto-Sync SMS',
                description: 'Automatically capture payment messages from M-Pesa, TigoPesa and more',
              ),
              const SizedBox(height: 12),
              const _FeatureCard(
                icon: LucideIcons.arrowLeftRight,
                iconColor: AppTheme.secondary,
                title: 'Smart Reconciliation',
                description: 'Match payments to invoices with one tap and create entries in ERPNext',
              ),
              const SizedBox(height: 12),
              const _FeatureCard(
                icon: LucideIcons.barChart3,
                iconColor: Color(0xFF8B5CF6),
                title: 'Real-Time Tracking',
                description: 'Monitor customer payments, pending dues, and reconciliation status',
              ),
              const Spacer(),
              GradientButton(
                label: 'Get Started',
                icon: LucideIcons.arrowRight,
                onPressed: onGetStarted,
              ),
              const SizedBox(height: 16),
              Text(
                'v1.0.0',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.tonalCardDecoration(
        color: AppTheme.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
