import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/particle_painter.dart';
import '../widgets/section_reveal.dart';

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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page Hero
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: isWide ? 400 : 300),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: InternalPageHeaderBg(
                        glowColor: VivumColors.teal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          _Label(lp.t('process.label')),
                          const SizedBox(height: 20),
                          Text(lp.t('process.title'),
                              style: theme.textTheme.displayMedium),
                          const SizedBox(height: 16),
                          Text(lp.t('process.sub'),
                              style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.05),

              // Timeline
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 24, vertical: 80),
                child: isWide
                    ? _WideTimeline(steps: steps, lp: lp)
                    : _NarrowTimeline(steps: steps, lp: lp),
              ),

              // Testimonials with Ticker
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 100),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
                child: Column(
                  children: [
                    SectionReveal(
                        child: Column(children: [
                      _Label(lp.isAr ? 'ماذا يقولون عنا' : 'WHAT THEY SAY'), 
                      const SizedBox(height: 12),
                      Text(lp.isAr ? 'قصص نجاح شركائنا' : 'Client Success Stories',
                          style: theme.textTheme.displaySmall),
                    ])),
                    const SizedBox(height: 80),
                    _TestimonialTicker(lp: lp),
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

class _TestimonialTicker extends StatefulWidget {
  final AppProvider lp;
  const _TestimonialTicker({required this.lp});

  @override
  State<_TestimonialTicker> createState() => _TestimonialTickerState();
}

class _TestimonialTickerState extends State<_TestimonialTicker> {
  late final ScrollController _scrollController;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    if (!_scrollController.hasClients || _isPaused) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    if (currentScroll >= maxScroll - 1) {
      _scrollController.jumpTo(0);
      _startScrolling();
      return;
    }
    
    final remainingDistance = maxScroll - currentScroll;
    final duration = Duration(milliseconds: (remainingDistance * 50).toInt());

    _scrollController.animateTo(
      maxScroll,
      duration: duration,
      curve: Curves.linear,
    ).then((_) {
      if (mounted && !_isPaused) {
        _scrollController.jumpTo(0);
        _startScrolling();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      ('t.1', 't.1.author'), ('t.2', 't.2.author'), ('t.3', 't.3.author'), 
      ('t.4', 't.4.author'), ('t.5', 't.5.author'), ('t.6', 't.6.author')
    ];

    final displayList = [...testimonials, ...testimonials, ...testimonials, ...testimonials];

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isPaused = true);
        _scrollController.jumpTo(_scrollController.offset); 
      },
      onExit: (_) {
        setState(() => _isPaused = false);
        _startScrolling();
      },
      child: GestureDetector(
        onLongPressStart: (_) {
          setState(() => _isPaused = true);
          _scrollController.jumpTo(_scrollController.offset);
        },
        onLongPressEnd: (_) {
          setState(() => _isPaused = false);
          _startScrolling();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification && notification.dragDetails != null) {
              setState(() => _isPaused = true);
            } else if (notification is ScrollEndNotification) {
              if (_isPaused) {
                setState(() => _isPaused = false);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted && !_isPaused) _startScrolling();
                });
              }
            }
            return false;
          },
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
              final t = displayList[index];
              return Container(
                width: 380,
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: List.generate(5, (_) => 
                      const Icon(Icons.star_rounded, color: VivumColors.amber, size: 18))),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Text(
                        widget.lp.t(t.$1),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                          fontSize: 15,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 32, height: 2,
                          color: VivumColors.teal.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.lp.t(t.$2),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: VivumColors.teal,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ));
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
