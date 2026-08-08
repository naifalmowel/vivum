import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../theme/personal_info.dart';
import '../l10n/translations.dart';

class VivumFooter extends StatelessWidget {
  const VivumFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery
        .of(context)
        .size
        .width > 768;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
        color: theme.scaffoldBackgroundColor, // Use theme background color
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
                const Row(
                  children: [
                    _CountryFlag(flagAsset: 'assets/flags/uae.webp', nameKey: 'footer.uae'),
                    _CountryFlag(flagAsset: 'assets/flags/sau.webp', nameKey: 'footer.ksa'),
                    _CountryFlag(flagAsset: 'assets/flags/syr.webp', nameKey: 'footer.syria'),
                  ],
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
                const SizedBox(height: 20),
                const Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _CountryFlag(flagAsset: 'assets/flags/uae.webp', nameKey: 'footer.uae'),
                    _CountryFlag(flagAsset: 'assets/flags/sau.webp', nameKey: 'footer.ksa'),
                    _CountryFlag(flagAsset: 'assets/flags/syr.webp', nameKey: 'footer.syria'),
                  ],
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
         Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SocialIcon(
              icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 18),
              url: PersonalInfo.linkedin,
            ),
            _SocialIcon(
              icon: const FaIcon(FontAwesomeIcons.instagram, size: 18),
              url: PersonalInfo.instagram,
            ),
            _SocialIcon(
              icon: const FaIcon(FontAwesomeIcons.facebookF, size: 18),
              url: PersonalInfo.facebook,
            ),
            _SocialIcon(
              icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
              url: PersonalInfo.whatsapp,
            ),
            _SocialIcon(
              icon: const FaIcon(FontAwesomeIcons.behance, size: 18),
              url: PersonalInfo.behance,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final Widget icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  void _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _hovered ? VivumColors.teal.withValues(alpha: 0.15) : theme
                .dividerColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? VivumColors.teal.withValues(alpha: 0.5) : Colors
                  .transparent,
            ),
          ),
          child: Center(
            child: Theme(
              data: theme.copyWith(
                iconTheme: IconThemeData(
                  color: _hovered ? VivumColors.teal : theme.textTheme.bodySmall?.color,
                ),
              ),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String flagAsset;
  final String nameKey;
  const _CountryFlag({required this.flagAsset, required this.nameKey});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(flagAsset, width: 20, height: 14, fit: BoxFit.cover),
          ),
          const SizedBox(width: 8),
          Text(lp.t(nameKey), style: theme.textTheme.bodySmall),
        ],
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
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        ...links.map((l) =>
            Padding(
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
        Text(lp.t('nav.contact'), style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => launchUrl(Uri.parse('mailto:${PersonalInfo.email}')),
          child: Text(PersonalInfo.email, style: theme.textTheme.bodyMedium),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => launchUrl(Uri.parse('tel:${PersonalInfo.phoneNumber}')),
          child: Text(
              PersonalInfo.phoneNumber, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
