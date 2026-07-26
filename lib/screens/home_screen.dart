import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/particle_painter.dart';
import '../widgets/glow_button.dart';
import '../widgets/section_reveal.dart';

import '../widgets/footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeroSection(lp: lp),
        _ServicesPreview(lp: lp),
        _StatsSection(lp: lp),
        _PortfolioTeaser(lp: lp),
        _WhyVivum(lp: lp),
        _CtaBanner(lp: lp),
        const VivumFooter(),
      ],
    );
  }
}

// ─── HERO ───────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final AppProvider lp;
  const _HeroSection({required this.lp});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height * 0.92),
      decoration: BoxDecoration(gradient: VivumColors.heroGradient(lp.isDark)),
      child: Stack(
        children: [
          // Animated particle background
          const Positioned.fill(child: ParticleBackground()),
          // Radial glow
          Positioned(
            top: size.height * 0.05,
            right: isWide ? size.width * 0.05 : -size.width * 0.1,
            child: Container(
              width: size.width * (isWide ? 0.55 : 0.8),
              height: size.width * (isWide ? 0.55 : 0.8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VivumColors.teal.withValues(alpha: 0.12),
                    theme.colorScheme.primary.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: isWide ? 80 : 60,
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _HeroText(lp: lp)),
                      const Expanded(flex: 4, child: HeroOrbit()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _HeroText(lp: lp),
                      const SizedBox(height: 40),
                      const SizedBox(height: 320, child: HeroOrbit()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final AppProvider lp;
  const _HeroText({required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final headline3Style = TextStyle(
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: [VivumColors.teal, VivumColors.amber],
        ).createShader(const Rect.fromLTWH(0, 0, 500, 80)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: VivumColors.teal.withValues(alpha: 0.1),
            border: Border.all(color: VivumColors.teal.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: VivumColors.teal)),
            const SizedBox(width: 8),
            Text(lp.t('hero.badge'),
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: VivumColors.teal)),
          ]),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
        const SizedBox(height: 28),
        // Headline lines
        RichText(
          text: TextSpan(
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: size.width > 1200 ? 68 : (size.width > 600 ? 48 : 36),
              height: 1.05,
            ),
            children: [
              TextSpan(text: '${lp.t('hero.headline1')}\n'),
              TextSpan(text: '${lp.t('hero.headline2')}\n'),
              TextSpan(
                text: lp.t('hero.headline3'),
                style: headline3Style,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 700.ms).slideY(begin: 0.2),
        const SizedBox(height: 24),
        Text(
          lp.t('hero.sub'),
          style: theme.textTheme.bodyLarge,
        ).animate().fadeIn(delay: 550.ms, duration: 700.ms),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            VivumButton(
              label: lp.t('hero.cta2'),
              onTap: () => context.go('/contact'),
              variant: ButtonVariant.amber,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ),
            VivumButton(
              label: lp.t('hero.cta1'),
              onTap: () => context.go('/portfolio'),
              variant: ButtonVariant.outline,
            ),
          ],
        ).animate().fadeIn(delay: 700.ms, duration: 700.ms).slideY(begin: 0.2),
        const SizedBox(height: 56),
        // Scroll indicator
        Column(
          children: [
            Text(lp.isAr ? 'مرر للاستكشاف' : 'Scroll to explore',
              style: GoogleFonts.inter(
                  fontSize: 11, 
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5), 
                  letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Container(
              width: 1, height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [VivumColors.teal, VivumColors.teal.withValues(alpha: 0)],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1200.ms),
      ],
    );
  }
}

// ─── SERVICES PREVIEW ──────────────────────────────────────────────────────
class _ServicesPreview extends StatelessWidget {
  final AppProvider lp;
  const _ServicesPreview({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final services = [
      (Icons.palette_outlined, 'services.brand.title', 'services.brand.desc', VivumColors.teal),
      (Icons.devices_outlined, 'services.digital.title', 'services.digital.desc', VivumColors.amber),
      (Icons.psychology_outlined, 'services.ai.title', 'services.ai.desc', VivumColors.teal),
      (Icons.dns_outlined, 'services.it.title', 'services.it.desc', VivumColors.amber),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
      child: Column(
        children: [
          SectionReveal(
            child: Column(children: [
              const _SectionLabel('WHAT WE DO'),
              const SizedBox(height: 12),
              Text(lp.t('services.title'),
                style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(lp.t('services.sub'),
                style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 64),
          isWide
              ? Row(
                  children: services.asMap().entries.map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: e.key < services.length - 1 ? 20 : 0),
                      child: SectionReveal(
                        delay: Duration(milliseconds: e.key * 120),
                        child: _ServiceCard(
                          icon: e.value.$1, titleKey: e.value.$2,
                          descKey: e.value.$3, accent: e.value.$4, lp: lp,
                        ),
                      ),
                    ),
                  )).toList(),
                )
              : Column(
                  children: services.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _ServiceCard(icon: s.$1, titleKey: s.$2, descKey: s.$3, accent: s.$4, lp: lp),
                  )).toList(),
                ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String titleKey, descKey;
  final Color accent;
  final AppProvider lp;
  const _ServiceCard({required this.icon, required this.titleKey, required this.descKey, required this.accent, required this.lp});
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 250.ms,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovered 
              ? theme.colorScheme.surface.withValues(alpha: 0.8) 
              : theme.colorScheme.surface,
          border: Border.all(
            color: _hovered ? widget.accent.withValues(alpha: 0.4) : theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: widget.accent.withValues(alpha: isDark ? 0.1 : 0.05), 
                  blurRadius: 24, 
                  spreadRadius: 0,
                  offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: 250.ms,
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: widget.accent.withValues(alpha: _hovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.accent, size: 24),
            ),
            const SizedBox(height: 20),
            Text(widget.lp.t(widget.titleKey),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(widget.lp.t(widget.descKey),
              style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            Row(children: [
              Text(widget.lp.t('services.learn'),
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: widget.accent)),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 14, color: widget.accent),
            ]),
          ],
        ),
      ),
    );
  }
}

// ─── STATS ──────────────────────────────────────────────────────────────────
class _StatsSection extends StatelessWidget {
  final AppProvider lp;
  const _StatsSection({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);
    final stats = [
      ('50+', 'stats.projects'), ('3', 'stats.markets'),
      ('5+', 'stats.years'), ('100%', 'stats.satisfaction'),
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
      padding: EdgeInsets.symmetric(vertical: isWide ? 60 : 40, horizontal: isWide ? 40 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 40,
              offset: const Offset(0, 10),
            )
        ],
      ),
      child: SectionReveal(
        child: isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: stats.map((s) => _StatItem(value: s.$1, labelKey: s.$2, lp: lp)).toList(),
              )
            : Wrap(
                alignment: WrapAlignment.center,
                spacing: 40, runSpacing: 32,
                children: stats.map((s) => _StatItem(value: s.$1, labelKey: s.$2, lp: lp)).toList(),
              ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, labelKey;
  final AppProvider lp;
  const _StatItem({required this.value, required this.labelKey, required this.lp});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [VivumColors.amber, VivumColors.teal],
        ).createShader(bounds),
        child: Text(value, style: GoogleFonts.syne(
          fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white)),
      ),
      const SizedBox(height: 8),
      Text(lp.t(labelKey), style: theme.textTheme.bodyMedium),
    ]);
  }
}

