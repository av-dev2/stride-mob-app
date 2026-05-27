import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

/// Settings — Frappe connection, sync settings, data management.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _urlController;
  late TextEditingController _tokenController;
  late TextEditingController _hostnameController;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _urlController = TextEditingController(text: auth.siteUrl);
    _tokenController = TextEditingController(text: auth.apiToken);
    _hostnameController = TextEditingController(text: auth.siteHostname);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    _hostnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Frappe Connection ===
            const SectionHeader(title: 'Frappe Connection'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.tonalCardDecoration(
                color: AppTheme.surfaceContainerLowest,
              ),
              child: Column(
                children: [
                  // Connection status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: auth.isConnected
                              ? AppTheme.secondary.withOpacity(0.1)
                              : AppTheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          auth.isConnected ? LucideIcons.wifi : LucideIcons.wifiOff,
                          size: 20,
                          color: auth.isConnected ? AppTheme.secondary : AppTheme.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.isConnected ? 'Connected' : 'Not Connected',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (auth.connectedUser != null)
                              Text(
                                'Logged in as ${auth.connectedUser}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // URL field
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'Site URL',
                      hintText: 'http://192.168.0.90:8001',
                      prefixIcon: Icon(LucideIcons.globe, size: 18),
                    ),
                    onChanged: (v) => auth.updateSiteUrl(v),
                  ),
                  const SizedBox(height: 12),
                  // Hostname field (for nginx routing)
                  TextField(
                    controller: _hostnameController,
                    decoration: const InputDecoration(
                      labelText: 'Site Hostname (optional)',
                      hintText: 'rental',
                      prefixIcon: Icon(LucideIcons.server, size: 18),
                    ),
                    onChanged: (v) => auth.updateSiteHostname(v),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Enter the Frappe site name if using IP address (e.g., rental)',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Token field
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'API Token',
                      hintText: 'api_key:api_secret',
                      prefixIcon: Icon(LucideIcons.key, size: 18),
                    ),
                    obscureText: true,
                    onChanged: (v) => auth.updateApiToken(v),
                  ),
                  const SizedBox(height: 16),
                  // Test + Save row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: auth.isLoading ? null : () => auth.testConnection(),
                          child: Text(auth.isLoading ? 'Testing...' : 'Test Connection'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: auth.isLoading
                              ? null
                              : () => auth.saveAndTest(_urlController.text, _tokenController.text),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  // Error message
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        auth.error!,
                        style: const TextStyle(color: AppTheme.onErrorContainer, fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === Sync Settings ===
            const SectionHeader(title: 'Sync Settings'),
            Container(
              decoration: AppTheme.tonalCardDecoration(
                color: AppTheme.surfaceContainerLowest,
              ),
              child: Column(
                children: [
                  _SettingsToggle(
                    icon: LucideIcons.smartphone,
                    iconColor: AppTheme.secondary,
                    title: 'Auto-Sync SMS',
                    subtitle: 'Automatically capture payment messages',
                    value: settings.autoSync,
                    onChanged: settings.setAutoSync,
                  ),
                  Divider(height: 1, color: AppTheme.outlineVariant.withOpacity(0.2)),
                  _SettingsToggle(
                    icon: LucideIcons.arrowLeftRight,
                    iconColor: AppTheme.primary,
                    title: 'Auto-Reconcile',
                    subtitle: 'Automatically match payments to invoices',
                    value: settings.autoReconcile,
                    onChanged: settings.setAutoReconcile,
                  ),
                  Divider(height: 1, color: AppTheme.outlineVariant.withOpacity(0.2)),
                  _SettingsToggle(
                    icon: LucideIcons.bell,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Notifications',
                    subtitle: 'Get notified about new payments',
                    value: settings.notifications,
                    onChanged: settings.setNotifications,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === Data Management ===
            const SectionHeader(title: 'Data & Storage'),
            Container(
              decoration: AppTheme.tonalCardDecoration(
                color: AppTheme.surfaceContainerLowest,
              ),
              child: Column(
                children: [
                  _SettingsAction(
                    icon: LucideIcons.refreshCw,
                    iconColor: AppTheme.primary,
                    title: 'Sync Now',
                    subtitle: 'Pull latest data from ERPNext',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Syncing...'), backgroundColor: AppTheme.primary),
                      );
                    },
                  ),
                  Divider(height: 1, color: AppTheme.outlineVariant.withOpacity(0.2)),
                  _SettingsAction(
                    icon: LucideIcons.download,
                    iconColor: AppTheme.secondary,
                    title: 'Export Data',
                    subtitle: 'Download payment logs as CSV',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: AppTheme.outlineVariant.withOpacity(0.2)),
                  _SettingsAction(
                    icon: LucideIcons.trash2,
                    iconColor: AppTheme.error,
                    title: 'Clear Local Cache',
                    subtitle: 'Remove cached data (settings will be preserved)',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === About ===
            const SectionHeader(title: 'About'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.tonalCardDecoration(
                color: AppTheme.surfaceContainerLowest,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('App Version', style: Theme.of(context).textTheme.bodyLarge),
                      Text('v1.0.0', style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Build', style: Theme.of(context).textTheme.bodyLarge),
                      Text('2026.05.28', style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsAction({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}
