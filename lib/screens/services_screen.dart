import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/section_reveal.dart';

import '../widgets/footer.dart';

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
      mainAxisSize: MainAxisSize.min,
      children: [
        // Page Hero
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: isWide ? 100 : 60),
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
            children: [
              ...categories.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: SectionReveal(
                  key: ValueKey(e.key),
                  delay: Duration(milliseconds: e.key * 100),
                  child: _ServiceCategoryCard(cat: e.value, lp: lp, isEven: e.key % 2 == 0),
                ),
              )),
              const SizedBox(height: 100),
              _PricingSummary(lp: lp),
              const SizedBox(height: 100),
              _PackagesSection(lp: lp),
            ],
          ),
        ),
        const VivumFooter(),
      ],
    );
  }
}

class _PricingSummary extends StatelessWidget {
  final AppProvider lp;
  const _PricingSummary({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);

    return Column(
      children: [
        SectionReveal(
          child: Column(children: [
            const _Label('PRICING'),
            const SizedBox(height: 12),
            Text(lp.t('pricing.starting'),
                style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
          ]),
        ),
        const SizedBox(height: 48),
        isWide 
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PriceItem(label: lp.t('pricing.website'), price: '2,500'),
                _PriceDivider(),
                _PriceItem(label: lp.t('pricing.branding'), price: '2,000'),
                _PriceDivider(),
                _PriceItem(label: lp.t('pricing.ai'), price: lp.t('pricing.custom'), isCustom: true),
              ],
            )
          : Column(
              children: [
                _PriceItem(label: lp.t('pricing.website'), price: '2,500'),
                const SizedBox(height: 24),
                _PriceItem(label: lp.t('pricing.branding'), price: '2,000'),
                const SizedBox(height: 24),
                _PriceItem(label: lp.t('pricing.ai'), price: lp.t('pricing.custom'), isCustom: true),
              ],
            ),
      ],
    );
  }
}

class _PriceDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      color: Theme.of(context).dividerColor,
    );
  }
}

class _PriceItem extends StatelessWidget {
  final String label, price;
  final bool isCustom;
  const _PriceItem({required this.label, required this.price, this.isCustom = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = AppProvider.of(context);
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: VivumColors.teal),
            children: [
              if (!isCustom) TextSpan(text: '${lp.t('pricing.aed')} ', style: theme.textTheme.titleMedium?.copyWith(color: VivumColors.teal)),
              TextSpan(text: price),
            ],
          ),
        ),
      ],
    );
  }
}

class _PackagesSection extends StatelessWidget {
  final AppProvider lp;
  const _PackagesSection({required this.lp});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);

    final pkgs = [
      (
        'pkg.starter.title', 'pkg.starter.price', '', 'pkg.starter.desc', 
        [lp.isAr ? 'موقع صفحة واحدة' : 'One-page Website', lp.isAr ? 'هوية بصرية مصغرة' : 'Brand Mini Guide', 'Google Business'], 
        VivumColors.teal, false
      ),
      (
        'pkg.business.title', 'pkg.business.price', '', 'pkg.business.desc', 
        [lp.isAr ? 'موقع متكامل (8 صفحات)' : 'Full Website (8 pages)', lp.isAr ? 'هوية بصرية كاملة' : 'Full Brand Identity', 'Social Media Kit'], 
        VivumColors.amber, true
      ),
      (
        'pkg.premium.title', 'pkg.premium.price', '', 'pkg.premium.desc', 
        ['Custom Website', 'AI Chatbot', 'WhatsApp Automation', 'CRM Integration'], 
        VivumColors.teal, false
      ),
      (
        'pkg.ai.title', 'pkg.ai.price', 'pkg.ai.monthly', 'pkg.ai.desc', 
        ['WhatsApp AI Assistant', 'Lead Collection', 'Auto FAQ', '24/7 Support Bot'], 
        VivumColors.amber, false
      ),
    ];

    return Column(
      children: [
        SectionReveal(
          child: Column(children: [
            const _Label('VIVUM PACKAGES'),
            const SizedBox(height: 12),
            Text(lp.isAr ? 'اختر الباقة المناسبة لنموك' : 'Choose Your Growth Package',
                style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
          ]),
        ),
        const SizedBox(height: 64),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 4 : 1,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            mainAxisExtent: isWide ? 580 : 540,
          ),
          itemCount: pkgs.length,
          itemBuilder: (context, i) {
            final p = pkgs[i];
            return _PackageCard(
              title: lp.t(p.$1), price: p.$2, monthly: p.$3, desc: lp.t(p.$4),
              features: p.$5, accent: p.$6, isPopular: p.$7, lp: lp,
            );
          },
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String title, price, monthly, desc;
  final List<String> features;
  final Color accent;
  final bool isPopular;
  final AppProvider lp;

  const _PackageCard({
    required this.title, required this.price, required this.monthly, required this.desc,
    required this.features, required this.accent, required this.isPopular, required this.lp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isPopular ? accent : theme.dividerColor, width: isPopular ? 2 : 1),
        boxShadow: [
          if (isPopular) BoxShadow(color: accent.withValues(alpha: 0.1), blurRadius: 30, spreadRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
              child: Text(lp.isAr ? 'الأكثر طلباً' : 'MOST POPULAR', 
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
          ],
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: theme.textTheme.headlineMedium?.copyWith(color: accent, fontWeight: FontWeight.w800),
              children: [
                TextSpan(text: '${lp.t('pricing.aed')} ', style: theme.textTheme.titleSmall?.copyWith(color: accent)),
                TextSpan(text: lp.t(price)),
                if (monthly.isNotEmpty) TextSpan(text: lp.t(monthly), style: theme.textTheme.bodySmall?.copyWith(color: accent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(desc, style: theme.textTheme.bodySmall, maxLines: 3),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 16, color: accent),
                    const SizedBox(width: 10),
                    Expanded(child: Text(f, style: theme.textTheme.bodyMedium)),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? accent : Colors.transparent,
                foregroundColor: isPopular ? Colors.white : theme.colorScheme.onSurface,
                side: isPopular ? BorderSide.none : BorderSide(color: theme.dividerColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(lp.t('nav.start')),
            ),
          ),
        ],
      ),
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
                        style: TextStyle(
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
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: theme.dividerColor)),
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
      child: Text(text, style: const TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
