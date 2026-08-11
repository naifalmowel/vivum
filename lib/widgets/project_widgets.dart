import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../l10n/translations.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';

class Project {
  final String id,
      title,
      industry,
      location,
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
            // Wrap navigation to avoid MouseTracker assertion issues during build/update
            Future.microtask(() => context.go('/project/$cleanId'));
          }
        },
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: 200.ms,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: 300.ms,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                  color: _hovered
                      ? p.accentColor.withValues(alpha: 0.5)
                      : theme.dividerColor),
              borderRadius: BorderRadius.circular(24),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                          color: p.accentColor.withValues(alpha: 0.15),
                          blurRadius: 40,
                          offset: const Offset(0, 15))
                    ]
                  : [
                      BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 5))
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: Stack(
                      children: [
                        if (p.imageUrls.isEmpty)
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: p.colors.length >= 2
                                        ? p.colors
                                        : [
                                            VivumColors.teal,
                                            VivumColors.amber
                                          ])))
                        else
                          PageView.builder(
                            controller: _pageController,
                            itemCount: p.imageUrls.length,
                            onPageChanged: (idx) =>
                                setState(() => _currentImageIndex = idx),
                            itemBuilder: (context, idx) => Image.network(
                                p.imageUrls[idx],
                                fit: BoxFit.cover,
                                // Memory optimization: cards don't need full resolution
                                cacheWidth: 600,
                              ),
                          ),
                        if (p.imageUrls.length > 1 && _hovered) ...[
                          Positioned(
                            left: 8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: IconButton.filled(
                                onPressed: () => _pageController.previousPage(
                                    duration: 300.ms, curve: Curves.easeInOut),
                                icon: const Icon(Icons.chevron_left_rounded),
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.black26),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: IconButton.filled(
                                onPressed: () => _pageController.nextPage(
                                    duration: 300.ms, curve: Curves.easeInOut),
                                icon: const Icon(Icons.chevron_right_rounded),
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.black26),
                              ),
                            ),
                          ),
                        ],
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (p.imageUrls.length > 1)
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Row(
                              children: List.generate(
                                p.imageUrls.length,
                                (index) => Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? p.accentColor
                                        : Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: p.accentColor.withValues(alpha: 0.2),
                                    border: Border.all(
                                        color: p.accentColor
                                            .withValues(alpha: 0.4)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('${p.industry} • ${p.location}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: p.accentColor,
                                          fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(height: 8),
                                Text(p.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                            label: lp.t('portfolio.challenge'),
                            value: p.challenge,
                            color: theme.textTheme.bodyMedium?.color),
                        const SizedBox(height: 10),
                        _InfoRow(
                            label: lp.t('portfolio.solution'),
                            value: p.solution,
                            color: theme.colorScheme.onSurface),
                        const SizedBox(height: 16),
                        Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: p.tech
                                .map((t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: theme.dividerColor,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(t,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(fontSize: 11))))
                                .toList()),
                        const SizedBox(height: 16),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                                color: p.accentColor.withValues(alpha: 0.08),
                                border: Border.all(
                                    color:
                                        p.accentColor.withValues(alpha: 0.2)),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(children: [
                              Icon(Icons.trending_up_rounded,
                                  size: 14, color: p.accentColor),
                              const SizedBox(width: 8),
                              Flexible(
                                  child: Text(p.result,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: p.accentColor,
                                          fontWeight: FontWeight.w600)))
                            ]))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final Color? color;

  const _InfoRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ',
          style: theme.textTheme.bodySmall
              ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
      Flexible(
          child: Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 13, color: color, height: 1.5))),
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