// ─── PORTFOLIO TEASER ───────────────────────────────────────────────────────
class _PortfolioTeaser extends StatelessWidget {
  final AppProvider lp;
  const _PortfolioTeaser({required this.lp});

  static const _projects = [
    ('Real Estate Brand & Website', 'Real Estate • UAE', [VivumColors.teal, Color(0xFF006B7A)]),
    ('AI Customer Service Bot', 'AI & Automation • UAE', [VivumColors.amber, Color(0xFF6B3800)]),
    ('E-commerce Platform', 'Retail • Saudi Arabia', [Color(0xFF3A3D7A), Color(0xFF2B2D5E)]),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
      child: Column(
        children: [
          SectionReveal(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _SectionLabel('SELECTED WORK'),
                const SizedBox(height: 12),
                Text(lp.t('portfolio.title'),
                  style: theme.textTheme.displaySmall),
              ]),
              TextButton.icon(
                onPressed: () => context.go('/portfolio'),
                icon: const Icon(Icons.arrow_forward_rounded, color: VivumColors.teal),
                label: Text(lp.t('portfolio.view'),
                  style: GoogleFonts.inter(color: VivumColors.teal, fontWeight: FontWeight.w600)),
              ),
            ],
          )),
          const SizedBox(height: 48),
          isWide
              ? Row(
                  children: _projects.asMap().entries.map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: e.key < _projects.length - 1 ? 20 : 0),
                      child: SectionReveal(
                        delay: Duration(milliseconds: e.key * 150),
                        child: _ProjectCard(title: e.value.$1, subtitle: e.value.$2, colors: e.value.$3, lp: lp),
                      ),
                    ),
                  )).toList(),
                )
              : Column(
                  children: _projects.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _ProjectCard(title: p.$1, subtitle: p.$2, colors: p.$3, lp: lp),
                  )).toList(),
                ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title, subtitle;
  final List<Color> colors;
  final AppProvider lp;
  const _ProjectCard({required this.title, required this.subtitle, required this.colors, required this.lp});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/portfolio'),
        child: AnimatedContainer(
          duration: 300.ms,
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: widget.colors,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: _hovered
                ? [BoxShadow(color: widget.colors[0].withValues(alpha: 0.3), blurRadius: 30)]
                : [],
          ),
          child: Stack(children: [
            // Grid pattern overlay
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            // Hover overlay
            AnimatedContainer(
              duration: 300.ms,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: _hovered ? 0.5 : 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.subtitle,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(widget.title,
                    style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                  AnimatedOpacity(
                    opacity: _hovered ? 1.0 : 0.0,
                    duration: 200.ms,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(children: [
                        Text(widget.lp.t('portfolio.view'),
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
                              color: Colors.white)),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

// ─── WHY VIVUM ──────────────────────────────────────────────────────────────
class _WhyVivum extends StatelessWidget {
  final AppProvider lp;
  const _WhyVivum({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);
    final pillars = [
      (Icons.palette_outlined, 'about.creative', 'about.creative.desc', VivumColors.teal),
      (Icons.code_rounded, 'about.tech', 'about.tech.desc', VivumColors.amber),
      (Icons.psychology_outlined, 'pkg.ai.title', 'pkg.ai.desc', VivumColors.teal),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
      ),
      child: Column(
        children: [
          SectionReveal(child: Column(children: [
            const _SectionLabel('WHY VIVUM'),
            const SizedBox(height: 12),
            Text('Our Three Pillars',
              style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
          ])),
          const SizedBox(height: 64),
          isWide
              ? Row(
                  children: pillars.asMap().entries.map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: e.key < pillars.length - 1 ? 24 : 0),
                      child: SectionReveal(
                        delay: Duration(milliseconds: e.key * 150),
                        child: _PillarCard(icon: e.value.$1, titleKey: e.value.$2,
                            descKey: e.value.$3, accent: e.value.$4, lp: lp),
                      ),
                    ),
                  )).toList(),
                )
              : Column(
                  children: pillars.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _PillarCard(icon: p.$1, titleKey: p.$2, descKey: p.$3, accent: p.$4, lp: lp),
                  )).toList(),
                ),
        ],
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final IconData icon;
  final String titleKey, descKey;
  final Color accent;
  final AppProvider lp;
  const _PillarCard({required this.icon, required this.titleKey, required this.descKey, required this.accent, required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: accent, size: 26),
        ),
        const SizedBox(height: 24),
        Text(lp.t(titleKey),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(lp.t(descKey),
          style: theme.textTheme.bodyMedium),
      ]),
    );
  }
}

