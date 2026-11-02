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
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService.getProjectsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(100.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final data = snapshot.data ?? [];
        final projectMap =
            data.firstWhere((m) => m['id'] == projectId, orElse: () => {});

        if (projectMap.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Project not found',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/portfolio');
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back'),
                  ),
                ],
              ),
            ),
          );
        }

        final p = Project.fromMap(projectMap);
        return _ProjectDetailsView(project: p);
      },
    );
  }
}

class _ProjectDetailsView extends StatefulWidget {
  final Project project;
  const _ProjectDetailsView({required this.project});

  @override
  State<_ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<_ProjectDetailsView> {
  int _selectedImageIndex = 0;

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/portfolio');
    }
  }

  void _openLightbox(int initialIndex) {
    if (widget.project.imageUrls.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
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
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;
    final p = widget.project;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Navigation & Back Header Bar
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 80 : 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _handleBack(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_rounded,
                                size: 18, color: theme.colorScheme.onSurface),
                            const SizedBox(width: 8),
                            Text(
                              lp.isAr ? 'الرجوع' : 'Back',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: p.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: p.accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        p.category.toUpperCase(),
                        style: TextStyle(
                          color: p.accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. IMAGE SHOWCASE FIRST (No words above it)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16,
                vertical: 8,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _openLightbox(_selectedImageIndex),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.zoomIn,
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight: isWide ? 580 : 380,
                        ),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xFF12141C)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              p.imageUrls.isEmpty
                                  ? Container(
                                      height: 280,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: p.colors.length >= 2
                                              ? p.colors
                                              : [VivumColors.teal, VivumColors.amber],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.palette_outlined, size: 48, color: Colors.white38),
                                      ),
                                    )
                                  : Image.network(
                                      p.imageUrls[_selectedImageIndex.clamp(0, p.imageUrls.length - 1)],
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      cacheWidth: kIsWeb ? null : 1600,
                                      errorBuilder: (c, e, s) => Container(
                                        height: 280,
                                        color: p.accentColor.withValues(alpha: 0.1),
                                        child: const Icon(Icons.broken_image_outlined, size: 48, color: Colors.white38),
                                      ),
                                    ),
                              if (p.imageUrls.isNotEmpty)
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.75),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          lp.isAr ? 'انقر للتكبير والزوم' : 'Click to zoom',
                                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Thumbnails Carousel (If multiple images)
                  if (p.imageUrls.length > 1) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 75,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: p.imageUrls.length,
                        itemBuilder: (context, idx) {
                          final isSelected = idx == _selectedImageIndex;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedImageIndex = idx),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              margin: const EdgeInsets.only(right: 10),
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? p.accentColor : theme.dividerColor,
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  p.imageUrls[idx],
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
              ),
            ),

            // 3. PROJECT TITLE & DETAILS SECTION (BELOW THE IMAGE)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: isWide ? 46 : 28,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.1),
                  const SizedBox(height: 16),
                  // Metadata Badges Row
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      if (p.year.isNotEmpty) _metaBadge(Icons.calendar_today_outlined, p.year, theme),
                      if (p.location.isNotEmpty) _metaBadge(Icons.location_on_outlined, p.location, theme),
                      if (p.industry.isNotEmpty) _metaBadge(Icons.business_center_outlined, p.industry, theme),
                    ],
                  ),
                ],
              ),
            ),

            // 4. Case Study Details Content (Challenge, Solution, Impact, Tech)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16,
                vertical: 24,
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _MainContent(project: p)),
                        const SizedBox(width: 40),
                        Expanded(flex: 3, child: _Sidebar(project: p)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Sidebar(project: p),
                        const SizedBox(height: 32),
                        _MainContent(project: p),
                      ],
                    ),
            ),

            const VivumFooter(),
          ],
        ),
      ),
    );
  }

  Widget _metaBadge(IconData icon, String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: VivumColors.teal),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fullscreen Interactive Lightbox Modal with Pinch-to-Zoom
class _ImageLightboxModal extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final Color accentColor;

  const _ImageLightboxModal({
    required this.imageUrls,
    required this.initialIndex,
    required this.accentColor,
  });

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
          // Dark Backdrop Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.black.withValues(alpha: 0.88)),
            ),
          ),

          // Main PageView with InteractiveViewer Zoom
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            itemBuilder: (context, idx) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.network(
                    widget.imageUrls[idx],
                    fit: BoxFit.contain,
                    cacheWidth: kIsWeb ? null : 1920,
                  ),
                ),
              );
            },
          ),

          // Top Right Close Button
          Positioned(
            top: 40,
            right: 24,
            child: IconButton.filled(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, size: 24, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white24,
              ),
            ),
          ),

          // Bottom Image Counter
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final Project project;
  const _MainContent({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = AppProvider.of(context);
    final hasChallenge = project.challenge.trim().isNotEmpty;
    final hasSolution = project.solution.trim().isNotEmpty;
    final hasResult = project.result.trim().isNotEmpty;

    if (!hasChallenge && !hasSolution && !hasResult) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasChallenge) ...[
          _SectionHeader(title: lp.t('portfolio.challenge'), icon: Icons.flag_outlined),
          const SizedBox(height: 12),
          Text(
            project.challenge,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.8),
          ),
          const SizedBox(height: 32),
        ],
        if (hasSolution) ...[
          _SectionHeader(title: lp.t('portfolio.solution'), icon: Icons.lightbulb_outline_rounded),
          const SizedBox(height: 12),
          Text(
            project.solution,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.8),
          ),
          const SizedBox(height: 32),
        ],
        if (hasResult) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: project.accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: project.accentColor.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_graph_rounded, color: project.accentColor, size: 22),
                    const SizedBox(width: 10),
                    const Text(
                      'THE RESULT & IMPACT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: VivumColors.teal,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.result,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.6,
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

class _Sidebar extends StatelessWidget {
  final Project project;
  const _Sidebar({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SidebarField(label: 'CLIENT', value: project.title),
          if (project.industry.isNotEmpty) _SidebarField(label: 'INDUSTRY', value: project.industry),
          if (project.location.isNotEmpty) _SidebarField(label: 'LOCATION', value: project.location),
          if (project.year.isNotEmpty) _SidebarField(label: 'YEAR', value: project.year),
          if (project.tech.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'TECHNOLOGIES USED',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: VivumColors.teal,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.tech
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: project.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: project.accentColor.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: project.accentColor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarField extends StatelessWidget {
  final String label, value;
  const _SidebarField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: VivumColors.teal,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: VivumColors.teal),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: VivumColors.teal,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
