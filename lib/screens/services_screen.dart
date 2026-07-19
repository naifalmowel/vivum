import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/section_reveal.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);

    final categories = [
      _ServiceCategory(
        number: '01',
        icon: Icons.palette_outlined,
        titleKey: 'services.brand.title',
        descKey: 'services.brand.desc',
        accent: VivumColors.teal,
        items: ['Logo Design', 'Complete Brand Identity', 'Visual Guidelines', 'Social Media Branding'],
      ),
      _ServiceCategory(
        number: '02',
        icon: Icons.devices_outlined,
        titleKey: 'services.digital.title',
        descKey: 'services.digital.desc',
        accent: VivumColors.amber,
        items: ['Website Design & Development', 'Mobile Applications', 'E-commerce Solutions'],
      ),
      _ServiceCategory(
        number: '03',
        icon: Icons.psychology_outlined,
        titleKey: 'services.ai.title',
        descKey: 'services.ai.desc',
        accent: VivumColors.teal,
        items: ['AI Chatbots', 'WhatsApp Automation', 'Smart Business Solutions', 'Digital Transformation'],
      ),
      _ServiceCategory(
        number: '04',
        icon: Icons.dns_outlined,
        titleKey: 'services.it.title',
        descKey: 'services.it.desc',
        accent: VivumColors.amber,
        items: ['Business Email Solutions', 'Cloud Services', 'Technical Support', 'Digital Infrastructure Consulting'],
      ),
    ];

    return Column(
      children: [
        // Page Hero
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
          decoration: BoxDecoration(
            gradient: VivumColors.heroGradient(lp.isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label('OUR SERVICES'),
              const SizedBox(height: 20),
              Text(lp.t('services.title'),
                style: theme.textTheme.displayMedium),
              const SizedBox(height: 16),
              Text(lp.t('services.sub'),
                style: theme.textTheme.bodyLarge),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),

        // Service Categories
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
          child: Column(
            children: categories.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SectionReveal(
                key: ValueKey(e.key),
                delay: Duration(milliseconds: e.key * 100),
                child: _ServiceCategoryCard(cat: e.value, lp: lp, isEven: e.key % 2 == 0),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class _ServiceCategory {
  final String number, titleKey, descKey;
  final IconData icon;
  final Color accent;
  final List<String> items;
  const _ServiceCategory({
    required this.number, required this.icon, required this.titleKey,
    required this.descKey, required this.accent, required this.items,
  });
}

class _ServiceCategoryCard extends StatefulWidget {
  final _ServiceCategory cat;
  final AppProvider lp;
  final bool isEven;
  const _ServiceCategoryCard({required this.cat, required this.lp, required this.isEven});
  @override
  State<_ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<_ServiceCategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 250.ms,
        padding: EdgeInsets.all(isWide ? 40 : 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(
            color: _hovered ? widget.cat.accent.withValues(alpha: 0.4) : theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered
              ? [BoxShadow(color: widget.cat.accent.withValues(alpha: isDark ? 0.06 : 0.04), blurRadius: 40)]
              : [],
        ),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Number + Icon
                  Column(
                    children: [
                      Text(widget.cat.number,
                        style: GoogleFonts.syne(
                          fontSize: 80, fontWeight: FontWeight.w800,
                          color: theme.dividerColor, height: 1,
                        )),
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: 250.ms,
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          color: widget.cat.accent.withValues(alpha: _hovered ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: widget.cat.accent.withValues(alpha: _hovered ? 0.4 : 0.15)),
                        ),
                        child: Icon(widget.cat.icon, color: widget.cat.accent, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.lp.t(widget.cat.titleKey),
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        Text(widget.lp.t(widget.cat.descKey),
                          style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: widget.cat.items.map((item) => _ServiceChip(label: item, color: widget.cat.accent)).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(widget.cat.number,
                      style: GoogleFonts.syne(fontSize: 48, fontWeight: FontWeight.w800, color: theme.dividerColor)),
                    const Spacer(),
                    Icon(widget.cat.icon, color: widget.cat.accent, size: 32),
                  ]),
                  const SizedBox(height: 16),
                  Text(widget.lp.t(widget.cat.titleKey),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(widget.lp.t(widget.cat.descKey),
                    style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: widget.cat.items.map((item) => _ServiceChip(label: item, color: widget.cat.accent)).toList(),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ServiceChip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.check_rounded, size: 12, color: color),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.85))),
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
        fontSize: 11, fontWeight: FontWeight.w600,
        color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
