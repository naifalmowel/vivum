import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';

/// A modern, high-performance background with mesh grid and soft glows.
/// This uses 0% CPU/GPU overhead compared to active particle simulations.
class VivumBackground extends StatelessWidget {
  final bool isDark;
  final bool isAr;
  const VivumBackground({super.key, required this.isDark, this.isAr = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mesh Grid Pattern
        Positioned.fill(
          child: Opacity(
            opacity: isDark ? 0.05 : 0.03,
            child: CustomPaint(painter: _GridPainter()),
          ),
        ),
        // Large background glows (Static)
        Positioned(
          top: -200,
          right: -100,
          child: _GlowSphere(
            color: VivumColors.teal.withValues(alpha: 0.15),
            size: 600,
          ),
        ),
        Positioned(
          bottom: -150,
          left: -50,
          child: _GlowSphere(
            color: VivumColors.amber.withValues(alpha: 0.1),
            size: 500,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;
    
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _GlowSphere extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowSphere({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

/// A hardware-accelerated version of the Hero Orbit.
/// Uses standard Flutter animation controllers and rotations instead of CustomPainter math.
class HeroOrbit extends StatefulWidget {
  const HeroOrbit({super.key});

  @override
  State<HeroOrbit> createState() => _HeroOrbitState();
}

class _HeroOrbitState extends State<HeroOrbit> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppProvider.of(context).isDark;
    final ringColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Static Rings
            _OrbitRing(size: 0.85, color: ringColor, isDashed: true),
            _OrbitRing(size: 0.6, color: ringColor, isDashed: true),
            _OrbitRing(size: 0.35, color: VivumColors.teal.withValues(alpha: 0.1), isDashed: false),
            
            // Orbiting Dot 1 (Teal)
            RotationTransition(
              turns: _controller,
              child: _OrbitingObject(
                distance: 0.85,
                child: _GlowDot(color: VivumColors.teal, size: 12),
              ),
            ),
            
            // Orbiting Dot 2 (Amber - opposite direction)
            RotationTransition(
              turns: ReverseAnimation(_controller),
              child: _OrbitingObject(
                distance: 0.6,
                child: _GlowDot(color: VivumColors.amber, size: 8),
              ),
            ),
            
            // Center Core
            _GlowDot(color: VivumColors.teal, size: 24, glowSize: 60, opacity: 0.4),
          ],
        ),
      ),
    );
  }
}

class _OrbitRing extends StatelessWidget {
  final double size;
  final Color color;
  final bool isDashed;
  const _OrbitRing({required this.size, required this.color, required this.isDashed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dim = constraints.maxWidth * size;
      return Container(
        width: dim,
        height: dim,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isDashed 
            ? Border.all(color: Colors.transparent) // Dashed border is complex, keep it simple for perf
            : Border.all(color: color, width: 1),
        ),
        child: isDashed ? CustomPaint(painter: _DashedCirclePainter(color: color)) : null,
      );
    });
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    final radius = size.width / 2;
    const dashCount = 24;
    const dashAngle = (2 * math.pi) / dashCount;
    
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        i * dashAngle,
        dashAngle * 0.5,
        false,
        paint,
      );
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _OrbitingObject extends StatelessWidget {
  final double distance;
  final Widget child;
  const _OrbitingObject({required this.distance, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: constraints.maxWidth * distance,
            child: Center(child: child),
          ),
        ],
      );
    });
  }
}

class _GlowDot extends StatelessWidget {
  final Color color;
  final double size;
  final double glowSize;
  final double opacity;
  const _GlowDot({required this.color, required this.size, this.glowSize = 20, this.opacity = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: glowSize,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

// Keeping names compatible with old code but with optimized logic
class ParticleBackground extends StatelessWidget {
  const ParticleBackground({super.key});
  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    return VivumBackground(isAr: lp.isAr, isDark: lp.isDark);
  }
}

// Added alias for compatibility
typedef VivumBackgroundWidget = VivumBackground;
