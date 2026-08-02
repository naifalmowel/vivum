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
import '../widgets/project_widgets.dart';
import '../services/database_service.dart';

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
          const Positioned.fill(child: RepaintBoundary(child: ParticleBackground())),
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
                      const Expanded(flex: 4, child: RepaintBoundary(child: HeroOrbit())),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _HeroText(lp: lp),
                      const SizedBox(height: 40),
                      const SizedBox(height: 320, child: RepaintBoundary(child: HeroOrbit())),
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
                    fontWeight: FontWeight.w600,
                    color: VivumColors.teal)),
          ]),
        ),
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
        ),
        const SizedBox(height: 24),
        Text(
          lp.t('hero.sub'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            VivumButton(
              label: lp.t('hero.cta2'),
              onTap: () => context.go('/contact'),
              variant: ButtonVariant.amber,
              icon: Icon(lp.isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ),
            VivumButton(
              label: lp.t('hero.cta1'),
              onTap: () => context.go('/portfolio'),
              variant: ButtonVariant.outline,
            ),
          ],
        ),
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
        ),
      ],
    ).animate().fadeIn(duration: 800.ms);
  }
}

// ─── SERVICES PREVIEW ──────────────────────────────────────────────────────
class _ServicesPreview extends StatelessWidget {
  final AppProvider lp;
  const _ServicesPreview({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);
    final services = [
      (Icons.palette_outlined, 'services.brand.title', 'services.brand.desc', VivumColors.teal),
      (Icons.devices_outlined, 'services.digital.title', 'services.digital.desc', VivumColors.amber),
      (Icons.psychology_outlined, 'services.ai.title', 'services.ai.desc', VivumColors.teal),
      (Icons.dns_outlined, 'services.it.title', 'services.it.desc', VivumColors.amber),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
      decoration: BoxDecoration(
        color: lp.isDark ? Colors.transparent : theme.colorScheme.surface,
      ),
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
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: services.asMap().entries.map((e) => Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: e.key < services.length - 1 ? 20 : 0,
                        ),
                        child: SectionReveal(
                          delay: Duration(milliseconds: e.key * 120),
                          child: GestureDetector(
                            onTap: () => context.go('/services'),
                            child: _ServiceCard(
                              icon: e.value.$1, titleKey: e.value.$2,
                              descKey: e.value.$3, accent: e.value.$4, lp: lp,
                            ),
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                )
              : Column(
                  children: services.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => context.go('/services'),
                      child: _ServiceCard(icon: s.$1, titleKey: s.$2, descKey: s.$3, accent: s.$4, lp: lp),
                    ),
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
            color: _hovered ? widget.accent.withValues(alpha: 0.4) : theme.dividerColor.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _hovered 
                  ? widget.accent.withValues(alpha: isDark ? 0.15 : 0.1)
                  : theme.shadowColor.withValues(alpha: isDark ? 0.05 : 0.02), 
              blurRadius: _hovered ? 32 : 20, 
              spreadRadius: 0,
              offset: Offset(0, _hovered ? 12 : 6))
          ],
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
              Icon(widget.lp.isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 14, color: widget.accent),
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
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
      padding: EdgeInsets.symmetric(vertical: isWide ? 60 : 40, horizontal: isWide ? 40 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.1 : 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: SectionReveal(
        child: isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: stats.map((s) => _StatItem(value: s.$1, labelKey: s.$2, lp: lp)).toList(),
              )
            : Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 40, 
                  runSpacing: 32,
                  children: stats.map((s) => ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 140),
                    child: _StatItem(value: s.$1, labelKey: s.$2, lp: lp),
                  )).toList(),
                ),
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
          fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
      decoration: BoxDecoration(
        color: lp.isDark ? Colors.transparent : VivumColors.lightBGAlt,
      ),
      child: Column(
        children: [
          SectionReveal(
            child: isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _PortfolioHeader(lp: lp, theme: theme),
                      _ViewAllButton(lp: lp),
                    ],
                  )
                : Column(
                    children: [
                      _PortfolioHeader(lp: lp, theme: theme, centered: true),
                      const SizedBox(height: 16),
                      _ViewAllButton(lp: lp),
                    ],
                  ),
          ),
          const SizedBox(height: 48),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: DatabaseService.getProjectsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data ?? [];
              final projects = data.take(3).map((m) => Project.fromMap(m)).toList();

              if (projects.isEmpty) {
                return const Center(child: Text('No projects found.'));
              }

              return isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: projects.asMap().entries.map((e) => Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: e.key < projects.length - 1 ? 20 : 0,
                            ),
                            child: SectionReveal(
                              delay: Duration(milliseconds: e.key * 150),
                              child: ProjectCard(
                                project: e.value,
                                viewLabel: lp.t('portfolio.view'),
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                    )
                  : Column(
                      children: projects.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ProjectCard(
                          project: p,
                          viewLabel: lp.t('portfolio.view'),
                        ),
                      )).toList(),
                    );
            },
          ),
        ],
      ),
    );
  }
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
      (Icons.psychology_outlined, 'about.ai', 'about.ai.desc', VivumColors.teal),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
      decoration: BoxDecoration(
        color: lp.isDark ? theme.scaffoldBackgroundColor.withValues(alpha: 0.5) : VivumColors.lightBG,
      ),
      child: Column(
        children: [
          SectionReveal(child: Column(children: [
            _SectionLabel(lp.t('pillars.label')),
            const SizedBox(height: 12),
            Text(lp.t('pillars.title'),
              style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
          ])),
          const SizedBox(height: 64),
          isWide
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: pillars.asMap().entries.map((e) => Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: e.key < pillars.length - 1 ? 24 : 0,
                        ),
                        child: SectionReveal(
                          delay: Duration(milliseconds: e.key * 150),
                          child: _PillarCard(icon: e.value.$1, titleKey: e.value.$2,
                              descKey: e.value.$3, accent: e.value.$4, lp: lp),
                        ),
                      ),
                    )).toList(),
                  ),
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
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.05 : 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
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
      width: double.infinity,
      color: lp.isDark ? Colors.transparent : VivumColors.lightBGAlt,
      padding: EdgeInsets.only(bottom: 80),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
        padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 24, vertical: isWide ? 70 : 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark 
                ? [const Color(0xFF0E2A40), const Color(0xFF0A1F35), const Color(0xFF0D1535)]
                : [VivumColors.teal.withValues(alpha: 0.05), VivumColors.teal.withValues(alpha: 0.1)],
          ),
          border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: VivumColors.teal.withValues(alpha: isDark ? 0.1 : 0.05), 
                blurRadius: 60, 
                spreadRadius: 10),
          ],
        ),
        child: SectionReveal(
          child: Column(children: [
            Text(lp.isAr ? 'جاهز لتحويل عملك؟' : 'Ready to Transform Your Business?',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: isWide ? 42 : 28, 
                color: isDark ? Colors.white : VivumColors.tealDark,
              ),
              textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(lp.isAr 
                ? 'انضم إلى الشركات في الإمارات والسعودية وسوريا التي تثق بـ فيفوم.'
                : 'Join businesses across UAE, Saudi Arabia, and Syria who trust VIVUM.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? VivumColors.darkMuted : VivumColors.lightMuted,
              ),
              textAlign: TextAlign.center),
            const SizedBox(height: 36),
            VivumButton(
              label: lp.t('hero.cta2'),
              onTap: () => context.go('/contact'),
              variant: ButtonVariant.teal,
              icon: Icon(lp.isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ),
          ]),
        ),
      ),
    );
  }
}

class _PortfolioHeader extends StatelessWidget {
  final AppProvider lp;
  final ThemeData theme;
  final bool centered;
  const _PortfolioHeader({required this.lp, required this.theme, this.centered = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const _SectionLabel('SELECTED WORK'),
        const SizedBox(height: 12),
        Text(lp.t('portfolio.title'),
            style: theme.textTheme.displaySmall, textAlign: centered ? TextAlign.center : TextAlign.start),
      ],
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final AppProvider lp;
  const _ViewAllButton({required this.lp});
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => context.go('/portfolio'),
      icon: Icon(lp.isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, color: VivumColors.teal),
      label: Text(lp.t('portfolio.view'),
          style: GoogleFonts.inter(color: VivumColors.teal, fontWeight: FontWeight.w600)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: VivumColors.teal.withValues(alpha: 0.1),
        border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w700,
        color: VivumColors.teal, letterSpacing: 1.2)),
    );
  }
}
