import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../services/database_service.dart';
import '../widgets/particle_painter.dart';
import '../widgets/section_reveal.dart';
import '../widgets/glow_button.dart';
import '../widgets/footer.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);

    final steps = [
      _Step('01', Icons.search_rounded, 'process.step1.title', 'process.step1.desc', VivumColors.teal),
      _Step('02', Icons.map_outlined, 'process.step2.title', 'process.step2.desc', VivumColors.amber),
      _Step('03', Icons.brush_outlined, 'process.step3.title', 'process.step3.desc', VivumColors.teal),
      _Step('04', Icons.code_rounded, 'process.step4.title', 'process.step4.desc', VivumColors.amber),
      _Step('05', Icons.rocket_launch_outlined, 'process.step5.title', 'process.step5.desc', VivumColors.teal),
    ];

    return CustomScrollView(
      primary: true,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Page Hero
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: isWide ? 400 : 300),
                child: Stack(
                  children: [
                    Positioned.fill(child: InternalPageHeaderBg(glowColor: VivumColors.teal)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          _Label(lp.t('process.label')),
                          const SizedBox(height: 20),
                          Text(lp.t('process.title'), style: theme.textTheme.displayMedium),
                          const SizedBox(height: 16),
                          Text(lp.t('process.sub'), style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.05),

              // Timeline
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
                child: isWide ? _WideTimeline(steps: steps, lp: lp) : _NarrowTimeline(steps: steps, lp: lp),
              ),

              // Testimonials Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 100),
                decoration: BoxDecoration(color: theme.colorScheme.surface.withValues(alpha: 0.5)),
                child: Column(
                  children: [
                    SectionReveal(
                      child: Column(children: [
                        _Label(lp.isAr ? 'آراء العملاء' : 'TESTIMONIALS'),
                        const SizedBox(height: 12),
                        Text(lp.t('t.title'), style: theme.textTheme.displaySmall),
                      ]),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
                      child: _TestimonialStaticList(lp: lp),
                    ),
                    const SizedBox(height: 80),
                    // Review Form
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
                      child: const _ReviewSubmissionForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: VivumFooter()),
      ],
    );
  }
}

class _TestimonialStaticList extends StatefulWidget {
  final AppProvider lp;
  const _TestimonialStaticList({required this.lp});

  @override
  State<_TestimonialStaticList> createState() => _TestimonialStaticListState();
}

class _TestimonialStaticListState extends State<_TestimonialStaticList> {
  int _displayLimit = 3;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService.getApprovedTestimonials(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(widget.lp.t('t.empty'), style: const TextStyle(color: Colors.grey)));
        }

        final data = snapshot.data!;
        final displayItems = data.take(_displayLimit).toList();

        return Column(
          children: [
            if (isWide) 
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  mainAxisExtent: 240, // Reduced height for a more compact and elegant look
                ),
                itemCount: displayItems.length,
                itemBuilder: (context, index) => _TestimonialCard(t: displayItems[index]),
              )
            else
              Column(
                children: displayItems.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _TestimonialCard(t: t),
                )).toList(),
              ),
            
            if (data.length > _displayLimit) ...[
              const SizedBox(height: 48),
              Center(
                child: VivumButton(
                  label: widget.lp.isAr ? 'مشاهدة المزيد' : 'View More',
                  onTap: () {
                    // Safe state update
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _displayLimit += 3);
                    });
                  },
                  variant: ButtonVariant.amber,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Map<String, dynamic> t;
  const _TestimonialCard({required this.t});

  void _showFullReview(BuildContext context) {
    final theme = Theme.of(context);
    final rating = (t['rating'] ?? 5).toInt();
    
    // Use addPostFrameCallback to avoid MouseTracker/Scheduler conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, 
                  color: i < rating ? VivumColors.amber : theme.dividerColor, size: 24))),
                const SizedBox(height: 32),
                Text(
                  t['text'] ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic, 
                    height: 1.8, 
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Container(width: 40, height: 2, color: VivumColors.teal),
                    const SizedBox(width: 16),
                    Text(t['name'] ?? '', style: theme.textTheme.titleLarge?.copyWith(
                      color: VivumColors.teal, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppProvider.of(context).isAr ? 'إغلاق' : 'Close', 
                      style: const TextStyle(color: VivumColors.amber, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = (t['rating'] ?? 5).toInt();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showFullReview(context),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 30, offset: const Offset(0, 15))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, 
                color: i < rating ? VivumColors.amber : Colors.grey.withValues(alpha: 0.3), size: 18))),
              const SizedBox(height: 20),
              Text(
                t['text'] ?? '', 
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic, height: 1.6, fontSize: 14), 
                maxLines: 4, 
                overflow: TextOverflow.ellipsis
              ),
              const SizedBox(height: 24),
              // No Expanded or Spacer here to prevent "RenderBox was not laid out" on mobile
              Row(
                children: [
                  Container(width: 32, height: 2, color: VivumColors.teal.withValues(alpha: 0.4)),
                  const SizedBox(width: 12),
                  Flexible(child: Text(t['name'] ?? '', style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800, color: VivumColors.teal, fontSize: 13, letterSpacing: 0.5))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSubmissionForm extends StatefulWidget {
  const _ReviewSubmissionForm();
  @override
  State<_ReviewSubmissionForm> createState() => _ReviewSubmissionFormState();
}

class _ReviewSubmissionFormState extends State<_ReviewSubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _textCtrl = TextEditingController();
  int _rating = 5;
  bool _loading = false;
  bool _success = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await DatabaseService.submitReview({'name': _nameCtrl.text, 'text': _textCtrl.text, 'rating': _rating});
      setState(() { _loading = false; _success = true; });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final theme = Theme.of(context);
    if (_success) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(color: VivumColors.teal.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2))),
          child: Column(children: [
            const Icon(Icons.check_circle_outline_rounded, color: VivumColors.teal, size: 48),
            const SizedBox(height: 16),
            Text(lp.t('t.success'), textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
          ]),
        ),
      );
    }
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(32), border: Border.all(color: theme.dividerColor)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lp.t('t.write'), style: theme.textTheme.titleLarge),
              const SizedBox(height: 24),
              TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: lp.t('t.name'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v!.isEmpty ? '?' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _textCtrl, maxLines: 3, decoration: InputDecoration(labelText: lp.t('t.text'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => v!.isEmpty ? '?' : null),
              const SizedBox(height: 16),
              Row(children: [
                Text(lp.t('t.rating'), style: theme.textTheme.bodyMedium),
                const SizedBox(width: 16),
                Row(children: List.generate(5, (i) => IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _rating = i + 1);
                  });
                },
                icon: Icon(i < _rating ? Icons.star_rounded : Icons.star_outline_rounded, color: VivumColors.amber)))),
              ]),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: _loading ? const Center(child: CircularProgressIndicator()) : VivumButton(label: lp.t('t.submit'), onTap: _submit, variant: ButtonVariant.teal)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  final String number, titleKey, descKey;
  final IconData icon;
  final Color accent;
  const _Step(this.number, this.icon, this.titleKey, this.descKey, this.accent);
}

