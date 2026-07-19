import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/section_reveal.dart';

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
              const _Label('OUR PROCESS'),
              const SizedBox(height: 20),
              Text(lp.t('process.title'), style: theme.textTheme.displayMedium),
              const SizedBox(height: 16),
              Text(lp.t('process.sub'), style: theme.textTheme.bodyLarge),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),

        // Timeline
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
          child: isWide
              ? _WideTimeline(steps: steps, lp: lp)
              : _NarrowTimeline(steps: steps, lp: lp),
        ),

        // Testimonials placeholder
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
          child: Column(
            children: [
              SectionReveal(child: Column(children: [
                const _Label('WHAT CLIENTS SAY'),
                const SizedBox(height: 12),
                Text('Client Testimonials', style: theme.textTheme.headlineLarge),
              ])),
              const SizedBox(height: 48),
              isWide
                  ? Row(
                      children: List.generate(3, (i) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 2 ? 20 : 0),
                          child: SectionReveal(
                            delay: Duration(milliseconds: i * 150),
                            child: const _TestimonialPlaceholder(),
                          ),
                        ),
                      )),
                    )
                  : Column(
                      children: List.generate(3, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: const _TestimonialPlaceholder(),
                      )),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
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
                Expanded(child: isLeft
                    ? _StepCard(step: step, lp: lp)
                    : const SizedBox()),
                // Center connector
                _TimelineCenter(step: step, isLast: e.key == steps.length - 1),
                Expanded(child: !isLeft
                    ? _StepCard(step: step, lp: lp)
                    : const SizedBox()),
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
                style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: step.accent)),
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
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
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
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: step.accent))),
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

class _TestimonialPlaceholder extends StatelessWidget {
  const _TestimonialPlaceholder();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: List.generate(5, (_) =>
            const Padding(padding: EdgeInsets.only(right: 3),
              child: Icon(Icons.star_rounded, color: VivumColors.amber, size: 16)))),
          const SizedBox(height: 16),
          Container(
            height: 12, width: double.infinity,
            decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(6)),
          ),
          const SizedBox(height: 8),
          Container(height: 12, width: 200,
            decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(shape: BoxShape.circle, color: theme.dividerColor)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 10, width: 100,
                decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 6),
              Container(height: 8, width: 70,
                decoration: BoxDecoration(color: theme.dividerColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4))),
            ]),
          ]),
          const SizedBox(height: 16),
          Center(child: Text('Client testimonial coming soon',
            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic))),
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
