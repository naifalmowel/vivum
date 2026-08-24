import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../theme/personal_info.dart';
import '../l10n/translations.dart';
import '../widgets/footer.dart';
import '../widgets/particle_painter.dart';
import '../widgets/glow_button.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _service = 'Brand Identity';
  bool _submitted = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _companyCtrl.dispose(); _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    
    try {
      final data = {
        'name': _nameCtrl.text,
        'email': _emailCtrl.text,
        'phone': _phoneCtrl.text,
        'company': _companyCtrl.text,
        'service': _service,
        'message': _messageCtrl.text,
        'isRead': false,
        'isReplied': false,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      await DatabaseService.saveContactRequest(data);
      if (mounted) {
        setState(() {
          _loading = false;
          _submitted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 1000;
    final theme = Theme.of(context);

    return CustomScrollView(
      primary: true,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // ─── HERO SECTION ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: isWide ? 450 : 350),
                child: Stack(
                  children: [
                    Positioned.fill(child: InternalPageHeaderBg(glowColor: VivumColors.teal)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWide ? 100 : 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80),
                          _Label(lp.t('contact.label')),
                          const SizedBox(height: 24),
                          Text(lp.t('contact.title'), style: theme.textTheme.displayMedium),
                          const SizedBox(height: 20),
                          Text(lp.t('contact.sub'),
                            style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.03),

              // ─── MAIN CONTENT ──────────────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 100 : 24, vertical: 100),
                color: theme.scaffoldBackgroundColor,
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _ContactForm(
                            formKey: _formKey, nameCtrl: _nameCtrl, emailCtrl: _emailCtrl,
                            phoneCtrl: _phoneCtrl, companyCtrl: _companyCtrl,
                            messageCtrl: _messageCtrl, service: _service,
                            onServiceChanged: (v) => setState(() => _service = v),
                            onSubmit: _submit, loading: _loading, submitted: _submitted, lp: lp,
                          )),
                          const SizedBox(width: 60),
                          Expanded(flex: 3, child: _SidebarInfo(lp: lp)),
                        ],
                      )
                    : Column(
                        children: [
                          _ContactForm(
                            formKey: _formKey, nameCtrl: _nameCtrl, emailCtrl: _emailCtrl,
                            phoneCtrl: _phoneCtrl, companyCtrl: _companyCtrl,
                            messageCtrl: _messageCtrl, service: _service,
                            onServiceChanged: (v) => setState(() => _service = v),
                            onSubmit: _submit, loading: _loading, submitted: _submitted, lp: lp,
                          ),
                          const SizedBox(height: 60),
                          _SidebarInfo(lp: lp),
                        ],
                      ),
              ),
              const VivumFooter(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, emailCtrl, phoneCtrl, companyCtrl, messageCtrl;
  final String service;
  final ValueChanged<String> onServiceChanged;
  final VoidCallback onSubmit;
  final bool loading, submitted;
  final AppProvider lp;

  const _ContactForm({
    required this.formKey, required this.nameCtrl, required this.emailCtrl,
    required this.phoneCtrl, required this.companyCtrl, required this.messageCtrl,
    required this.service, required this.onServiceChanged, required this.onSubmit,
    required this.loading, required this.submitted, required this.lp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (submitted) {
      return Container(
        height: 600,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VivumColors.teal.withValues(alpha: 0.1),
                border: Border.all(color: VivumColors.teal.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.check_circle_rounded, color: VivumColors.teal, size: 48),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            const SizedBox(height: 32),
            Text(lp.isAr ? 'تم الإرسال بنجاح!' : 'Message Sent Successfully!',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Text(lp.isAr ? 'سنقوم بالرد عليك خلال أقل من 24 ساعة.' : 'We will get back to you within 24 hours.',
                textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
          ],
        ),
      );
    }

    final inputStyle = theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface, fontSize: 15);
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.7));

    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 40, offset: const Offset(0, 20))],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lp.isAr ? 'أخبرنا عن مشروعك' : 'Let\'s Start a Project', 
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 40),
            _buildField(lp.t('contact.name'), nameCtrl, Icons.person_outline_rounded, theme, hint: lp.isAr ? 'مثال: نايف المويل' : 'e.g. Naif Al Mowel'),
            const SizedBox(height: 24),
            _buildField(lp.t('contact.email'), emailCtrl, Icons.alternate_email_rounded, theme, isEmail: true, hint: 'e.g. info@vivum.agency'),
            const SizedBox(height: 24),
            _buildField(lp.isAr ? 'رقم الهاتف' : 'Phone Number', phoneCtrl, Icons.phone_android_rounded, theme, isPhone: true, hint: '+971 XX XXX XXXX'),
            const SizedBox(height: 24),
            Text(lp.t('contact.service'), style: labelStyle),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: service,
              dropdownColor: theme.colorScheme.surface,
              decoration: _inputDecoration(null, theme, null),
              style: inputStyle,
              items: ['Brand Identity', 'Digital Experience', 'AI & Automation', 'IT Solutions', 'Consulting']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => onServiceChanged(v!),
            ),
            const SizedBox(height: 24),
            Text(lp.t('contact.message'), style: labelStyle),
            const SizedBox(height: 12),
            TextFormField(
              controller: messageCtrl,
              maxLines: 5,
              style: inputStyle,
              decoration: _inputDecoration(null, theme, lp.isAr ? 'أخبرنا عن أهداف مشروعك...' : 'Tell us about your project goals...'),
              validator: (v) => v!.isEmpty ? '?' : null,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: VivumColors.teal))
                  : VivumButton(
                      label: lp.t('contact.send'),
                      onTap: onSubmit,
                      variant: ButtonVariant.teal,
                      icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, ThemeData theme, {bool isEmail = false, bool isPhone = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        TextFormField(
          controller: ctrl,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
          decoration: _inputDecoration(icon, theme, hint),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Required';
            if (isEmail && !v.contains('@')) return 'Invalid email';
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(IconData? icon, ThemeData theme, String? hint) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, size: 20, color: VivumColors.teal.withValues(alpha: 0.7)) : null,
      filled: true,
      hintText: hint,
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3), // Semi-transparent hint
        fontSize: 14,
      ),
      // Use the scaffold background color to create a "recessed" look inside the card
      fillColor: theme.scaffoldBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)), // Visible border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: VivumColors.teal, width: 1.5),
      ),
      hoverColor: VivumColors.teal.withValues(alpha: 0.02),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}

