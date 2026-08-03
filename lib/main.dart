import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'l10n/translations.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/services_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/process_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/project_details_screen.dart';
import 'widgets/scaffold_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Memory Management for Web/High-res images
  // Aggressive Limit image cache to 30MB
  PaintingBinding.instance.imageCache.maximumSizeBytes = 30 * 1024 * 1024;
  // Limit to 10 images in memory at once
  PaintingBinding.instance.imageCache.maximumSize = 10;

  // Initialize Firebase
  // If you are using web, you might need to pass options:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBjFpqGTr1XPq9fEbMo7T1e6yWh640lsQ0",
          authDomain: "vivum-d2907.firebaseapp.com",
          projectId: "vivum-d2907",
          storageBucket: "vivum-d2907.firebasestorage.app",
          messagingSenderId: "899371078453",
          appId: "1:899371078453:web:f96fb357e3603473f1727c",
          measurementId: "G-E7C1ZV11L7")
  );

  await Supabase.initialize(
    url: 'https://gosqrnkrebpdqvhazugw.supabase.co',
    publishableKey: 'sb_publishable_N0iUuNR5DD-yKtgCqcXglg_K2ySU9pj',
    debug: false,
  );

  Animate.restartOnHotReload = true;
  runApp(const VivumApp());
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
        // Handle cases where ID might be missing or someone navigates to /project
        GoRoute(path: '/project', redirect: (context, state) => '/portfolio'),
        GoRoute(path: '/project/:id', builder: (c, s) => ProjectDetailsScreen(projectId: s.pathParameters['id']!)),
        GoRoute(path: '/process', builder: (c, s) => const ProcessScreen()),
        GoRoute(path: '/contact', builder: (c, s) => const ContactScreen()),
      ],
    ),
  ],
);

class VivumApp extends StatefulWidget {
  const VivumApp({super.key});

  @override
  State<VivumApp> createState() => _VivumAppState();
}

class _VivumAppState extends State<VivumApp> {
  String _lang = 'en';
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isAdminMode = false;

  void _toggleLang() => setState(() => _lang = _lang == 'en' ? 'ar' : 'en');

  void _toggleTheme() =>
      setState(() =>
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  void _toggleAdmin() => setState(() => _isAdminMode = !_isAdminMode);

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      lang: _lang,
      themeMode: _themeMode,
      isAdminMode: _isAdminMode,
      onToggleLang: _toggleLang,
      onToggleTheme: _toggleTheme,
      onToggleAdmin: _toggleAdmin,
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
                // Force LTR for all languages as per user request to keep UI consistent
                textDirection: TextDirection.ltr,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
