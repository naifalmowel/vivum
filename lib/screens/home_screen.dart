import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    return CustomScrollView(
      primary: true, // Use the shared PrimaryScrollController
      slivers: [
        SliverToBoxAdapter(child: _HeroSection(lp: lp)),
        SliverToBoxAdapter(child: _ServicesPreview(lp: lp)),
        SliverToBoxAdapter(child: _StatsSection(lp: lp)),
        SliverToBoxAdapter(child: _PortfolioTeaser(lp: lp)),
        SliverToBoxAdapter(child: _WhyVivum(lp: lp)),
        SliverToBoxAdapter(child: _CtaBanner(lp: lp)),
        const SliverToBoxAdapter(child: VivumFooter()),
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
      constraints: BoxConstraints(minHeight: size.height * 0.8), // Slightly reduced minHeight
      decoration: BoxDecoration(gradient: VivumColors.heroGradient(lp.isDark)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated mesh background
          Positioned.fill(child: const ParticleBackground()),
          
          // Centered Background Logo for mobile only (Purely decorative)
          if (!isWide)
            Opacity(
              opacity: lp.isDark ? 0.35 : 0.45,
              child: SizedBox(
                width: size.width * 0.85,
                height: size.width * 0.85,
                child: const RepaintBoundary(child: HeroOrbit()),
              ),
            ),

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
                    VivumColors.teal.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Responsive Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: isWide ? 80 : 40, // Reduced vertical padding on mobile
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _HeroText(lp: lp)),
                      const Expanded(flex: 5, child: HeroOrbit()),
                    ],
                  )
                : _HeroText(lp: lp), // Content is just text; Logo is in the Stack background
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
                style: const TextStyle(
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
              variant: ButtonVariant.teal,
              icon: const Icon(Icons.rocket_launch_rounded, size: 18, color: Colors.white),
            ),
            VivumButton(
              label: lp.t('portfolio.view_all'),
              onTap: () => context.go('/portfolio'),
              variant: ButtonVariant.outline,
            ),
          ],
        ),
        const SizedBox(height: 56),
        // Context-aware Scroll Indicator
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24, height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: VivumColors.teal.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 3, height: 6,
                    decoration: BoxDecoration(
                      color: VivumColors.teal,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ).animate(onPlay: (c) => c.repeat())
                   .moveY(begin: 0, end: 10, duration: 1500.ms, curve: Curves.easeInOut)
                   .fadeOut(duration: 1500.ms),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              lp.t('hero.scroll'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1500.ms),
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1100;
    final isTablet = width > 650;
    final theme = Theme.of(context);
    
    final services = [
      (Icons.palette_outlined, 'services.brand.title', 'services.brand.desc', VivumColors.teal),
      (Icons.devices_outlined, 'services.digital.title', 'services.digital.desc', VivumColors.amber),
      (Icons.psychology_outlined, 'services.ai.title', 'services.ai.desc', VivumColors.teal),
      (Icons.dns_outlined, 'services.it.title', 'services.it.desc', VivumColors.amber),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 80 : 24, vertical: 80),
      decoration: BoxDecoration(
        color: lp.isDark ? Colors.transparent : theme.colorScheme.surface,
      ),
      child: Column(
        children: [
          SectionReveal(
            child: Column(children: [
              _SectionLabel(lp.t('services.label')),
              const SizedBox(height: 12),
              Text(lp.t('services.title'),
                style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(lp.t('services.sub'),
                style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 64),
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: services.asMap().entries.map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: e.key < services.length - 1 ? 20 : 0,
                    ),
                    child: SectionReveal(
                      delay: Duration(milliseconds: e.key * 120),
                      fillHeight: true,
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
          else if (isTablet)
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildServiceItem(services[0], 0, lp),
                      const SizedBox(width: 24),
                      _buildServiceItem(services[1], 1, lp),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildServiceItem(services[2], 2, lp),
                      const SizedBox(width: 24),
                      _buildServiceItem(services[3], 3, lp),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
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

  Widget _buildServiceItem((IconData, String, String, Color) s, int index, AppProvider lp) {
    return Expanded(
      child: SectionReveal(
        delay: Duration(milliseconds: index * 120),
        fillHeight: true,
        child: _ServiceCard(
          icon: s.$1, titleKey: s.$2,
          descKey: s.$3, accent: s.$4, lp: lp,
        ),
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
      child: InkWell(
        onTap: () => context.go('/services'),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: 200.ms,
          curve: Curves.easeOutCubic,
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
                      ? widget.accent.withValues(alpha: isDark ? 0.25 : 0.2)
                      : theme.shadowColor.withValues(alpha: isDark ? 0.1 : 0.08), 
                  blurRadius: _hovered ? 40 : 20, 
                  spreadRadius: 0,
                  offset: Offset(0, _hovered ? 15 : 8))
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
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.accent)),
                  const SizedBox(width: 6),
                  Icon(widget.lp.isAr ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 14, color: widget.accent),
                ]),
              ],
            ),
          ),
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
      margin: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 40),
      padding: EdgeInsets.symmetric(vertical: isWide ? 60 : 40, horizontal: isWide ? 40 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.15 : 0.12),
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
        child: Text(value, style: const TextStyle(
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
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      decoration: BoxDecoration(
        color: lp.isDark ? Colors.transparent : theme.colorScheme.surface,
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
                return isWide 
                  ? Row(children: List.generate(3, (i) => const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: ShimmerProjectCard()))))
                  : const Column(children: [ShimmerProjectCard(), SizedBox(height: 20), ShimmerProjectCard()]);
              }
              final data = snapshot.data ?? [];
              final projects = data.take(3).map((m) => Project.fromMap(m)).toList();

              if (projects.isEmpty) {
                return Center(child: Text(lp.t('portfolio.empty')));
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
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
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
                          fillHeight: true,
                          child: _PillarCardContent(
                            icon: e.value.$1, titleKey: e.value.$2,
                            descKey: e.value.$3, accent: e.value.$4, lp: lp,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                )
              : Column(
                  children: pillars.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SectionReveal(
                      delay: Duration(milliseconds: e.key * 150),
                      child: _PillarCardContent(
                        icon: e.value.$1, titleKey: e.value.$2,
                        descKey: e.value.$3, accent: e.value.$4, lp: lp,
                      ),
                    ),
                  )).toList(),
                ),
        ],
      ),
    );
  }
}

