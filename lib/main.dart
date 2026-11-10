import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:vivum/services/database_service.dart';
import 'package:vivum/widgets/glow_button.dart';
import 'theme/app_theme.dart';
import 'l10n/translations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/services_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/process_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/project_details_screen.dart';
import 'widgets/scaffold_shell.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await _initCoreServices();
  runApp(const VivumApp());
}

// دالة تهيئة الخدمات الأساسية
Future<void> _initCoreServices() async {
  await Future.wait([
    Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBjFpqGTr1XPq9fEbMo7T1e6yWh640lsQ0",
        authDomain: "vivum-d2907.firebaseapp.com",
        projectId: "vivum-d2907",
        storageBucket: "vivum-d2907.firebasestorage.app",
        messagingSenderId: "899371078453",
        appId: "1:899371078453:web:f96fb357e3603473f1727c",
        measurementId: "G-E7C1ZV11L7"
      ),
    ),
    Supabase.initialize(
      url: 'https://gosqrnkrebpdqvhazugw.supabase.co',
      publishableKey: 'sb_publishable_N0iUuNR5DD-yKtgCqcXglg_K2ySU9pj',
      debug: false,
    ),
  ]);

  try {
    await FirebaseAnalytics.instance.logAppOpen();
  } catch (_) {}

  assert(() {
    Animate.restartOnHotReload = true;
    return true;
  }());
}

final _router = GoRouter(
  initialLocation: '/',
  observers: [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/about', builder: (c, s) => const AboutScreen()),
        GoRoute(path: '/services', builder: (c, s) => const ServicesScreen()),
        GoRoute(path: '/portfolio', builder: (c, s) => const PortfolioScreen()),
        GoRoute(path: '/project', redirect: (context, state) => '/portfolio'),
        GoRoute(path: '/project/:id', builder: (c, s) => ProjectDetailsScreen(projectId: s.pathParameters['id']!)),
        GoRoute(path: '/process', builder: (c, s) => const ProcessScreen()),
        GoRoute(path: '/contact', builder: (c, s) => const ContactScreen()),
      ],
    ),
  ],
  errorBuilder: (context, state) => const _NotFoundScreen(),
);

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_rounded, size: 80, color: VivumColors.teal),
            const SizedBox(height: 24),
            Text('404', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            const Text('Page lost in space...', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            VivumButton(label: 'Back Home', onTap: () => context.go('/'), variant: ButtonVariant.teal),
          ],
        ),
      ),
    );
  }
}

class VivumApp extends StatefulWidget {
  const VivumApp({super.key});

  @override
  State<VivumApp> createState() => _VivumAppState();
}

class _VivumAppState extends State<VivumApp> {
  String _lang = 'en';
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleLang() => setState(() => _lang = _lang == 'en' ? 'ar' : 'en');

  void _toggleTheme() =>
      setState(() =>
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: DatabaseService.getSettingsStream(),
      builder: (context, snapshot) {
        final settings = snapshot.data ?? {};
        return AppProvider(
          lang: _lang,
          themeMode: _themeMode,
          settings: settings,
          onToggleLang: _toggleLang,
          onToggleTheme: _toggleTheme,
          child: Builder(
            builder: (context) {
              final appProvider = AppProvider.of(context);
              return MaterialApp.router(
                title: 'VIVUM Digital Agency',
                debugShowCheckedModeBanner: false,
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.trackpad
                  },
                ),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: appProvider.themeMode,
                locale: Locale(appProvider.lang),
                routerConfig: _router,
                builder: (context, child) {
                  return Directionality(
                    textDirection: appProvider.isAr ? TextDirection.rtl : TextDirection.ltr,
                    child: child!,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
