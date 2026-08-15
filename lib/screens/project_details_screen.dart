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
                  const Icon(Icons.search_off_rounded,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Project not found',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/portfolio'),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back to Portfolio'),
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
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lp = AppProvider.of(context);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;
    final p = widget.project;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
          // Hero / Image Slider
          Stack(
            children: [
              Container(
                height: size.height * 0.75,
                width: double.infinity,
                color: p.accentColor.withValues(alpha: 0.1),
                child: p.imageUrls.isEmpty
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: p.colors.isNotEmpty
                                    ? p.colors
                                    : [VivumColors.teal, VivumColors.amber])),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_library_outlined,
                                  size: 80,
                                  color: Colors.white.withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text(
                                lp.isAr ? 'لا يوجد صور لعرضها' : 'No images to display',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: p.imageUrls.length,
                        onPageChanged: (idx) =>
                            setState(() => _currentIndex = idx),
                        itemBuilder: (context, idx) => Stack(
                          fit: StackFit.expand,
                          children: [
                            // Optimization: Removed BackdropFilter (Blur) as it consumes huge memory/CPU
                            // Instead, use a solid dark overlay or a very low opacity image
                            Container(
                              color: theme.brightness == Brightness.dark 
                                ? Colors.black 
                                : Colors.grey.shade200,
                            ),
                            Opacity(
                              opacity: 0.3,
                              child: Image.network(
                                p.imageUrls[idx],
                                fit: BoxFit.cover,
                                cacheWidth: 200, // Very low res for background
                              ),
                            ),
                            // Main image - fully visible
                            Center(
                              child: Image.network(
                                p.imageUrls[idx],
                                fit: BoxFit.contain,
                                cacheWidth: size.width.toInt() > 1920 ? 1920 : size.width.toInt(),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Slider Controls (Only if more than 1 image)
              if (p.imageUrls.length > 1) ...[
                Positioned(
                  left: 24,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton.filled(
                      onPressed: () => _pageController.previousPage(
                          duration: 400.ms, curve: Curves.easeOutCubic),
                      icon: const Icon(Icons.chevron_left_rounded, size: 32),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.black26),
                    ),
                  ),
                ),
                Positioned(
                  right: 24,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton.filled(
                      onPressed: () => _pageController.nextPage(
                          duration: 400.ms, curve: Curves.easeOutCubic),
                      icon: const Icon(Icons.chevron_right_rounded, size: 32),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.black26),
                    ),
                  ),
                ),
                // Indicators
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        p.imageUrls.length,
                        (index) => AnimatedContainer(
                              duration: 300.ms,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentIndex == index
                                    ? p.accentColor
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                            )),
                  ),
                ),
              ],

              // Back Button
              Positioned(
                top: 40,
                left: 24,
                child: IconButton.filled(
                  onPressed: () => context.go('/portfolio'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        theme.colorScheme.surface.withValues(alpha: 0.8),
                    foregroundColor: theme.colorScheme.onSurface,
                  ),
                ),
              ),

              // Title & Category
              Positioned(
                bottom: 40,
                left: isWide ? 80 : 24,
                right: isWide ? 80 : 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: p.accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.category.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 2),
                      ),
                    ).animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 16),
                    Text(
                      p.title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: isWide ? 64 : 42,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _MainContent(project: p)),
                      const SizedBox(width: 80),
                      Expanded(flex: 3, child: _Sidebar(project: p)),
                    ],
                  )
                : Column(
                    children: [
                      _MainContent(project: p),
                      const SizedBox(height: 60),
                      _Sidebar(project: p),
                    ],
                  ),
          ),

          const SizedBox(height: 100),
          const VivumFooter(),
      ],
    ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(lp.t('portfolio.challenge')),
        const SizedBox(height: 16),
        Text(project.challenge,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.8)),
        const SizedBox(height: 56),
        _SectionTitle(lp.t('portfolio.solution')),
        const SizedBox(height: 16),
        Text(project.solution,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.8)),
        const SizedBox(height: 56),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: project.accentColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: project.accentColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_graph_rounded, color: project.accentColor),
                  const SizedBox(width: 12),
                  const _SectionTitle('THE RESULT'),
                ],
              ),
              const SizedBox(height: 16),
              Text(project.result,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700, color: project.accentColor)),
            ],
          ),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SidebarItem(label: 'CLIENT', value: project.title),
        _SidebarItem(label: 'INDUSTRY', value: project.industry),
        _SidebarItem(label: 'LOCATION', value: project.location),
        const SizedBox(height: 32),
        const Text('TECHNOLOGIES',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.tech
              .map((t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(t,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label, value;
  const _SidebarItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: VivumColors.teal,
                  letterSpacing: 1.5)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: VivumColors.teal,
            letterSpacing: 2));
  }
}
