import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
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

void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VivumApp());
}

// دالة تهيئة الخدمات الأساسية التي يجب انتظارها
Future<void> _initCoreServices() async {
  // تهيئة الفايربيس أولاً بشكل كامل لمنع خطأ الـ JavaScriptObject
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBjFpqGTr1XPq9fEbMo7T1e6yWh640lsQ0",
          authDomain: "://firebaseapp.com",
          projectId: "vivum-d2907",
          storageBucket: "vivum-d2907.firebasestorage.app",
          messagingSenderId: "899371078453",
          appId: "1:899371078453:web:f96fb357e3603473f1727c",
          measurementId: "G-E7C1ZV11L7"
      )
  );

  // السوبابيس مسموح تحميله بالتوازي
  await Supabase.initialize(
    url: 'https://supabase.co',
    publishableKey: 'sb_publishable_N0iUuNR5DD-yKtgCqcXglg_K2ySU9pj',
    debug: false,
  );

  assert(() {
    Animate.restartOnHotReload = true;
    return true;
  }());
}

final _router = GoRouter(
  initialLocation: '/',
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
  late final Future<void> _initializationFuture;

  @override
  void initState() { // تم تصحيح الخطأ الإملائي هنا في السطر 113
    super.initState();
    _initializationFuture = _initCoreServices();
  }

  void _toggleLang() => setState(() => _lang = _lang == 'en' ? 'ar' : 'en');

  void _toggleTheme() =>
      setState(() =>
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, authSnapshot) {
        // تم تصحيح طريقة كتابة لون الهيكس هنا في السطر 135 ليكون كوداً برمجياً صحيحاً للون الخلفية الداكنة
        if (authSnapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Container(color: const Color(0xFF07091A)),
          );
        }

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
                    routerConfig: _router,
                    builder: (context, child) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: child!,
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