class _WideTimeline extends StatelessWidget {
  final List<_Step> steps;
  final AppProvider lp;
  const _WideTimeline({required this.steps, required this.lp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((e) {
        final isLeft = e.key % 2 == 0;
        final step = e.value;
        return SectionReveal(
          key: ValueKey(step.number),
          delay: Duration(milliseconds: e.key * 150),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: isLeft ? _StepCard(step: step, lp: lp) : const SizedBox()),
                _TimelineCenter(step: step, isLast: e.key == steps.length - 1),
                Expanded(child: !isLeft ? _StepCard(step: step, lp: lp) : const SizedBox()),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TimelineCenter extends StatelessWidget {
  final _Step step;
  final bool isLast;
  const _TimelineCenter({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.accent.withValues(alpha: 0.1),
              border: Border.all(color: step.accent.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Center(
              child: Text(step.number,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: step.accent)),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [step.accent.withValues(alpha: 0.4), step.accent.withValues(alpha: 0.05)],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  final _Step step;
  final AppProvider lp;
  const _StepCard({required this.step, required this.lp});
  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hovered = true);
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hovered = false);
          });
        }
      },
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(
            color: _hovered ? widget.step.accent.withValues(alpha: 0.4) : theme.dividerColor),
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered
              ? [BoxShadow(color: widget.step.accent.withValues(alpha: isDark ? 0.08 : 0.05), blurRadius: 24)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: 250.ms,
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: widget.step.accent.withValues(alpha: _hovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.step.icon, color: widget.step.accent, size: 22),
            ),
            const SizedBox(height: 16),
            Text(widget.lp.t(widget.step.titleKey),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(widget.lp.t(widget.step.descKey),
              style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _NarrowTimeline extends StatelessWidget {
  final List<_Step> steps;
  final AppProvider lp;
  const _NarrowTimeline({required this.steps, required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: steps.asMap().entries.map((e) {
        final step = e.value;
        return SectionReveal(
          key: ValueKey(step.number),
          delay: Duration(milliseconds: e.key * 120),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.accent.withValues(alpha: 0.1),
                    border: Border.all(color: step.accent.withValues(alpha: 0.4)),
                  ),
                  child: Center(child: Text(step.number,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: step.accent))),
                ),
                if (e.key < steps.length - 1)
                  Container(width: 1.5, height: 60,
                    color: step.accent.withValues(alpha: 0.2)),
              ]),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lp.t(step.titleKey),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(lp.t(step.descKey),
                        style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