class _SidebarInfo extends StatelessWidget {
  final AppProvider lp;
  const _SidebarInfo({required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Premium Contact Cards
        _PremiumInfoCard(
          icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 24),
          title: lp.t('contact.whatsapp'),
          value: PersonalInfo.phoneNumber,
          color: const Color(0xFF25D366),
          onTap: () => launchUrl(Uri.parse(PersonalInfo.whatsapp)),
        ),
        const SizedBox(height: 20),
        _PremiumInfoCard(
          icon: const Icon(Icons.email_rounded, size: 24),
          title: 'Email Address',
          value: PersonalInfo.email,
          color: VivumColors.teal,
          onTap: () => launchUrl(Uri.parse('mailto:${PersonalInfo.email}')),
        ),
        const SizedBox(height: 20),
        _PremiumInfoCard(
          icon: const Icon(Icons.phone_rounded, size: 24),
          title: 'Direct Call',
          value: PersonalInfo.phoneNumber,
          color: VivumColors.amber,
          onTap: () => launchUrl(Uri.parse('tel:${PersonalInfo.phoneNumber}')),
        ),
        
        const SizedBox(height: 48),
        Text(lp.t('footer.follow'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _SocialTile(icon: const FaIcon(FontAwesomeIcons.instagram, size: 18), label: 'Instagram', url: PersonalInfo.instagram, color: const Color(0xFFE1306C)),
            _SocialTile(icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 18), label: 'LinkedIn', url: PersonalInfo.linkedin, color: const Color(0xFF0A66C2)),
            _SocialTile(icon: const FaIcon(FontAwesomeIcons.behance, size: 18), label: 'Behance', url: PersonalInfo.behance, color: const Color(0xFF1769FF)),
            _SocialTile(icon: const FaIcon(FontAwesomeIcons.facebookF, size: 18), label: 'Facebook', url: PersonalInfo.facebook, color: const Color(0xFF1877F2)),
          ],
        ),

        const SizedBox(height: 48),
        // Markets Coverage
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: VivumColors.teal.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: VivumColors.teal.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lp.t('contact.coverage'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 24),
              _MarketItem(flag: 'assets/flags/uae.webp', name: lp.isAr ? 'الإمارات العربية المتحدة' : 'United Arab Emirates'),
              _MarketItem(flag: 'assets/flags/sau.webp', name: lp.isAr ? 'المملكة العربية السعودية' : 'Saudi Arabia'),
              _MarketItem(flag: 'assets/flags/syr.webp', name: lp.isAr ? 'الجمهورية العربية السورية' : 'Syria'),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05);
  }
}

class _PremiumInfoCard extends StatefulWidget {
  final Widget icon;
  final String title, value;
  final Color color;
  final VoidCallback onTap;
  const _PremiumInfoCard({required this.icon, required this.title, required this.value, required this.color, required this.onTap});
  @override
  State<_PremiumInfoCard> createState() => _PremiumInfoCardState();
}

class _PremiumInfoCardState extends State<_PremiumInfoCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hovered = true)); },
      onExit: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hovered = false)); },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _hovered ? widget.color.withValues(alpha: 0.5) : theme.dividerColor),
            boxShadow: _hovered ? [BoxShadow(color: widget.color.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))] : [],
          ),
          child: Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(color: widget.color),
                    child: widget.icon,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.dividerColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialTile extends StatefulWidget {
  final Widget icon;
  final String label, url;
  final Color color;
  const _SocialTile({required this.icon, required this.label, required this.url, required this.color});
  @override
  State<_SocialTile> createState() => _SocialTileState();
}

class _SocialTileState extends State<_SocialTile> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hovered = true)); },
      onExit: (_) { if (mounted) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hovered = false)); },
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: 250.ms,
          decoration: BoxDecoration(
            color: _hovered ? widget.color.withValues(alpha: 0.1) : theme.dividerColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hovered ? widget.color.withValues(alpha: 0.3) : Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(color: _hovered ? widget.color : theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                child: widget.icon,
              ),
              const SizedBox(width: 12),
              Text(widget.label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: _hovered ? widget.color : null)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketItem extends StatelessWidget {
  final String flag, name;
  const _MarketItem({required this.flag, required this.name});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.asset(flag, width: 32, height: 20, fit: BoxFit.cover)),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: VivumColors.teal.withValues(alpha: 0.1),
        border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: VivumColors.teal, letterSpacing: 1.5)),
    );
  }
}
