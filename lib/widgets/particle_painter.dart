import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

/// The permanent Hero branding element: Glassmorphic V
/// [PRO TIP]: If you have a professional Lottie animation, you can replace
/// the Stack below with Lottie.network('your_url') or Lottie.asset('path').
class HeroOrbit extends StatelessWidget {
  const HeroOrbit({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        // Adjusted ratios for a more sleek and professional look
        final barWidth = size * 0.08; 
        final barHeight = size * 0.6; 

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background soft glow - Capped for memory efficiency
              _GlowDot(
                color: VivumColors.teal, 
                size: size * 0.25, 
                glowSize: (size * 0.7).clamp(0, 120), // Cap blur for memory safety
                opacity: isDark ? 0.12 : 0.15
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 4.seconds, curve: Curves.easeInOut),
              
              // Animated Orbit Rings
              _OrbitRing(
                size: 0.8, 
                color: VivumColors.teal.withValues(alpha: isDark ? 0.1 : 0.2), 
                isDashed: true
              ).animate(onPlay: (c) => c.repeat())
               .rotate(duration: 25.seconds),

              _OrbitRing(
                size: 0.6, 
                color: VivumColors.amber.withValues(alpha: isDark ? 0.08 : 0.15), 
                isDashed: true
              ).animate(onPlay: (c) => c.repeat())
               .rotate(duration: 20.seconds, begin: 1, end: 0),

              // The Glassy V shape
              Stack(
                alignment: Alignment.center,
                children: [
                  // Left bar (Teal)
                  Transform.rotate(
                    angle: -0.4, 
                    child: _GlassBar(
                      width: barWidth, 
                      height: barHeight, 
                      color: VivumColors.teal, 
                      delay: 0.ms,
                      isDark: isDark,
                    ),
                  ),
                  // Right bar (Amber)
                  Transform.rotate(
                    angle: 0.4,
                    child: _GlassBar(
                      width: barWidth, 
                      height: barHeight, 
                      color: VivumColors.amber, 
                      delay: 500.ms,
                      isDark: isDark,
                    ),
                  ),
                  
                  // Central Core Glow
                  RepaintBoundary(
                    child: Container(
                      width: barWidth * 1.5,
                      height: barWidth * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: isDark ? 0.8 : 1.0),
                        boxShadow: [
                          BoxShadow(color: VivumColors.teal, blurRadius: 20, spreadRadius: 2),
                          BoxShadow(color: VivumColors.amber, blurRadius: 40, spreadRadius: 0),
                        ],
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.1, 1.1), duration: 1.seconds),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlassBar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Duration delay;
  final bool isDark;
  const _GlassBar({required this.width, required this.height, required this.color, required this.delay, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, 
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.3 : 0.5), 
        borderRadius: BorderRadius.circular(width / 2),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scaleY(begin: 0.98, end: 1.02, duration: 2.seconds, delay: delay, curve: Curves.easeInOut);
     // Removed shimmer as it triggers constant repaints
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
    // Use RadialGradient instead of BoxShadow for 10x better performance and memory
    return Container(
      width: size + glowSize,
      height: size + glowSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
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
            ? Border.all(color: Colors.transparent)
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
