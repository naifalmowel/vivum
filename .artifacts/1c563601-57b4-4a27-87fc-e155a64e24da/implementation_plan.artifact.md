# Implementation Plan - Performance & Professional Polish

Replace heavy CustomPaint animations with lightweight, modern, and professional alternatives to eliminate lag.

## User Review Required

> [!IMPORTANT]
> - I will **remove the Particle Background** entirely. It will be replaced by a sophisticated "Static Mesh & Glow" design using subtle SVG patterns and radial gradients. This looks very high-end (like modern SaaS landing pages) and costs 0% CPU.
> - I will **refactor the Hero Orbit**. Instead of drawing lines and dots every frame via math, I will use standard Flutter widgets (`Stack`, `Transform.rotate`) which are hardware-accelerated.
> - I will **simplify reveal animations**. Sliding animations during scrolling can cause "jitter". I will switch to fast, clean fades for most components.

## Proposed Changes

### [Widgets]

#### [MODIFY] [particle_painter.dart](file:///C:/Users/eng.naif/Desktop/flutter_vivum/lib/widgets/particle_painter.dart)
- **Delete** `ParticlePainter` and `ParticleBackground`.
- **New** `VivumBackground`: A lightweight widget using `Stack` and `RadialGradient` glows.
- **Refactor** `HeroOrbit`: Use `AnimatedRotation` and `Stack` instead of `CustomPainter`.

#### [MODIFY] [section_reveal.dart](file:///C:/Users/eng.naif/Desktop/flutter_vivum/lib/widgets/section_reveal.dart)
- Simplify the animation to a simple `FadeIn` by default, reducing the "weight" of the slide effect.

### [Screens]

#### [MODIFY] [home_screen.dart](file:///C:/Users/eng.naif/Desktop/flutter_vivum/lib/screens/home_screen.dart)
- Replace `ParticleBackground` with the new `VivumBackground`.
- Reduce the number of `animate()` calls on secondary text/cards to keep the scrolling smooth.

## Verification Plan

### Manual Verification
- Test scrolling on the Home Page. It should be "buttery smooth".
- Verify the new background looks professional and tech-focused.
- Check that the Hero Orbit still looks dynamic but moves without lag.
