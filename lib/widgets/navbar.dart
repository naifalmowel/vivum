import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';

class VivumNavbar extends StatefulWidget {
  const VivumNavbar({super.key});
  @override
  State<VivumNavbar> createState() => _VivumNavbarState();
}

class _VivumNavbarState extends State<VivumNavbar> {

  static const _navItems = [
    ('nav.home', '/'),
    ('nav.about', '/about'),
    ('nav.services', '/services'),
    ('nav.portfolio', '/portfolio'),
    ('nav.process', '/process'),
    ('nav.contact', '/contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;
    final loc = GoRouterState.of(context).uri.path;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 1),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                // Logo
                InkWell(
                  onTap: () => context.go('/'),
                  onLongPress: () {
                    app.onToggleAdmin();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const _VivumLogoText(),
                ),
                const Spacer(),
                if (!isMobile) ...[
                  ..._navItems.map((item) {
                    final isActive = loc == item.$2;
                    return _NavItem(
                      label: app.t(item.$1),
                      path: item.$2,
                      isActive: isActive,
                    );
                  }),
                  const SizedBox(width: 16),
                  // Theme Toggle
                  IconButton(
                    onPressed: app.onToggleTheme,
                    icon: Icon(
                      app.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: theme.colorScheme.onSurface,
                      size: 20,
                    ),
                    tooltip: 'Toggle Theme',
                  ),
                  const SizedBox(width: 8),
                  // Lang toggle
                  InkWell(
                    onTap: app.onToggleLang,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        app.t('nav.lang'),
                        style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // CTA
                  _GlowButton(
                    label: app.t('nav.start'),
                    onTap: () => context.go('/contact'),
                  ),
                ] else ...[
                  IconButton(
                    onPressed: app.onToggleTheme,
                    icon: Icon(app.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                  ),
                  InkWell(
                    onTap: app.onToggleLang,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(app.t('nav.lang'),
                        style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class _VivumLogoText extends StatelessWidget {
  const _VivumLogoText();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
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
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final String path;
  final bool isActive;
  const _NavItem({required this.label, required this.path, required this.isActive});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.onSurface;
    final inactiveColor = theme.textTheme.bodyMedium?.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () => context.go(widget.path),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  color: widget.isActive || _hovered ? activeColor : inactiveColor,
                ),
              ),
              AnimatedContainer(
                duration: 200.ms,
                height: 2,
                width: widget.isActive || _hovered ? 28 : 0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [VivumColors.teal, VivumColors.amber],
                    stops: [0.3, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: (widget.isActive || _hovered) 
                      ? [BoxShadow(color: VivumColors.teal.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 1))]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.onTap});
  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: 2000.ms)..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.05 : 1.0,
          duration: 200.ms,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: 300.ms,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [VivumColors.teal, VivumColors.tealDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: VivumColors.teal.withValues(alpha: _hovered ? 0.4 : 0.2),
                      blurRadius: _hovered ? 20 : 10,
                      spreadRadius: _hovered ? 2 : 0,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: Colors.white, letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.rocket_launch_rounded, size: 16, color: Colors.white),
                  ],
                ),
              ),
              // Shimmer effect removed for performance if needed, or kept very simple
            ],
          ),
        ),
      ),
    );
  }
}
