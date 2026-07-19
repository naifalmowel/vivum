import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SectionReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset? slideFrom;

  const SectionReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideFrom,
  });

  @override
  State<SectionReveal> createState() => _SectionRevealState();
}

class _SectionRevealState extends State<SectionReveal> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final slide = widget.slideFrom ?? const Offset(0, 40);
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        opacity: _visible ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 700),
          offset: _visible ? Offset.zero : Offset(slide.dx / 400, slide.dy / 400),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

class StaggerReveal extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;

  const StaggerReveal({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 600),
  });

  @override
  State<StaggerReveal> createState() => _StaggerRevealState();
}

class _StaggerRevealState extends State<StaggerReveal> {
  bool _triggered = false;

  @override
  Widget build(BuildContext context) {
    final Key visibilityKey = widget.key ?? UniqueKey();
    return VisibilityDetector(
      key: visibilityKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_triggered) {
          setState(() => _triggered = true);
        }
      },
      child: Column(
        children: [
          for (int i = 0; i < widget.children.length; i++)
            widget.children[i]
                .animate(target: _triggered ? 1.0 : 0.0)
                .fadeIn(duration: widget.itemDuration, delay: widget.staggerDelay * i)
                .slideY(begin: 0.08, duration: widget.itemDuration,
                    delay: widget.staggerDelay * i, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}
