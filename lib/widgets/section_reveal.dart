import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Optimized version of SectionReveal.
/// Uses simple Fade and faster durations to minimize "scroll jitter".
class SectionReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final bool fillHeight;

  const SectionReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.fillHeight = false,
  });

  @override
  State<SectionReveal> createState() => _SectionRevealState();
}

class _SectionRevealState extends State<SectionReveal> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedOpacity(
      duration: 500.ms, 
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOut,
      child: widget.child,
    );

    if (widget.fillHeight) {
      content = Stack(
        fit: StackFit.passthrough,
        children: [
          // Invisible child to define intrinsic size
          Opacity(opacity: 0, child: widget.child),
          // Filling child
          Positioned.fill(child: content),
        ],
      );
    }

    return VisibilityDetector(
      key: widget.key ?? ValueKey(widget.child.hashCode),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.1 && !_visible) {
          // Use addPostFrameCallback to avoid MouseTracker/Layout assertion errors
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _visible = true);
          });
        }
      },
      child: content,
    );
  }
}
