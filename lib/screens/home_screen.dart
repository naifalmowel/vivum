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
      primary: true, 
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
      constraints: BoxConstraints(minHeight: size.height * 0.8),
      decoration: BoxDecoration(gradient: VivumColors.heroGradient(lp.isDark)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: const ParticleBackground()),
          if (!isWide)
            Opacity(
              opacity: lp.isDark ? 0.35 : 0.45,
              child: SizedBox(
                width: size.width * 0.85,
                height: size.width * 0.85,
                child: const RepaintBoundary(child: HeroOrbit()),
              ),
            ),
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: isWide ? 80 : 40,
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _HeroText(lp: lp)),
                      const Expanded(flex: 5, child: HeroOrbit()),
                    ],
                  )
                : _HeroText(lp: lp),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: VivumColors.teal.withValues(alpha: 0.1),
            border: Border.all(color: VivumColors.teal.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: VivumColors.teal)),
            const SizedBox(width: 8),
            Text(lp.t('hero.badge'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: VivumColors.teal)),
          ]),
        ),
        const SizedBox(height: 28),
        RichText(
          text: TextSpan(
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: size.width > 1200 ? 68 : (size.width > 600 ? 48 : 36),
              height: 1.05,
            ),
            children: [
              TextSpan(text: '${lp.t('hero.headline1')}\n'),
              TextSpan(text: '${lp.t('hero.headline2')}\n'),
              TextSpan(text: lp.t('hero.headline3'), style: headline3Style),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(lp.t('hero.sub'), style: theme.textTheme.bodyLarge),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16, runSpacing: 16,
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
                    decoration: BoxDecoration(color: VivumColors.teal, borderRadius: BorderRadius.circular(2)),
                  ).animate(onPlay: (c) => c.repeat()).moveY(begin: 0, end: 10, duration: 1500.ms, curve: Curves.easeInOut).fadeOut(duration: 1500.ms),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(lp.t('hero.scroll'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withValues(alpha: 0.3), letterSpacing: 1.0)),
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
    final theme = Theme.of(context);
    
    final services = [
      (Icons.palette_outlined, 'services.brand.title', 'services.brand.desc', VivumColors.teal),
      (Icons.devices_outlined, 'services.digital.title', 'services.digital.desc', VivumColors.amber),
      (Icons.psychology_outlined, 'services.ai.title', 'services.ai.desc', VivumColors.teal),
      (Icons.dns_outlined, 'services.it.title', 'services.it.desc', VivumColors.amber),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width > 900 ? 80 : 24, vertical: 80),
      decoration: BoxDecoration(color: lp.isDark ? Colors.transparent : theme.colorScheme.surface),
      child: Column(
        children: [
          SectionReveal(
            child: Column(children: [
              _SectionLabel(lp.t('services.label')),
              const SizedBox(height: 12),
              Text(lp.t('services.title'), style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(lp.t('services.sub'), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 64),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : (width > 700 ? 2 : 1),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              mainAxisExtent: 280,
            ),
            itemCount: services.length,
            itemBuilder: (context, i) => SectionReveal(
              delay: Duration(milliseconds: i * 100),
              child: _ServiceCard(icon: services[i].$1, titleKey: services[i].$2, descKey: services[i].$3, accent: services[i].$4, lp: lp),
            ),
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
    return MouseRegion(
      onEnter: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) setState(() => _hovered = true); }); },
      onExit: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) setState(() => _hovered = false); }); },
      child: InkWell(
        onTap: () => context.go('/services'),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: 200.ms,
          child: AnimatedContainer(
            duration: 250.ms,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: _hovered ? widget.accent.withValues(alpha: 0.4) : theme.dividerColor),
              borderRadius: BorderRadius.circular(20),
              boxShadow: _hovered ? [BoxShadow(color: widget.accent.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10))] : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: widget.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(widget.icon, color: widget.accent, size: 24),
                ),
                const SizedBox(height: 20),
                Text(widget.lp.t(widget.titleKey), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Expanded(child: Text(widget.lp.t(widget.descKey), style: theme.textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis)),
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
    final stats = [('50+', 'stats.projects'), ('3', 'stats.markets'), ('5+', 'stats.years'), ('100%', 'stats.satisfaction')];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 40),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      decoration: BoxDecoration(color: theme.colorScheme.surface, border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(32)),
      child: isWide
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: stats.map((s) => _StatItem(value: s.$1, labelKey: s.$2, lp: lp)).toList())
          : Wrap(alignment: WrapAlignment.center, spacing: 40, runSpacing: 32, children: stats.map((s) => _StatItem(value: s.$1, labelKey: s.$2, lp: lp)).toList()),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, labelKey;
  final AppProvider lp;
  const _StatItem({required this.value, required this.labelKey, required this.lp});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(colors: [VivumColors.amber, VivumColors.teal]).createShader(bounds),
        child: Text(value, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white)),
      ),
      const SizedBox(height: 8),
      Text(lp.t(labelKey), style: Theme.of(context).textTheme.bodyMedium),
    ]);
  }
}

