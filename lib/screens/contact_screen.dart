import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/footer.dart';
import '../widgets/section_reveal.dart';
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
  final _companyCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _service = 'Brand Identity';
  bool _submitted = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _companyCtrl.dispose(); _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() { _loading = false; _submitted = true; });
  }

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);

    return CustomScrollView(
      primary: true,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 24, vertical: isWide ? 100 : 60),
                decoration: BoxDecoration(
                  gradient: VivumColors.heroGradient(lp.isDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('GET IN TOUCH'),
                    const SizedBox(height: 20),
                    Text(lp.t('contact.title'),
                        style: theme.textTheme.displayMedium),
                    const SizedBox(height: 16),
                    Text(lp.t('contact.sub'), style: theme.textTheme.bodyLarge),
                  ],
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),

              // Form + Info
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 24, vertical: 80),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 3,
                              child: SectionReveal(
                                  child: _ContactForm(
                                formKey: _formKey,
                                nameCtrl: _nameCtrl,
                                emailCtrl: _emailCtrl,
                                companyCtrl: _companyCtrl,
                                messageCtrl: _messageCtrl,
                                service: _service,
                                onServiceChanged: (v) =>
                                    setState(() => _service = v),
                                onSubmit: _submit,
                                loading: _loading,
                                submitted: _submitted,
                                lp: lp,
                              ))),
                          const SizedBox(width: 48),
                          Expanded(
                              flex: 2,
                              child: SectionReveal(
                                delay: 200.ms,
                                child: _ContactInfo(lp: lp),
                              )),
                        ],
                      )
                    : Column(
                        children: [
                          _ContactForm(
                            formKey: _formKey,
                            nameCtrl: _nameCtrl,
                            emailCtrl: _emailCtrl,
                            companyCtrl: _companyCtrl,
                            messageCtrl: _messageCtrl,
                            service: _service,
                            onServiceChanged: (v) =>
                                setState(() => _service = v),
                            onSubmit: _submit,
                            loading: _loading,
                            submitted: _submitted,
                            lp: lp,
                          ),
                          const SizedBox(height: 40),
                          _ContactInfo(lp: lp),
                        ],
                      ),
              ),
              const SizedBox(height: 40),
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
  final TextEditingController nameCtrl, emailCtrl, companyCtrl, messageCtrl;
  final String service;
  final ValueChanged<String> onServiceChanged;
  final VoidCallback onSubmit;
  final bool loading, submitted;
  final AppProvider lp;

  const _ContactForm({
    required this.formKey, required this.nameCtrl, required this.emailCtrl,
    required this.companyCtrl, required this.messageCtrl, required this.service,
    required this.onServiceChanged, required this.onSubmit,
    required this.loading, required this.submitted, required this.lp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    
    if (submitted) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: VivumColors.teal.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VivumColors.teal.withValues(alpha: 0.1),
                border: Border.all(color: VivumColors.teal.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.check_rounded, color: VivumColors.teal, size: 36),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text('Message Sent!', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Thank you for reaching out. Our team will get back to you within 24 hours.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center),
          ],
        ),
      );
    }

    const services = ['Brand Identity', 'Digital Experience', 'AI & Automation', 'IT Solutions', 'Other'];
    final inputDeco = InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: VivumColors.teal, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      labelStyle: theme.textTheme.bodyMedium,
      hintStyle: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5)),
    );

    return Container(
      padding: EdgeInsets.all(isWide ? 40 : 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send a Message', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 32),
            TextFormField(
              controller: nameCtrl,
              decoration: inputDeco.copyWith(labelText: lp.t('contact.name')),
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailCtrl,
              decoration: inputDeco.copyWith(labelText: lp.t('contact.email')),
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
              validator: (v) => v!.isEmpty || !v.contains('@') ? 'Valid email required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: companyCtrl,
              decoration: inputDeco.copyWith(labelText: lp.t('contact.company')),
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: service,
              decoration: inputDeco.copyWith(labelText: lp.t('contact.service')),
              dropdownColor: theme.colorScheme.surface,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
              items: services.map((s) => DropdownMenuItem(value: s,
                child: Text(s))).toList(),
              onChanged: (v) => onServiceChanged(v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: messageCtrl,
              decoration: inputDeco.copyWith(hintText: lp.t('contact.message')),
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: loading
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: VivumColors.amber.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                      ),
                    )
                  : VivumButton(
                      label: lp.t('contact.send'),
                      onTap: onSubmit,
                      variant: ButtonVariant.amber,
                      icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final AppProvider lp;
  const _ContactInfo({required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // WhatsApp CTA
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withValues(alpha: 0.1),
              border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF25D366).withValues(alpha: 0.2)),
                child: const Icon(Icons.chat_rounded, color: Color(0xFF25D366), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(lp.t('contact.whatsapp'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
                  Text('+971 XX XXX XXXX',
                    style: theme.textTheme.bodySmall),
                ]),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        _InfoCard(icon: Icons.email_outlined, label: 'Email', value: 'info@vivum.agency'),
        const SizedBox(height: 16),
        // Locations
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lp.t('contact.coverage'),
                style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              const _LocationRow(flag: '🇦🇪', name: 'United Arab Emirates'),
              const SizedBox(height: 10),
              const _LocationRow(flag: '🇸🇦', name: 'Saudi Arabia'),
              const SizedBox(height: 10),
              const _LocationRow(flag: '🇸🇾', name: 'Syria'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Social
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Follow Us', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  const _SocialBtn(icon: Icons.link, label: 'LinkedIn', color: Color(0xFF0A66C2)),
                  const _SocialBtn(icon: Icons.camera_alt_outlined, label: 'Instagram', color: Color(0xFFE1306C)),
                  _SocialBtn(icon: Icons.alternate_email_rounded, label: 'Twitter', color: VivumColors.teal),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoCard({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: VivumColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: VivumColors.teal, size: 18)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 1)),
            Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface), overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String flag, name;
  const _LocationRow({required this.flag, required this.name});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(children: [
      Text(flag, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(child: Text(name, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface))),
    ]);
  }
}

class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SocialBtn({required this.icon, required this.label, required this.color});
  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered ? widget.color.withValues(alpha: 0.15) : theme.dividerColor.withValues(alpha: 0.5),
          border: Border.all(color: _hovered ? widget.color.withValues(alpha: 0.4) : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, size: 14, color: _hovered ? widget.color : theme.textTheme.bodySmall?.color),
          const SizedBox(width: 6),
          Text(widget.label, style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12, color: _hovered ? widget.color : theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w500)),
        ]),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: VivumColors.teal.withValues(alpha: 0.08),
        border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600, color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
