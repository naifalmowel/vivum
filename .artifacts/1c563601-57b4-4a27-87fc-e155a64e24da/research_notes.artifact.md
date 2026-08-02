# Performance Investigation Notes

The user reports "lag" and "heavy movement" throughout the app.

## Potential Bottlenecks Identified

### 1. Debug Mode
Flutter's Debug mode uses a JIT compiler and includes many expensive assertions. Performance is typically 5-10x slower than Release mode. This is likely the primary contributor if the user is running from the IDE.

### 2. Particle Background (`particle_painter.dart`)
- **Expensive Rendering**: 60 particles are drawn per frame with `MaskFilter.blur`. Blurring is computationally expensive on the CPU/GPU.
- **Heavy Math**: The line-drawing logic uses a nested loop `O(n^2)`. With 60 particles, that's ~1,770 iterations every frame.
- **Redundant Calculations**: `math.sqrt` is used inside the inner loop. Calculating the square root is much slower than comparing squared distances.
- **Unnecessary Repaints**: `shouldRepaint` currently always returns `true`.

### 3. Excessive Animations
- **HomeScreen**: Almost every section uses `.animate().fadeIn().slideY()`.
- **VisibilityDetector**: `SectionReveal` uses `VisibilityDetector`, which can add overhead as it tracks scroll positions and widget bounds.

## Recommended Optimizations

### High Impact
- **Optimize Particles**:
    - Reduce particle count from 60 to 40.
    - Switch to squared distance check to remove `math.sqrt`.
    - Remove `MaskFilter.blur` from the particles (or use it only for a few).
    - Limit line connections (e.g., only check the first 20 particles for connections).
- **Control Repaints**: Fix `shouldRepaint` logic in `CustomPainter`s.

### Medium Impact
- **Lazy Loading**: Ensure sections further down the page don't start animating until they are actually visible (already partially done with `VisibilityDetector`, but could be refined).
- **Repaint Boundaries**: Wrap heavy `CustomPaint` widgets in `RepaintBoundary` to prevent them from causing the rest of the screen to repaint.
