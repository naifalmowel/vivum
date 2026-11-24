import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:vivum/services/database_service.dart';
import 'package:vivum/services/seo_helper.dart';
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

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBjFpqGTr1XPq9fEbMo7T1e6yWh640lsQ0",
        authDomain: "vivum-d2907.firebaseapp.com",
        projectId: "vivum-d2907",
        storageBucket: "vivum-d2907.firebasestorage.app",
        messagingSenderId: "899371078453",
        appId: "1:899371078453:web:f96fb357e3603473f1727c",
        measurementId: "G-E7C1ZV11L7",
      ),
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  runApp(const VivumApp());
  _initSecondaryServices();
}

// دالة تهيئة الخدمات الثانوية في الخلفية
Future<void> _initSecondaryServices() async {
  try {
    await Supabase.initialize(
      url: 'https://gosqrnkrebpdqvhazugw.supabase.co',
      publishableKey: 'sb_publishable_N0iUuNR5DD-yKtgCqcXglg_K2ySU9pj',
      debug: false,
    );
    FirebaseAnalytics.instance.logAppOpen().catchError((_) {});
  } catch (e) {
    debugPrint('Secondary services init error: $e');
  }

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
      builder: (context, state, child) {
        _applyRouteSEO(state.uri.path);
        return ScaffoldShell(child: child);
      },
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

void _applyRouteSEO(String path) {
  if (path.startsWith('/project/')) return;

  final metaData = _getMetaDataForRoute(path);
  SeoHelper.updateSEO(
    title: metaData['title']!,
    description: metaData['description']!,
    path: path,
  );
}

Map<String, String> _getMetaDataForRoute(String path) {
  switch (path) {
    case '/about':
      return {
        'title': 'من نحن | VIVUM Digital Agency - وكالة فيفوم الرقمية',
        'description': 'تعرف على وكالة فيفوم الرقمية، رؤيتنا وفريقنا في الإمارات، السعودية وسوريا لتطوير البرمجيات والذكاء الاصطناعي.',
      };
    case '/services':
      return {
        'title': 'خدماتنا | VIVUM Digital Agency - تطوير المواقع، التطبيقات والذكاء الاصطناعي',
        'description': 'نقدم خدمات تطوير المواقع والتطبيقات، أتمتة الذكاء الاصطناعي، وتصميم تجربة المستخدم الهوية البصرية.',
      };
    case '/portfolio':
      return {
        'title': 'معرض الأعمال | VIVUM Digital Agency - مشروعاتنا البرمجية',
        'description': 'استعرض قائمة مشاريعنا المنفذة في برمجيات الويب، التطبيقات الذكية، والحلول الرقمية للشركات.',
      };
    case '/process':
      return {
        'title': 'منهجية العمل | VIVUM Digital Agency - كيف نعمل',
        'description': 'تعرف على خطوات ومنهجية VIVUM من مرحلة الاستكشاف والتصميم إلى التطوير والإطلاق والتطوير المستمر.',
      };
    case '/contact':
      return {
        'title': 'تواصل معنا | VIVUM Digital Agency - استشارة رقمية',
        'description': 'تواصل مع فريق VIVUM الرقمي لبدء مشروعك القادم واستلام استشارة برمجية وتكلفة تقديرية.',
      };
    case '/':
    default:
      return {
        'title': 'VIVUM Digital Agency | وكالة فيفوم الرقمية - تصميم المواقع، التطبيقات والذكاء الاصطناعي',
        'description': 'فيفوم (VIVUM) وكالة رقمية إقليمية متخصصة في تطوير البرمجيات والمواقع والتطبيقات بالذكاء الاصطناعي في دبي، الرياض ودمشق.',
      };
  }
}

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
        final settings = (snapshot.hasData && !snapshot.hasError) ? (snapshot.data ?? <String, dynamic>{}) : <String, dynamic>{};
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
