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

/// The permanent Hero branding element: Glassmorphic V
class HeroOrbit extends StatelessWidget {
  const HeroOrbit({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        // Reduced ratios for a more compact and balanced look
        final barWidth = size * 0.07; 
        final barHeight = size * 0.58; 

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background soft glow - Slightly more visible for contrast
              _GlowDot(
                color: VivumColors.teal, 
                size: size * 0.25, 
                glowSize: size * 0.7, 
                opacity: isDark ? 0.12 : 0.15
              ),
              
              // Outer decorative ring
              _OrbitRing(
                size: 0.75, 
                color: VivumColors.teal.withValues(alpha: isDark ? 0.1 : 0.15), 
                isDashed: true
              ),

              // The V shape components
              Stack(
                alignment: Alignment.center,
                children: [
                  // Left bar
                  Transform.rotate(
                    angle: -0.42, // Slightly tighter angle
                    child: _GlassBar(
                      width: barWidth, 
                      height: barHeight, 
                      color: VivumColors.teal, 
                      delay: 0.ms,
                      isDark: isDark,
                    ),
                  ),
                  // Right bar
                  Transform.rotate(
                    angle: 0.42,
                    child: _GlassBar(
                      width: barWidth, 
                      height: barHeight, 
                      color: VivumColors.amber, 
                      delay: 400.ms,
                      isDark: isDark,
                    ),
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
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [
            // Significantly higher opacity for better visibility, especially in Light Mode
            color.withValues(alpha: isDark ? 0.6 : 0.8),
            color.withValues(alpha: isDark ? 0.1 : 0.25),
          ],
        ),
        borderRadius: BorderRadius.circular(width / 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.2 : 0.35), 
            blurRadius: width * 2, 
            spreadRadius: 0
          )
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scaleY(begin: 0.95, end: 1.05, duration: 2.seconds, delay: delay, curve: Curves.easeInOut)
     .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: isDark ? 0.2 : 0.35));
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