// ─── PORTFOLIO TEASER ───────────────────────────────────────────────────────
class _PortfolioTeaser extends StatelessWidget {
  final AppProvider lp;
  const _PortfolioTeaser({required this.lp});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width > 900 ? 80 : 24, vertical: 80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _SectionLabel(lp.t('portfolio.label')),
                const SizedBox(height: 12),
                Text(lp.t('portfolio.title'), style: Theme.of(context).textTheme.displaySmall),
              ]),
              if (width > 600) _ViewAllButton(lp: lp),
            ],
          ),
          const SizedBox(height: 48),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: DatabaseService.getProjectsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final data = snapshot.data ?? [];
              final projects = data.take(3).map((m) => Project.fromMap(m)).toList();

              if (projects.isEmpty) {
                return Center(child: Text(lp.t('portfolio.empty')));
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > 1100 ? 3 : (width > 700 ? 2 : 1),
                  crossAxisSpacing: 24, 
                  mainAxisSpacing: 24, 
                  mainAxisExtent: width > 1100 ? 540 : 500, // Matched with portfolio_screen
                ),
                itemCount: projects.length,
                itemBuilder: (context, i) => ProjectCard(project: projects[i]),
              );
            },
          ),
          if (width <= 600) ...[const SizedBox(height: 32), _ViewAllButton(lp: lp)],
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
    final width = MediaQuery.of(context).size.width;
    final pillars = [(Icons.palette_outlined, 'about.creative', 'about.creative.desc', VivumColors.teal), (Icons.code_rounded, 'about.tech', 'about.tech.desc', VivumColors.amber), (Icons.psychology_outlined, 'about.ai', 'about.ai.desc', VivumColors.teal)];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width > 900 ? 80 : 24, vertical: 80),
      decoration: BoxDecoration(
        color: lp.isDark ? Colors.transparent : VivumColors.lightBG,
      ),
      child: Column(
        children: [
          _SectionLabel(lp.t('pillars.label')),
          const SizedBox(height: 12),
          Text(lp.t('pillars.title'), style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
          const SizedBox(height: 64),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > 1100 ? 3 : (width > 700 ? 2 : 1),
              crossAxisSpacing: 24, mainAxisSpacing: 24, mainAxisExtent: 260,
            ),
            itemCount: pillars.length,
            itemBuilder: (context, i) => _PillarCardContent(icon: pillars[i].$1, titleKey: pillars[i].$2, descKey: pillars[i].$3, accent: pillars[i].$4, lp: lp),
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
    return MouseRegion(
      onEnter: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) setState(() => _hovered = true); }); },
      onExit: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) setState(() => _hovered = false); }); },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, 
          border: Border.all(color: _hovered ? widget.accent : theme.dividerColor), 
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered ? [BoxShadow(color: widget.accent.withValues(alpha: 0.15), blurRadius: 30)] : [],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(widget.icon, color: widget.accent, size: 32),
          const SizedBox(height: 24),
          Text(widget.lp.t(widget.titleKey), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(widget.lp.t(widget.descKey), style: theme.textTheme.bodyMedium),
        ]),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(80),
      child: Container(
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(gradient: VivumColors.tealGradient, borderRadius: BorderRadius.circular(32)),
        child: Column(children: [
          Text(lp.t('cta.title'), style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
          const SizedBox(height: 36),
          VivumButton(label: lp.t('hero.cta2'), onTap: () => context.go('/contact'), variant: ButtonVariant.amber),
        ]),
      ),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final AppProvider lp;
  const _ViewAllButton({required this.lp});
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(onPressed: () => context.go('/portfolio'), icon: const Icon(Icons.arrow_forward_rounded, color: VivumColors.teal), label: Text(lp.t('portfolio.view_all'), style: const TextStyle(color: VivumColors.teal, fontWeight: FontWeight.bold)));
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: VivumColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: VivumColors.teal, letterSpacing: 1.2)));
  }
}
