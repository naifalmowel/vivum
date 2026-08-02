import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Optimized version of SectionReveal.
/// Uses simple Fade and faster durations to minimize "scroll jitter".
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
    // We use a simpler animation structure for performance.
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: AnimatedOpacity(
        duration: 500.ms, // Faster duration
        opacity: _visible ? 1.0 : 0.0,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class StaggerReveal extends StatelessWidget {
  final List<Widget> children;
  final Duration staggerDelay;

  const StaggerReveal({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((e) {
        return SectionReveal(
          delay: staggerDelay * e.key,
          child: e.value,
        );
      }).toList(),
    );
  }
}
