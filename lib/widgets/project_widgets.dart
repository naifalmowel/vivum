
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../l10n/translations.dart';
import '../theme/app_theme.dart';

class Project {
  final String id,
      title,
      industry,
      location,
      year, // Added year
      category,
      challenge,
      solution,
      result;
  final List<String> tech;
  final List<Color> colors;
  final Color accentColor;
  final List<String> imageUrls;

  const Project({
    required this.id,
    required this.title,
    required this.industry,
    required this.location,
    required this.year,
    required this.category,
    required this.challenge,
    required this.solution,
    required this.tech,
    required this.result,
    required this.colors,
    required this.accentColor,
    this.imageUrls = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'industry': industry,
      'location': location,
      'year': year,
      'category': category,
      'challenge': challenge,
      'solution': solution,
      'result': result,
      'tech': tech,
      'imageUrls': imageUrls,
      'accentColor': accentColor.toARGB32(),
      'colors': colors.map((c) => c.toARGB32()).toList(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    // Ultra-safe color parsing
    Color parseColor(dynamic v, Color fallback) {
      try {
        if (v is int) return Color(v);
        if (v is String) {
          String hex = v.replaceAll('#', '').replaceAll('0x', '');
          if (hex.length == 6) hex = 'FF$hex';
          if (hex.length == 8) return Color(int.parse(hex, radix: 16));
        }
      } catch (e) {
        debugPrint('Vivum: Color parse error: $e');
      }
      return fallback;
    }

    return Project(
      id: (map['id'] ?? map['title']?.toString().toLowerCase().replaceAll(' ', '_') ?? '').toString(),
      title: (map['title'] ?? 'Untitled Project').toString(),
      industry: (map['industry'] ?? '').toString(),
      location: (map['location'] ?? '').toString(),
      year: (map['year'] ?? '').toString(),
      category: (map['category'] ?? 'General').toString(),
      challenge: (map['challenge'] ?? '').toString(),
      solution: (map['solution'] ?? '').toString(),
      result: (map['result'] ?? '').toString(),
      imageUrls: (map['imageUrls'] as List? ?? [])
          .map((e) => e.toString())
          .where((e) => e.startsWith('http'))
          .toList(),
      tech: (map['tech'] as List? ?? [])
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList(),
      accentColor: parseColor(map['accentColor'], VivumColors.teal),
      colors: (map['colors'] as List? ?? [])
          .map((v) => parseColor(v, VivumColors.teal))
          .toList(),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Project project;
  final String? viewLabel;

  const ProjectCard({
    required this.project,
    this.viewLabel,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = AppProvider.of(context);
    final p = widget.project;

    return MouseRegion(
      onEnter: (_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hovered = true);
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hovered = false);
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          final cleanId = p.id.trim();
          if (cleanId.isNotEmpty) {
            Future.microtask(() => context.go('/project/$cleanId'));
          }
        },
        child: AnimatedContainer(
          duration: 500.ms,
          curve: Curves.easeOutQuart,
          transform: Matrix4.translationValues(0, _hovered ? -15.0 : 0, 0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _hovered ? p.accentColor.withValues(alpha: 0.5) : theme.dividerColor.withValues(alpha: 0.5),
              width: _hovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered 
                  ? p.accentColor.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.04),
                blurRadius: _hovered ? 50 : 20,
                offset: Offset(0, _hovered ? 25 : 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                final isSmall = cardConstraints.maxWidth < 400;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Visual Part
                    AspectRatio(
                      aspectRatio: isSmall ? 1.5 : 1.4,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: p.imageUrls.isEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: p.colors.length >= 2 ? p.colors : [VivumColors.teal, VivumColors.amber],
                                      ),
                                    ),
                                  )
                                : PageView.builder(
                                    controller: _pageController,
                                    itemCount: p.imageUrls.length,
                                    onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
                                    itemBuilder: (context, idx) => Image.network(
                                      p.imageUrls[idx],
                                      fit: BoxFit.cover,
                                      cacheWidth: 800,
                                      errorBuilder: (c, e, s) => Container(
                                        color: p.accentColor.withValues(alpha: 0.1),
                                        child: const Icon(Icons.broken_image_outlined, color: Colors.white24),
                                      ),
                                    ),
                                  ),
                          ),
                          // Dynamic Glass Overlay
                          Positioned.fill(
                            child: AnimatedOpacity(
                              duration: 400.ms,
                              opacity: _hovered ? 0.3 : 0.6,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Badges
                          Positioned(
                            top: isSmall ? 12 : 20,
                            left: isSmall ? 12 : 20,
                            child: Row(
                              children: [
                                _SmallBadge(text: p.year),
                                const SizedBox(width: 6),
                                _SmallBadge(text: p.location, icon: Icons.location_on_outlined),
                              ],
                            ),
                          ),
                          //Content
                          Positioned(
                            bottom: isSmall ? 16 : 24,
                            left: isSmall ? 16 : 24,
                            right: isSmall ? 16 : 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.category.toUpperCase(),
                                  style: TextStyle(color: p.accentColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                const SizedBox(height: 4),
                                Text(p.title,
                                  style: TextStyle(color: Colors.white, fontSize: isSmall ? 22 : 26, fontWeight: FontWeight.w900, height: 1.1)),
                              ],
                            ),
                          ),
                          // Hover View Button
                          if (_hovered)
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(lp.t('portfolio.view'), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 16),
                                    ],
                                  ),
                                ).animate().scale(duration: 300.ms, curve: Curves.bounceIn),
                              ),
                            ),
                          // Dots
                          if (p.imageUrls.length > 1)
                            Positioned(
                              bottom: isSmall ? 16 : 24,
                              right: isSmall ? 16 : 24,
                              child: Row(
                                children: List.generate(p.imageUrls.length, (i) => AnimatedContainer(
                                  duration: 300.ms,
                                  width: _currentImageIndex == i ? 16 : 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(left: 4),
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == i ? p.accentColor : Colors.white54,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                )),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Bottom Info Part
                    Expanded( // Use Expanded to take all remaining space and prevent overflow
                      child: Padding(
                        padding: EdgeInsets.all(isSmall ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded( // Internal expanded for text description
                              child: Text(
                                p.challenge,
                                maxLines: isSmall ? 2 : 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12, height: 1.5),
                              ),
                            ),
                            SizedBox(height: isSmall ? 12 : 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: p.tech.take(isSmall ? 2 : 3).map((t) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: p.accentColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: p.accentColor.withValues(alpha: 0.15)),
                                      ),
                                      child: Text('#$t',
                                        style: TextStyle(color: p.accentColor, fontSize: 8, fontWeight: FontWeight.w800)),
                                    )).toList(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedContainer(
                                  duration: 300.ms,
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _hovered ? p.accentColor : theme.dividerColor.withValues(alpha: 0.3),
                                  ),
                                  child: Icon(Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: _hovered ? Colors.white : theme.dividerColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  const _SmallBadge({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 4),
          ],
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );

  }
}

class _InfoRow extends StatefulWidget {
  final String label, value;
  final Color? color;

  const _InfoRow(
      {required this.label, required this.value, required this.color});

  @override
  State<_InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<_InfoRow> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${widget.label}: ',
          style: theme.textTheme.bodySmall
              ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
      Flexible(
          child: Text(widget.value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 13, color: widget.color, height: 1.5))),
    ]);
  }
}

class ShimmerProjectCard extends StatelessWidget {
  const ShimmerProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white10 : Colors.black12;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              color: baseColor,
            ).animate(onPlay: (c) => c.repeat())
             .shimmer(duration: 1.5.seconds, color: baseColor.withValues(alpha: 0.2)),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 12),
                  Container(width: 200, height: 20, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 24),
                  Container(width: double.infinity, height: 40, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