class _PillarCardContent extends StatefulWidget {
  final IconData icon;
  final String titleKey, descKey;
  final Color accent;
  final AppProvider lp;
  const _PillarCardContent({required this.icon, required this.titleKey, required this.descKey, required this.accent, required this.lp});

  @override
  State<_PillarCardContent> createState() => _PillarCardContentState();
}

class _PillarCardContentState extends State<_PillarCardContent> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: () => context.go('/services'),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: 200.ms,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: 250.ms,
          constraints: const BoxConstraints(minHeight: 260), // Harmonize height on mobile
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: _hovered ? widget.accent.withValues(alpha: 0.5) : theme.dividerColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _hovered ? widget.accent.withValues(alpha: 0.2) : theme.shadowColor.withValues(alpha: isDark ? 0.1 : 0.08),
                blurRadius: _hovered ? 30 : 20,
                offset: Offset(0, _hovered ? 12 : 8),
              )
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: widget.accent.withValues(alpha: _hovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.accent.withValues(alpha: 0.2)),
              ),
              child: Icon(widget.icon, color: widget.accent, size: 26),
            ),
            const SizedBox(height: 24),
            Text(widget.lp.t(widget.titleKey),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(widget.lp.t(widget.descKey),
              style: theme.textTheme.bodyMedium),
          ]),
        ),
      ),
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
      color: lp.isDark ? Colors.transparent : VivumColors.lightBG,
      padding: EdgeInsets.only(bottom: 80),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24 , vertical:24),
        padding: EdgeInsets.symmetric(horizontal: isWide ? 60 : 24, vertical: isWide ? 70 : 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0E2A40), const Color(0xFF0A1F35), const Color(0xFF0D1535)]
                : [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)], // Nicer teal gradient for Light Mode
          ),
          border: Border.all(color: VivumColors.teal.withValues(alpha: isDark ? 0.2 : 0.5)),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: VivumColors.teal.withValues(alpha: isDark ? 0.1 : 0.2),
                blurRadius: 20,
                spreadRadius: 3),
          ],
        ),
        child: SectionReveal(
          child: Column(children: [
            Text(lp.t('cta.title'),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: isWide ? 42 : 28, 
                color: isDark ? Colors.white : const Color(0xFF004D40), // Darker teal for text
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(lp.t('cta.sub'),
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
        _SectionLabel(lp.t('portfolio.label')),
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
          style: const TextStyle(color: VivumColors.teal, fontWeight: FontWeight.w600)),
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
      child: Text(text, style: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700,
        color: VivumColors.teal, letterSpacing: 1.2)),
    );
  }
}
