import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/project_widgets.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/footer.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final cached = DatabaseService.getCachedProject(projectId);

    return FutureBuilder<Map<String, dynamic>?>(
      initialData: cached,
      future: cached != null ? Future.value(cached) : DatabaseService.getProjectById(projectId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const _LoadingView();
        }
        final projectMap = snapshot.data;
        if (projectMap == null || projectMap.isEmpty) {
          return const _NotFoundView();
        }
        final p = Project.fromMap(projectMap);
        return _ProjectDetailsView(project: p);
      },
    );
  }
}

// ─── Loading ─────────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48, height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: VivumColors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Not Found ────────────────────────────────────────────────────────────────
class _NotFoundView extends StatelessWidget {
  const _NotFoundView();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VivumColors.teal.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.search_off_rounded, size: 36, color: VivumColors.teal),
            ),
            const SizedBox(height: 24),
            Text('Project not found', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('This project may have been removed or the link is incorrect.',
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => context.go('/portfolio'),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to Portfolio'),
              style: TextButton.styleFrom(foregroundColor: VivumColors.teal),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Main View ────────────────────────────────────────────────────────────────
class _ProjectDetailsView extends StatefulWidget {
  final Project project;
  const _ProjectDetailsView({required this.project});
  @override
  State<_ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<_ProjectDetailsView> {
  int _selectedImageIndex = 0;

  void _handleBack() {
    if (context.canPop()) context.pop();
    else context.go('/portfolio');
  }

  void _openLightbox(int initialIndex) {
    if (widget.project.imageUrls.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => _ImageLightboxModal(
        imageUrls: widget.project.imageUrls,
        initialIndex: initialIndex,
        accentColor: widget.project.accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = AppProvider.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 1000;
    final isMid = size.width > 700;
    final p = widget.project;

    // ─── accent color with smart fallback
    final accent = p.accentColor != Colors.transparent ? p.accentColor : VivumColors.teal;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ══════════════════════════════════════════════
            // HERO: Full-width gradient banner with project title
            // ══════════════════════════════════════════════
            _ProjectHero(
              project: p,
              accent: accent,
              isDark: isDark,
              isWide: isWide,
              onBack: _handleBack,
              lp: lp,
            ),

            // ══════════════════════════════════════════════
            // IMAGE GALLERY
            // ══════════════════════════════════════════════
            if (p.imageUrls.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 80 : isMid ? 40 : 20,
                  vertical: 32,
                ),
                child: _ImageGallery(
                  imageUrls: p.imageUrls,
                  selectedIndex: _selectedImageIndex,
                  accent: accent,
                  isDark: isDark,
                  isWide: isWide,
                  lp: lp,
                  onSelect: (i) => setState(() => _selectedImageIndex = i),
                  onTap: () => _openLightbox(_selectedImageIndex),
                ),
              ),

            // ══════════════════════════════════════════════
            // CASE STUDY CONTENT
            // ══════════════════════════════════════════════
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : isMid ? 40 : 20,
                vertical: 16,
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 62, child: _CaseStudyContent(project: p, accent: accent, lp: lp)),
                        const SizedBox(width: 40),
                        Expanded(flex: 38, child: _ProjectSidebar(project: p, accent: accent, isDark: isDark)),
                      ],
                    )
                  : Column(
                      children: [
                        _ProjectSidebar(project: p, accent: accent, isDark: isDark),
                        const SizedBox(height: 32),
                        _CaseStudyContent(project: p, accent: accent, lp: lp),
                      ],
                    ),
            ),

            const SizedBox(height: 60),
            const VivumFooter(),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────
class _ProjectHero extends StatelessWidget {
  final Project project;
  final Color accent;
  final bool isDark, isWide;
  final VoidCallback onBack;
  final AppProvider lp;
  const _ProjectHero({
    required this.project, required this.accent,
    required this.isDark, required this.isWide,
    required this.onBack, required this.lp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = project;

    // Build gradient from project colors or fallback
    final gradientColors = p.colors.length >= 2
        ? p.colors.map((c) => isDark ? c.withValues(alpha: 0.85) : c.withValues(alpha: 0.9)).toList()
        : [accent.withValues(alpha: 0.8), accent.withValues(alpha: isDark ? 0.4 : 0.6)];

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isWide ? 420 : 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  gradientColors.first.withValues(alpha: 0.25),
                  gradientColors.last.withValues(alpha: 0.08),
                  const Color(0xFF0F1117),
                ]
              : [
                  gradientColors.first.withValues(alpha: 0.15),
                  gradientColors.last.withValues(alpha: 0.05),
                  const Color(0xFFF5F6FA),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Subtle accent glow top-right
          Positioned(
            top: -60, right: -60,
            child: Container(
              width: 280, height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: isDark ? 0.18 : 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Border bottom
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(height: 1, color: theme.dividerColor),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 20,
              vertical: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Back button
                InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.arrow_back_rounded, size: 16, color: theme.colorScheme.onSurface),
                      const SizedBox(width: 6),
                      Text(
                        lp.isAr ? 'رجوع' : 'Back',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                      ),
                    ]),
                  ),
                ),

                const SizedBox(height: 32),

                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    p.category.toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: accent, letterSpacing: 1.4),
                  ),
                ),

                const SizedBox(height: 16),

                // Project Title
                Text(
                  p.title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: isWide ? 44 : 28,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.08),

                const SizedBox(height: 20),

                // Meta badges row
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    if (p.year.isNotEmpty) _HeroBadge(Icons.calendar_today_outlined, p.year, theme),
                    if (p.location.isNotEmpty) _HeroBadge(Icons.location_on_outlined, p.location, theme),
                    if (p.industry.isNotEmpty) _HeroBadge(Icons.business_center_outlined, p.industry, theme),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _HeroBadge(IconData icon, String text, ThemeData theme) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: theme.dividerColor),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: VivumColors.teal),
      const SizedBox(width: 6),
      Text(text, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 12, color: theme.colorScheme.onSurface)),
    ]),
  );
}

