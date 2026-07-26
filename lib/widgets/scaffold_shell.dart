import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import 'navbar.dart';
import 'footer.dart';

class ScaffoldShell extends StatelessWidget {
  final Widget child;
  const ScaffoldShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = AppProvider.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: _MobileDrawer(lp: lp),
      body: Column(
        children: [
          const VivumNavbar(),
          Expanded(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  final AppProvider lp;
  const _MobileDrawer({required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = GoRouterState.of(context).uri.path;
    
    final navItems = [
      ('nav.home', '/'),
      ('nav.about', '/about'),
      ('nav.services', '/services'),
      ('nav.portfolio', '/portfolio'),
      ('nav.process', '/process'),
      ('nav.contact', '/contact'),
    ];

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.syne(
                        fontSize: 24, fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                      children: const [
                        TextSpan(text: 'vi'),
                        TextSpan(text: 'v', style: TextStyle(color: VivumColors.teal)),
                        TextSpan(text: 'um'),
                        TextSpan(text: '.', style: TextStyle(color: VivumColors.amber)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: navItems.map((item) {
                  final isActive = loc == item.$2;
                  return ListTile(
                    title: Text(
                      lp.t(item.$1),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? VivumColors.teal : theme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      context.go(item.$2);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: lp.onToggleTheme,
                        icon: Icon(lp.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: lp.onToggleLang,
                        child: Text(lp.t('nav.lang'), style: GoogleFonts.inter(fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/contact');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VivumColors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(lp.t('nav.start')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
