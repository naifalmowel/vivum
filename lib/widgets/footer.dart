import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';

class VivumFooter extends StatelessWidget {
  const VivumFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
        color: theme.brightness == Brightness.dark 
            ? const Color(0xFF07091A) 
            : const Color(0xFFF1F5F9),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24, 
        vertical: 60
      ),
      child: Column(
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _BrandColumn(lp: lp)),
                const SizedBox(width: 40),
                Expanded(child: _LinkColumn(
                  title: lp.t('nav.services'), 
                  links: [
                    (lp.t('services.brand.title'), '/services'),
                    (lp.t('services.digital.title'), '/services'),
                    (lp.t('services.ai.title'), '/services'),
                    (lp.t('services.it.title'), '/services'),
                  ]
                )),
                Expanded(child: _LinkColumn(
                  title: lp.t('footer.company'), 
                  links: [
                    (lp.t('nav.about'), '/about'),
                    (lp.t('nav.portfolio'), '/portfolio'),
                    (lp.t('nav.process'), '/process'),
                    (lp.t('nav.contact'), '/contact'),
                  ]
                )),
                Expanded(child: _ContactColumn(lp: lp)),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrandColumn(lp: lp),
                const SizedBox(height: 48),
                _LinkColumn(
                  title: lp.t('nav.services'), 
                  links: [
                    (lp.t('services.brand.title'), '/services'),
                    (lp.t('services.digital.title'), '/services'),
                    (lp.t('services.ai.title'), '/services'),
                    (lp.t('services.it.title'), '/services'),
                  ]
                ),
                const SizedBox(height: 32),
                _LinkColumn(
                  title: lp.t('footer.company'), 
                  links: [
                    (lp.t('nav.about'), '/about'),
                    (lp.t('nav.portfolio'), '/portfolio'),
                    (lp.t('nav.process'), '/process'),
                    (lp.t('nav.contact'), '/contact'),
                  ]
                ),
                const SizedBox(height: 48),
                _ContactColumn(lp: lp),
              ],
            ),
          const SizedBox(height: 64),
          Container(height: 1, color: theme.dividerColor),
          const SizedBox(height: 32),
          if (isWide)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2025 VIVUM Digital Agency. ${lp.t('footer.rights')}',
                  style: theme.textTheme.bodySmall,
                ),
                Row(
                  children: [lp.t('footer.uae'), lp.t('footer.ksa'), lp.t('footer.syria')].map((m) => Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(m, style: theme.textTheme.bodySmall),
                  )).toList(),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '© 2025 VIVUM Digital Agency.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  lp.t('footer.rights'),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [lp.t('footer.uae'), lp.t('footer.ksa'), lp.t('footer.syria')].map((m) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(m, style: theme.textTheme.bodySmall),
                  )).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  final AppProvider lp;
  const _BrandColumn({required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w900, 
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
        const SizedBox(height: 20),
        Text(
          lp.t('hero.sub'),
          style: theme.textTheme.bodyMedium,
          maxLines: 4, overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 28),
        const Row(
          children: [
            _SocialIcon(icon: Icons.link, label: 'LinkedIn'),
            _SocialIcon(icon: Icons.camera_alt_outlined, label: 'Instagram'),
            _SocialIcon(icon: Icons.message_outlined, label: 'WhatsApp'),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  const _SocialIcon({required this.icon, required this.label});
  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: _hovered ? VivumColors.teal.withValues(alpha: 0.15) : theme.dividerColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? VivumColors.teal.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Icon(widget.icon, size: 18,
          color: _hovered ? VivumColors.teal : theme.textTheme.bodySmall?.color),
      ),
    );
  }
}

class _LinkColumn extends StatelessWidget {
  final String title;
  final List<(String, String)> links;
  const _LinkColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        ...links.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.go(l.$2),
            borderRadius: BorderRadius.circular(4),
            child: Text(
              l.$1, 
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              )
            ),
          ),
        )),
      ],
    );
  }
}

class _ContactColumn extends StatelessWidget {
  final AppProvider lp;
  const _ContactColumn({required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lp.t('nav.contact'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        Text('info@vivum.agency', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Text('+971 XX XXX XXXX', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [lp.t('footer.uae'), lp.t('footer.ksa'), lp.t('footer.syria')].map((m) =>
            Text(m, style: theme.textTheme.bodySmall),
          ).toList(),
        ),
      ],
    );
  }
}