// ─── Image Gallery ────────────────────────────────────────────────────────────
class _ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final int selectedIndex;
  final Color accent;
  final bool isDark, isWide;
  final AppProvider lp;
  final void Function(int) onSelect;
  final VoidCallback onTap;

  const _ImageGallery({
    required this.imageUrls, required this.selectedIndex,
    required this.accent, required this.isDark, required this.isWide,
    required this.lp, required this.onSelect, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedIndex = selectedIndex.clamp(0, imageUrls.length - 1);

    return Column(
      children: [
        // Main image
        GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.zoomIn,
            child: Hero(
              tag: 'project_image_$clampedIndex',
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxHeight: isWide ? 560 : 300),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF181B23) : const Color(0xFFF0F1F8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
                      blurRadius: 40,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Image.network(
                        imageUrls[clampedIndex],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        cacheWidth: kIsWeb ? null : 1600,
                        errorBuilder: (c, e, s) => _ImageError(accent: accent),
                      ),
                      // Zoom hint
                      Positioned(
                        bottom: 14, right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.zoom_in_rounded, color: Colors.white70, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              lp.isAr ? 'تكبير' : 'Zoom',
                              style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                      // Image counter
                      if (imageUrls.length > 1)
                        Positioned(
                          bottom: 14, left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${clampedIndex + 1} / ${imageUrls.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Thumbnails
        if (imageUrls.length > 1) ...[
          const SizedBox(height: 14),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, idx) {
                final isSelected = idx == clampedIndex;
                return GestureDetector(
                  onTap: () => onSelect(idx),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    margin: const EdgeInsets.only(right: 10),
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? accent : theme.dividerColor,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 8)]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(
                        imageUrls[idx],
                        fit: BoxFit.cover,
                        cacheWidth: kIsWeb ? null : 300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ImageError extends StatelessWidget {
  final Color accent;
  const _ImageError({required this.accent});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      color: accent.withValues(alpha: 0.08),
      child: Center(
        child: Icon(Icons.broken_image_outlined, size: 40, color: accent.withValues(alpha: 0.4)),
      ),
    );
  }
}

// ─── Case Study Content ───────────────────────────────────────────────────────
class _CaseStudyContent extends StatelessWidget {
  final Project project;
  final Color accent;
  final AppProvider lp;
  const _CaseStudyContent({required this.project, required this.accent, required this.lp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = project;
    final hasChallenge = p.challenge.trim().isNotEmpty;
    final hasSolution = p.solution.trim().isNotEmpty;
    final hasResult = p.result.trim().isNotEmpty;

    if (!hasChallenge && !hasSolution && !hasResult) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasChallenge) ...[
          _ContentBlock(
            label: lp.isAr ? 'التحدي' : 'THE CHALLENGE',
            icon: Icons.flag_outlined,
            accent: VivumColors.amber,
            child: Text(p.challenge, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.85)),
          ),
          const SizedBox(height: 28),
        ],

        if (hasSolution) ...[
          _ContentBlock(
            label: lp.isAr ? 'الحل' : 'OUR SOLUTION',
            icon: Icons.lightbulb_outline_rounded,
            accent: VivumColors.teal,
            child: Text(p.solution, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.85)),
          ),
          const SizedBox(height: 28),
        ],

        if (hasResult) ...[
          // Impact card — highlighted
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.12),
                  accent.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.auto_graph_rounded, size: 16, color: accent),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    lp.isAr ? 'النتيجة والأثر' : 'RESULT & IMPACT',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: accent, letterSpacing: 1.5),
                  ),
                ]),
                const SizedBox(height: 16),
                Text(
                  p.result,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// A clean labeled content block
class _ContentBlock extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final Widget child;
  const _ContentBlock({required this.label, required this.icon, required this.accent, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 3, height: 18,
            decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: accent, letterSpacing: 1.5),
          ),
        ]),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

