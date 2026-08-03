import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import 'navbar.dart';
import 'navbar.dart';

class ScaffoldShell extends StatefulWidget {
  final Widget child;
  const ScaffoldShell({super.key, required this.child});

  @override
  State<ScaffoldShell> createState() => _ScaffoldShellState();
}

class _ScaffoldShellState extends State<ScaffoldShell> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    if (_scrollController.offset > 400 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 400 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        offset: _showBackToTop ? Offset.zero : const Offset(0, 2),
        duration: 400.ms,
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _showBackToTop ? 1.0 : 0.0,
          duration: 300.ms,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _scrollController.animateTo(0, duration: 800.ms, curve: Curves.easeOutCubic),
              child: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: VivumColors.teal,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: VivumColors.teal.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))
                  ],
                ),
                child: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white, size: 30),
              ),
            ),
          ),
        ),
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
                      style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                        fontFamily: 'Cairo',
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
                      style: TextStyle(
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
                        child: Text(lp.t('nav.lang'), style: const TextStyle(fontSize: 16)),
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
