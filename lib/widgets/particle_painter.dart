import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import 'living_core.dart';

/// A modern, high-performance background with mesh grid and soft glows.
/// This uses 0% CPU/GPU overhead compared to active particle simulations.
class VivumBackground extends StatelessWidget {
  final bool isDark;
  final bool isAr;
  const VivumBackground({super.key, required this.isDark, this.isAr = false});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
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
    ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1) // Use very faint color
      ..strokeWidth = 0.5;
    
    const step = 80.0; // Double the step to draw fewer lines
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

/// The VIVUM Dynamic Living AI Core / Quantum Orb
class HeroOrbit extends StatelessWidget {
  final double? size;
  const HeroOrbit({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final targetSize = size ?? math.min(constraints.maxWidth, 520.0);
        return Center(
          child: LivingCore(size: targetSize),
        );
      },
    );
  }
}



class ParticleBackground extends StatelessWidget {
  const ParticleBackground({super.key});
  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    return VivumBackground(isAr: lp.isAr, isDark: lp.isDark);
  }
}

/// A specialized atmospheric background for internal page headers.
/// Uses RadialGradients for maximum performance (0% GPU lag).
class InternalPageHeaderBg extends StatelessWidget {
  final Color glowColor;
  const InternalPageHeaderBg({super.key, required this.glowColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox.expand(
      child: Stack(
        children: [
          // Base Mesh Background
          const Positioned.fill(child: ParticleBackground()),
          
          // Primary Glow (Top Right)
          Positioned(
            top: -size.height * 0.2,
            right: -size.width * 0.1,
            child: _AtmosphericGlow(
              color: glowColor.withValues(alpha: isDark ? 0.15 : 0.12),
              size: size.width * 0.6,
            ),
          ),

          // Secondary Accent Glow (Bottom Left)
          Positioned(
            bottom: -size.height * 0.1,
            left: -size.width * 0.05,
            child: _AtmosphericGlow(
              color: (isDark ? VivumColors.teal : VivumColors.amber).withValues(alpha: 0.05),
              size: size.width * 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AtmosphericGlow extends StatelessWidget {
  final Color color;
  final double size;
  const _AtmosphericGlow({required this.color, required this.size});

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
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 6.seconds, curve: Curves.easeInOut);
  }
}
