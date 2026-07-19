import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/section_reveal.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Hero
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: isWide ? 100 : 60),
          decoration: BoxDecoration(
            gradient: VivumColors.heroGradient(lp.isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label('WHO WE ARE'),
              const SizedBox(height: 20),
              Text(lp.t('about.title'), style: theme.textTheme.displayMedium),
              const SizedBox(height: 24),
              Container(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(lp.t('about.story'),
                  style: theme.textTheme.bodyLarge),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),

        // Values
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
          child: Column(
            children: [
              SectionReveal(child: Column(children: [
                const _Label('OUR PILLARS'),
                const SizedBox(height: 12),
                Text('Built on Three Foundations',
                  style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
              ])),
              const SizedBox(height: 60),
              isWide
                  ? Row(children: [
                      Expanded(child: SectionReveal(delay: 0.ms, child: _PillarCard(
                        icon: Icons.palette_outlined, titleKey: 'about.creative',
                        descKey: 'about.creative.desc', accent: VivumColors.teal, lp: lp, number: '01'))),
                      const SizedBox(width: 24),
                      Expanded(child: SectionReveal(delay: 150.ms, child: _PillarCard(
                        icon: Icons.code_rounded, titleKey: 'about.tech',
                        descKey: 'about.tech.desc', accent: VivumColors.amber, lp: lp, number: '02'))),
                      const SizedBox(width: 24),
                      Expanded(child: SectionReveal(delay: 300.ms, child: _PillarCard(
                        icon: Icons.psychology_outlined, titleKey: 'about.ai',
                        descKey: 'about.ai.desc', accent: VivumColors.teal, lp: lp, number: '03'))),
                    ])
                  : Column(children: [
                      _PillarCard(icon: Icons.palette_outlined, titleKey: 'about.creative',
                        descKey: 'about.creative.desc', accent: VivumColors.teal, lp: lp, number: '01'),
                      const SizedBox(height: 20),
                      _PillarCard(icon: Icons.code_rounded, titleKey: 'about.tech',
                        descKey: 'about.tech.desc', accent: VivumColors.amber, lp: lp, number: '02'),
                      const SizedBox(height: 20),
                      _PillarCard(icon: Icons.psychology_outlined, titleKey: 'about.ai',
                        descKey: 'about.ai.desc', accent: VivumColors.teal, lp: lp, number: '03'),
                    ]),
            ],
          ),
        ),

        // Markets
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: isWide ? 80 : 60),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
          ),
          child: Column(
            children: [
              SectionReveal(child: Column(children: [
                const _Label('OUR REACH'),
                const SizedBox(height: 12),
                Text(lp.t('about.markets'),
                  style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
              ])),
              const SizedBox(height: 60),
              isWide
                  ? Row(children: [
                      Expanded(child: SectionReveal(delay: 0.ms, child: _MarketCard(
                        flag: '🇦🇪', name: 'United Arab Emirates',
                        desc: 'Dubai, Abu Dhabi, Sharjah & across the Emirates', color: VivumColors.teal))),
                      const SizedBox(width: 24),
                      Expanded(child: SectionReveal(delay: 150.ms, child: _MarketCard(
                        flag: '🇸🇦', name: 'Saudi Arabia',
                        desc: 'Riyadh, Jeddah, NEOM & Vision 2030 projects', color: VivumColors.amber))),
                      const SizedBox(width: 24),
                      Expanded(child: SectionReveal(delay: 300.ms, child: _MarketCard(
                        flag: '🇸🇾', name: 'Syria',
                        desc: 'Damascus, Aleppo & the growing digital sector', color: VivumColors.teal))),
                    ])
                  : Column(children: [
                      _MarketCard(flag: '🇦🇪', name: 'United Arab Emirates',
                        desc: 'Dubai, Abu Dhabi, Sharjah & across the Emirates', color: VivumColors.teal),
                      const SizedBox(height: 20),
                      _MarketCard(flag: '🇸🇦', name: 'Saudi Arabia',
                        desc: 'Riyadh, Jeddah, NEOM & Vision 2030 projects', color: VivumColors.amber),
                      const SizedBox(height: 20),
                      _MarketCard(flag: '🇸🇾', name: 'Syria',
                        desc: 'Damascus, Aleppo & the growing digital sector', color: VivumColors.teal),
                    ]),
            ],
          ),
        ),

        // Values
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
          child: Column(
            children: [
              SectionReveal(child: Column(children: [
                const _Label('CORE VALUES'),
                const SizedBox(height: 12),
                Text('What Drives Us', style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
              ])),
              const SizedBox(height: 60),
              isWide
                  ? GridView.count(
                      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 24, mainAxisSpacing: 24, childAspectRatio: 2.5,
                      children: [
                        _ValueCard(icon: Icons.lightbulb_outline, label: 'Innovation', desc: 'We push creative and technical boundaries on every project.', color: VivumColors.amber),
                        _ValueCard(icon: Icons.verified_outlined, label: 'Quality', desc: 'Premium output is our baseline, not our goal.', color: VivumColors.teal),
                        _ValueCard(icon: Icons.handshake_outlined, label: 'Partnership', desc: 'We build long-term relationships, not transactions.', color: VivumColors.amber),
                        _ValueCard(icon: Icons.trending_up_rounded, label: 'Growth', desc: 'Our success is measured by your business results.', color: VivumColors.teal),
                      ],
                    )
                  : Column(children: [
                      _ValueCard(icon: Icons.lightbulb_outline, label: 'Innovation', desc: 'We push creative and technical boundaries on every project.', color: VivumColors.amber),
                      const SizedBox(height: 16),
                      _ValueCard(icon: Icons.verified_outlined, label: 'Quality', desc: 'Premium output is our baseline, not our goal.', color: VivumColors.teal),
                      const SizedBox(height: 16),
                      _ValueCard(icon: Icons.handshake_outlined, label: 'Partnership', desc: 'We build long-term relationships, not transactions.', color: VivumColors.amber),
                      const SizedBox(height: 16),
                      _ValueCard(icon: Icons.trending_up_rounded, label: 'Growth', desc: 'Our success is measured by your business results.', color: VivumColors.teal),
                    ]),
            ],
          ),
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  final IconData icon;
  final String titleKey, descKey, number;
  final Color accent;
  final AppProvider lp;
  const _PillarCard({required this.icon, required this.titleKey, required this.descKey,
    required this.accent, required this.lp, required this.number});
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(width: 52, height: 52,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.2))),
            child: Icon(icon, color: accent, size: 24)),
          Text(number, style: GoogleFonts.syne(fontSize: 48, fontWeight: FontWeight.w800, color: theme.dividerColor)),
        ]),
        const SizedBox(height: 24),
        Text(lp.t(titleKey), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(lp.t(descKey), style: theme.textTheme.bodyMedium),
      ]),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final String flag, name, desc;
  final Color color;
  const _MarketCard({required this.flag, required this.name, required this.desc, required this.color});
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
        Text(flag, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 16),
        Text(name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(desc, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        Container(height: 2, width: 40,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      ]),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String label, desc;
  final Color color;
  const _ValueCard({required this.icon, required this.label, required this.desc, required this.color});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Container(width: 48, height: 48,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: theme.textTheme.titleLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(desc, style: theme.textTheme.bodySmall),
        ])),
      ]),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
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
        fontSize: 11, fontWeight: FontWeight.w600, color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