// ─── CTA BANNER ─────────────────────────────────────────────────────────────
class _CtaBanner extends StatelessWidget {
  final AppProvider lp;
  const _CtaBanner({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(isWide ? 80 : 24, 0, isWide ? 80 : 24, 80),
      padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 24, vertical: isWide ? 70 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: isDark 
              ? [const Color(0xFF0E2A40), const Color(0xFF0A1F35), const Color(0xFF0D1535)]
              : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0), const Color(0xFFF1F5F9)],
        ),
        border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: VivumColors.teal.withValues(alpha: isDark ? 0.05 : 0.1), 
              blurRadius: 60, 
              spreadRadius: 10),
        ],
      ),
      child: SectionReveal(
        child: Column(children: [
          Text(lp.isAr ? 'جاهز لتحويل عملك؟' : 'Ready to Transform Your Business?',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: isWide ? 42 : 28, 
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(lp.isAr 
              ? 'انضم إلى الشركات في الإمارات والسعودية وسوريا التي تثق بـ فيفوم.'
              : 'Join businesses across UAE, Saudi Arabia, and Syria who trust VIVUM.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center),
          const SizedBox(height: 36),
          VivumButton(
            label: lp.t('hero.cta2'),
            onTap: () => context.go('/contact'),
            variant: ButtonVariant.teal,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
          ),
        ]),
      ),
    );
  }
}

// ─── SHARED ──────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: VivumColors.teal.withValues(alpha: 0.08),
        border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
