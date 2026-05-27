import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/frappe_api.dart';
import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/payment_log_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/payment_log_screen.dart';
import 'screens/customer_list_screen.dart';
import 'screens/activity_screen.dart';
import 'widgets/glassmorphism_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StrideApp());
}

/// Stride — Payment tracking for Vehicle Renting MS.
class StrideApp extends StatelessWidget {
  const StrideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final frappeApi = FrappeApi();
    final storageService = StorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(api: frappeApi, storage: storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentLogProvider(api: frappeApi),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(api: frappeApi),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storage: storageService),
        ),
      ],
      child: MaterialApp(
        title: 'Stride',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const _AppRoot(),
      ),
    );
  }
}

/// Root widget that decides between Splash (onboarding) and MainLayout.
class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final auth = context.read<AuthProvider>();
    final settings = context.read<SettingsProvider>();
    await auth.loadCredentials();
    await settings.loadSettings();

    // If connected, prefetch data
    if (auth.isConnected) {
      final paymentProvider = context.read<PaymentLogProvider>();
      final customerProvider = context.read<CustomerProvider>();
      paymentProvider.fetchCounts();
      paymentProvider.fetchLogs();
      customerProvider.fetchCustomers();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final auth = context.watch<AuthProvider>();

    if (!auth.isOnboarded) {
      return SplashScreen(
        onGetStarted: () {
          // Navigate to main layout after onboarding
          auth.loadCredentials().then((_) {
            if (mounted) setState(() {});
          });
          // Force mark as onboarded
          StorageService().setOnboarded(true);
          auth.loadCredentials();
          setState(() {});
        },
      );
    }

    return const MainLayout();
  }
}

/// Main app shell with glassmorphism bottom navigation.
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    PaymentLogScreen(),
    CustomerListScreen(),
    ActivityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: GlassmorphismNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      extendBody: true,
    );
  }
}
