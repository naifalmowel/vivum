import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/section_reveal.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});
  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String _filter = 'All';

  static const _projects = [
    _Project(
      title: 'Skyline Real Estate',
      industry: 'Real Estate',
      location: 'UAE',
      category: 'Branding',
      challenge: 'Outdated brand failing to attract high-net-worth clients.',
      solution: 'Complete brand identity system with luxury positioning.',
      tech: ['Figma', 'Brand Identity', 'Website'],
      result: '40% increase in premium lead conversions',
      colors: [Color(0xFF1A237E), Color(0xFF283593)],
      accentColor: VivumColors.teal,
    ),
    _Project(
      title: 'Al-Rashid E-commerce',
      industry: 'Retail',
      location: 'Saudi Arabia',
      category: 'Web',
      challenge: 'Zero online presence, all sales through physical stores only.',
      solution: 'Full-stack e-commerce platform with Arabic-first UX.',
      tech: ['Flutter Web', 'Firebase', 'Stripe'],
      result: 'SAR 2M+ in online revenue within 6 months',
      colors: [Color(0xFF4A0E00), Color(0xFF7B1F00)],
      accentColor: VivumColors.amber,
    ),
    _Project(
      title: 'TechHub AI Assistant',
      industry: 'Professional Services',
      location: 'UAE',
      category: 'AI',
      challenge: 'Support team overwhelmed with 500+ daily customer queries.',
      solution: 'Custom AI chatbot with WhatsApp + website integration.',
      tech: ['OpenAI', 'WhatsApp API', 'Node.js'],
      result: '70% reduction in support ticket volume',
      colors: [Color(0xFF0D1B2A), Color(0xFF1B2A3B)],
      accentColor: VivumColors.teal,
    ),
    _Project(
      title: 'Sham Hospitality App',
      industry: 'Hospitality',
      location: 'Syria',
      category: 'App',
      challenge: 'Manual booking system causing lost reservations and revenue.',
      solution: 'Mobile app with real-time booking, loyalty, and notifications.',
      tech: ['Flutter', 'Firebase', 'Google Maps'],
      result: '3x increase in direct bookings',
      colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
      accentColor: VivumColors.amber,
    ),
    _Project(
      title: 'Nova Tech Startup',
      industry: 'Technology',
      location: 'Saudi Arabia',
      category: 'Branding',
      challenge: 'No visual identity for VC funding round pitch.',
      solution: 'Full brand identity: logo, deck, digital assets.',
      tech: ['Figma', 'Adobe CC', 'Motion Design'],
      result: 'Successfully raised Series A funding',
      colors: [Color(0xFF1B0036), Color(0xFF2D0060)],
      accentColor: VivumColors.teal,
    ),
    _Project(
      title: 'AlNoor Engineering Group',
      industry: 'Engineering',
      location: 'UAE',
      category: 'Web',
      challenge: 'Outdated website not reflecting company\'s project portfolio.',
      solution: 'Custom project showcase website with 3D model viewer.',
      tech: ['React', 'Three.js', 'Headless CMS'],
      result: '60% more RFP inquiries through website',
      colors: [Color(0xFF002B36), Color(0xFF00414F)],
      accentColor: VivumColors.amber,
    ),
  ];

  List<_Project> get _filtered => _filter == 'All'
      ? _projects
      : _projects.where((p) => p.category == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);
    final filters = ['All', 'Branding', 'Web', 'App', 'AI'];

    return Column(
      children: [
        // Hero
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
          decoration: BoxDecoration(
            gradient: VivumColors.heroGradient(lp.isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TealLabel('SELECTED WORK'),
              const SizedBox(height: 20),
              Text(lp.t('portfolio.title'),
                style: theme.textTheme.displayMedium),
              const SizedBox(height: 16),
              Text(lp.t('portfolio.sub'),
                style: theme.textTheme.bodyLarge),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),

        // Filters
        Container(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 32),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _FilterChip(
                  label: f, isActive: _filter == f,
                  onTap: () => setState(() => _filter = f),
                ),
              )).toList(),
            ),
          ),
        ),

        // Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
          child: isWide
              ? _buildWideGrid()
              : _buildNarrowList(),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildWideGrid() {
    final filtered = _filtered;
    return Column(
      children: [
        for (int i = 0; i < filtered.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SectionReveal(
                    key: ValueKey('${filtered[i].title}'),
                    child: _ProjectCard(project: filtered[i]),
                  ),
                ),
                if (i + 1 < filtered.length) ...[
                  const SizedBox(width: 24),
                  Expanded(
                    child: SectionReveal(
                      key: ValueKey('${filtered[i + 1].title}'),
                      delay: const Duration(milliseconds: 150),
                      child: _ProjectCard(project: filtered[i + 1]),
                    ),
                  ),
                ] else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNarrowList() {
    return Column(
      children: _filtered.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SectionReveal(
          key: ValueKey(e.value.title),
          child: _ProjectCard(project: e.value),
        ),
      )).toList(),
    );
  }
}

class _Project {
  final String title, industry, location, category, challenge, solution, result;
  final List<String> tech;
  final List<Color> colors;
  final Color accentColor;
  const _Project({
    required this.title, required this.industry, required this.location,
    required this.category, required this.challenge, required this.solution,
    required this.tech, required this.result, required this.colors, required this.accentColor,
  });
}

class _ProjectCard extends StatefulWidget {
  final _Project project;
  const _ProjectCard({required this.project});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 300.ms,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(
            color: _hovered ? p.accentColor.withValues(alpha: 0.5) : theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered
              ? [BoxShadow(color: p.accentColor.withValues(alpha: isDark ? 0.08 : 0.05), blurRadius: 30)]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Container(
                height: 220,
                decoration: BoxDecoration(gradient: LinearGradient(colors: p.colors, begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Stack(children: [
                  Positioned.fill(child: const _GridOverlay()),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: p.accentColor.withValues(alpha: 0.2),
                            border: Border.all(color: p.accentColor.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('${p.industry} • ${p.location}',
                            style: GoogleFonts.inter(fontSize: 11, color: p.accentColor, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 10),
                        Text(p.title, style: GoogleFonts.syne(
                          fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                ]),
              ),
              // Details
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Challenge', value: p.challenge, color: theme.textTheme.bodyMedium?.color),
                    const SizedBox(height: 10),
                    _InfoRow(label: 'Solution', value: p.solution, color: theme.colorScheme.onSurface),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6, runSpacing: 6,
                      children: p.tech.map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(t, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: p.accentColor.withValues(alpha: 0.08),
                        border: Border.all(color: p.accentColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(children: [
                        Icon(Icons.trending_up_rounded, size: 14, color: p.accentColor),
                        const SizedBox(width: 8),
                        Flexible(child: Text(p.result,
                          style: GoogleFonts.inter(fontSize: 13, color: p.accentColor, fontWeight: FontWeight.w600))),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridP());
  }
}

class _GridP extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.04)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 25) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y < size.height; y += 25) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _InfoRow({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
      Flexible(child: Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13, color: color, height: 1.5))),
    ]);
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isActive, required this.onTap});
  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isActive ? VivumColors.teal : (_hovered ? theme.dividerColor : Colors.transparent),
            border: Border.all(
              color: widget.isActive ? VivumColors.teal : theme.dividerColor,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: widget.isActive ? Colors.white : theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ),
    );
  }
}

class _TealLabel extends StatelessWidget {
  final String text;
  const _TealLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: VivumColors.teal.withValues(alpha: 0.08),
        border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600, color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
