import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';

class ParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final List<_Particle> particles;
  final bool isDark;

  ParticlePainter({required this.animation, required this.particles, required this.isDark})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;
    final baseOpacityMultiplier = isDark ? 1.0 : 0.4;

    for (final p in particles) {
      final x = (p.x + p.vx * t * 0.3) % 1.0 * size.width;
      final y = (p.y + p.vy * t * 0.3) % 1.0 * size.height;
      final opacity = (math.sin(t * math.pi * 2 * p.freq + p.phase) * 0.5 + 0.5) * p.maxOpacity * baseOpacityMultiplier;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.blur);

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }

    // Draw connecting lines
    final linePaint = Paint()..strokeWidth = 0.5;
    final lineMaxDist = 120.0;
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final pi = particles[i];
        final pj = particles[j];
        final xi = (pi.x + pi.vx * t * 0.3) % 1.0 * size.width;
        final yi = (pi.y + pi.vy * t * 0.3) % 1.0 * size.height;
        final xj = (pj.x + pj.vx * t * 0.3) % 1.0 * size.width;
        final yj = (pj.y + pj.vy * t * 0.3) % 1.0 * size.height;
        final dist = math.sqrt((xi - xj) * (xi - xj) + (yi - yj) * (yi - yj));
        if (dist < lineMaxDist) {
          final opacity = (1 - dist / lineMaxDist) * 0.08 * baseOpacityMultiplier;
          linePaint.color = VivumColors.teal.withValues(alpha: opacity);
          canvas.drawLine(Offset(xi, yi), Offset(xj, yj), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => true;
}

class _Particle {
  final double x, y, vx, vy, radius, blur, maxOpacity, freq, phase;
  final Color color;

  const _Particle({
    required this.x, required this.y, required this.vx, required this.vy,
    required this.radius, required this.blur, required this.maxOpacity,
    required this.freq, required this.phase, required this.color,
  });
}

List<_Particle> generateParticles(int count, bool isDark) {
  final rng = math.Random(42);
  final colors = [
    VivumColors.teal,
    VivumColors.amber,
    if (isDark) const Color(0xFF2B2D5E) else const Color(0xFFCBD5E1),
    if (isDark) const Color(0xFF3A3D7A) else const Color(0xFF94A3B8),
  ];
  return List.generate(count, (i) => _Particle(
    x: rng.nextDouble(),
    y: rng.nextDouble(),
    vx: (rng.nextDouble() - 0.5) * 0.12,
    vy: (rng.nextDouble() - 0.5) * 0.12,
    radius: rng.nextDouble() * 3 + 1,
    blur: rng.nextDouble() * 4 + 1,
    maxOpacity: rng.nextDouble() * 0.6 + 0.1,
    freq: rng.nextDouble() * 0.5 + 0.2,
    phase: rng.nextDouble() * math.pi * 2,
    color: colors[rng.nextInt(colors.length)],
  ));
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late List<_Particle> _particles;
  bool? _lastIsDark;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDark = AppProvider.of(context).isDark;
    if (_lastIsDark != isDark) {
      _particles = generateParticles(60, isDark);
      _lastIsDark = isDark;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppProvider.of(context).isDark;
    return CustomPaint(
      painter: ParticlePainter(animation: _ctrl, particles: _particles, isDark: isDark),
    );
  }
}

class OrbitPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDark;
  OrbitPainter({required this.animation, required this.isDark}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final t = animation.value * math.pi * 2;
    final ringColor = isDark ? const Color(0xFF2B2D5E) : const Color(0xFFE2E8F0);

    // Outer ring
    _drawRing(canvas, cx, cy, math.min(size.width, size.height) * 0.42,
        ringColor, 1.5, dashLength: 8, gap: 12);

    // Middle ring
    _drawRing(canvas, cx, cy, math.min(size.width, size.height) * 0.30,
        VivumColors.teal.withValues(alpha: 0.3), 1.0, dashLength: 6, gap: 10);

    // Inner ring
    _drawRing(canvas, cx, cy, math.min(size.width, size.height) * 0.18,
        VivumColors.amber.withValues(alpha: 0.2), 0.8);

    // Orbiting teal dot
    final r1 = math.min(size.width, size.height) * 0.42;
    final dot1x = cx + r1 * math.cos(t);
    final dot1y = cy + r1 * math.sin(t);
    _drawGlowDot(canvas, dot1x, dot1y, VivumColors.teal, 6, 12);

    // Orbiting amber dot
    final r2 = math.min(size.width, size.height) * 0.30;
    final dot2x = cx + r2 * math.cos(-t * 1.3 + math.pi / 3);
    final dot2y = cy + r2 * math.sin(-t * 1.3 + math.pi / 3);
    _drawGlowDot(canvas, dot2x, dot2y, VivumColors.amber, 5, 10);

    // Center core
    _drawGlowDot(canvas, cx, cy, VivumColors.teal.withValues(alpha: 0.6), 8, 30);

    // Radial lines
    for (int i = 0; i < 8; i++) {
      final angle = t + (i * math.pi * 2 / 8);
      final innerR = math.min(size.width, size.height) * 0.05;
      final outerR = math.min(size.width, size.height) * 0.15;
      final paint = Paint()
        ..color = VivumColors.teal.withValues(alpha: 0.08)
        ..strokeWidth = 0.8;
      canvas.drawLine(
        Offset(cx + innerR * math.cos(angle), cy + innerR * math.sin(angle)),
        Offset(cx + outerR * math.cos(angle), cy + outerR * math.sin(angle)),
        paint,
      );
    }
  }

  void _drawRing(Canvas canvas, double cx, double cy, double r, Color color, double width,
      {double? dashLength, double? gap}) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    if (dashLength != null && gap != null) {
      _drawDashedCircle(canvas, cx, cy, r, paint, dashLength, gap);
    } else {
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  void _drawDashedCircle(Canvas canvas, double cx, double cy, double r,
      Paint paint, double dashLength, double gap) {
    final actualDash = dashLength * math.pi * 2 / (2 * math.pi * r);
    final totalSteps = (2 * math.pi * r / (dashLength + gap)).round();
    final path = Path();
    for (int i = 0; i < totalSteps; i++) {
      final startAngle = i * (2 * math.pi / totalSteps);
      path.addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r), startAngle, actualDash);
    }
    canvas.drawPath(path, paint);
  }

  void _drawGlowDot(Canvas canvas, double x, double y, Color color, double r, double blur) {
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    canvas.drawCircle(Offset(x, y), r * 2, glowPaint);
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(Offset(x, y), r, dotPaint);
  }

  @override
  bool shouldRepaint(OrbitPainter old) => old.isDark != isDark;
}

class HeroOrbit extends StatefulWidget {
  const HeroOrbit({super.key});
  @override
  State<HeroOrbit> createState() => _HeroOrbitState();
}

class _HeroOrbitState extends State<HeroOrbit> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final isDark = AppProvider.of(context).isDark;
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: OrbitPainter(animation: _ctrl, isDark: isDark),
      ),
    );
  }
}