// ─── Sidebar ──────────────────────────────────────────────────────────────────
class _ProjectSidebar extends StatelessWidget {
  final Project project;
  final Color accent;
  final bool isDark;
  const _ProjectSidebar({required this.project, required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = project;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.06 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent header strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: accent.withValues(alpha: 0.2))),
            ),
            child: Row(children: [
              Icon(Icons.info_outline_rounded, size: 16, color: accent),
              const SizedBox(width: 8),
              Text(
                'PROJECT INFO',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: accent, letterSpacing: 1.5),
              ),
            ]),
          ),

          // Fields
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SidebarRow(label: 'CLIENT', value: p.title, icon: Icons.business_rounded, accent: accent),
                if (p.industry.isNotEmpty)
                  _SidebarRow(label: 'INDUSTRY', value: p.industry, icon: Icons.category_outlined, accent: accent),
                if (p.location.isNotEmpty)
                  _SidebarRow(label: 'LOCATION', value: p.location, icon: Icons.location_on_outlined, accent: accent),
                if (p.year.isNotEmpty)
                  _SidebarRow(label: 'YEAR', value: p.year, icon: Icons.calendar_today_outlined, accent: accent),

                if (p.tech.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Divider(color: theme.dividerColor, height: 1),
                  const SizedBox(height: 20),
                  Text(
                    'STACK & TOOLS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: accent, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: p.tech.map((t) => _TechChip(label: t, accent: accent)).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color accent;
  const _SidebarRow({required this.label, required this.value, required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: accent, letterSpacing: 1.2)),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final Color accent;
  const _TechChip({required this.label, required this.accent});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accent),
      ),
    );
  }
}

// ─── Fullscreen Lightbox ──────────────────────────────────────────────────────
class _ImageLightboxModal extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final Color accentColor;
  const _ImageLightboxModal({required this.imageUrls, required this.initialIndex, required this.accentColor});
  @override
  State<_ImageLightboxModal> createState() => _ImageLightboxModalState();
}

class _ImageLightboxModalState extends State<_ImageLightboxModal> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withValues(alpha: 0.92)),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            itemBuilder: (context, idx) => Center(
              child: InteractiveViewer(
                minScale: 0.7, maxScale: 5.0,
                child: Image.network(
                  widget.imageUrls[idx],
                  fit: BoxFit.contain,
                  cacheWidth: kIsWeb ? null : 1920,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40, right: 24,
            child: IconButton.filled(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, size: 22, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.white24),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 32, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (i) => AnimatedContainer(
                  duration: 200.ms,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentIndex ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _currentIndex ? widget.accentColor : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
              ),
            ),
        ],
      ),
    );
  }
}
