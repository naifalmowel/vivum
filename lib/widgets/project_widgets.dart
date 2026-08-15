
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
    return Project(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      industry: map['industry'] ?? '',
      location: map['location'] ?? '',
      year: (map['year'] ?? '').toString(),
      category: map['category'] ?? '',
      challenge: map['challenge'] ?? '',
      solution: map['solution'] ?? '',
      result: map['result'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      tech: List<String>.from(map['tech'] ?? []),
      accentColor:
          Color(map['accentColor'] as int? ?? VivumColors.teal.toARGB32()),
      colors:
          (map['colors'] as List? ?? []).map((v) => Color(v as int)).toList(),
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
        if (mounted) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Visual Part with Glass Effect - Use AspectRatio for fixed bounds
                AspectRatio(
                  aspectRatio: 1.4,
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
                        top: 20, left: 20,
                        child: Row(
                          children: [
                            _SmallBadge(text: p.year),
                            const SizedBox(width: 8),
                            _SmallBadge(text: p.location, icon: Icons.location_on_outlined),
                          ],
                        ),
                      ),
                      //Content
                      Positioned(
                        bottom: 24, left: 24, right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.category.toUpperCase(), 
                              style: TextStyle(color: p.accentColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                            const SizedBox(height: 6),
                            Text(p.title, 
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1.1)),
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
                            ).animate().scale(duration: 300.ms, curve: Curves.bounceOut),
                          ),
                        ),
                      // Dots
                      if (p.imageUrls.length > 1)
                        Positioned(
                          bottom: 24, right: 24,
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
                // Bottom Info with Tags
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.challenge, 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.6)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: p.tech.take(3).map((t) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: p.accentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: p.accentColor.withValues(alpha: 0.2)),
                                ),
                                child: Text('#$t', 
                                  style: TextStyle(color: p.accentColor, fontSize: 9, fontWeight: FontWeight.w800)),
                              )).toList(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedContainer(
                            duration: 300.ms,
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _hovered ? p.accentColor : theme.dividerColor.withValues(alpha: 0.3),
                            ),
                            child: Icon(Icons.arrow_forward_rounded, 
                              size: 16, 
                              color: _hovered ? Colors.white : theme.dividerColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
