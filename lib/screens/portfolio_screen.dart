import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../l10n/translations.dart';
import '../widgets/section_reveal.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../widgets/footer.dart';
import '../widgets/project_widgets.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});
  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String _filter = 'All';

  static const _fallbackProjects = [
    Project(
      id: 'gulf_sky',
      title: 'Gulf Sky Engineering Consultants',
      industry: 'Engineering',
      location: 'UAE',
      category: 'Web',
      challenge: 'Create a modern online presence reflecting engineering expertise.',
      solution: 'Designed and developed a responsive corporate website.',
      tech: ['Flutter Web', 'Firebase', 'UI/UX'],
      result: 'Established professional digital presence.',
      colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
      accentColor: VivumColors.teal,
      imageUrls: [],
    ),
  ];

  void _showProjectForm([Project? project]) {
    showDialog(
      context: context,
      builder: (c) => _ProjectFormDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lp = AppProvider.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;
    final theme = Theme.of(context);
    final filters = ['All', 'Branding', 'Web', 'App', 'AI'];

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService.getProjectsStream(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final firebaseProjects = (data != null && data.isNotEmpty)
            ? data.map((m) => Project.fromMap(m)).toList()
            : _fallbackProjects;

        final filtered = _filter == 'All'
            ? firebaseProjects
            : firebaseProjects.where((p) => p.category == _filter).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 100),
              decoration: BoxDecoration(gradient: VivumColors.heroGradient(lp.isDark)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _TealLabel('SELECTED WORK'),
                      if (lp.isAdminMode)
                        ElevatedButton.icon(
                          onPressed: () => _showProjectForm(),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add New Project'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VivumColors.teal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(lp.t('portfolio.title'), style: theme.textTheme.displayMedium),
                  const SizedBox(height: 16),
                  Text(lp.t('portfolio.sub'), style: theme.textTheme.bodyLarge),
                ],
              ),
            ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1),

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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24),
              child: isWide
                  ? _buildWideGrid(filtered, lp.isAdminMode)
                  : _buildNarrowList(filtered, lp.isAdminMode),
            ),
            const SizedBox(height: 80),
            const VivumFooter(),
          ],
        );
      }
    );
  }

  Widget _buildWideGrid(List<Project> filtered, bool isAdminMode) {
    return Column(
      children: [
        for (int i = 0; i < filtered.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SectionReveal(child: ProjectCard(project: filtered[i], isAdminMode: isAdminMode, onEdit: () => _showProjectForm(filtered[i])))),
                const SizedBox(width: 24),
                if (i + 1 < filtered.length)
                  Expanded(child: SectionReveal(delay: 150.ms, child: ProjectCard(project: filtered[i + 1], isAdminMode: isAdminMode, onEdit: () => _showProjectForm(filtered[i + 1]))))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNarrowList(List<Project> filtered, bool isAdminMode) {
    return Column(
      children: filtered.map((p) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SectionReveal(child: ProjectCard(project: p, isAdminMode: isAdminMode, onEdit: () => _showProjectForm(p))),
      )).toList(),
    );
  }
}




class _ProjectFormDialog extends StatefulWidget {
  final Project? project;
  const _ProjectFormDialog({this.project});
  @override
  State<_ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<_ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl, _industryCtrl, _locationCtrl, _categoryCtrl, _challengeCtrl, _solutionCtrl, _resultCtrl, _techCtrl;
  final ScrollController _imagesScrollController = ScrollController();
  List<String> _imageUrls = [];
  bool _isSaving = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleCtrl = TextEditingController(text: p?.title);
    _industryCtrl = TextEditingController(text: p?.industry);
    _locationCtrl = TextEditingController(text: p?.location);
    _categoryCtrl = TextEditingController(text: p?.category ?? 'Web');
    _challengeCtrl = TextEditingController(text: p?.challenge);
    _solutionCtrl = TextEditingController(text: p?.solution);
    _resultCtrl = TextEditingController(text: p?.result);
    _techCtrl = TextEditingController(text: p?.tech.join(', '));
    _imageUrls = List.from(p?.imageUrls ?? []);
  }

  void _uploadImages() async {
    setState(() => _isUploading = true);
    final folder = _titleCtrl.text.isEmpty ? 'temp' : _titleCtrl.text.toLowerCase().replaceAll(' ', '_');
    final urls = await StorageService.uploadProjectImages(projectFolderName: folder);
    setState(() {
      _imageUrls.addAll(urls);
      _isUploading = false;
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    String? id = widget.project?.id;
    if (id == null || id.isEmpty) {
      id = _titleCtrl.text.toLowerCase().replaceAll(' ', '_');
    }
    if (id.isEmpty) id = DateTime.now().millisecondsSinceEpoch.toString();

    final projectData = {
      'id': id,
      'title': _titleCtrl.text,
      'industry': _industryCtrl.text,
      'location': _locationCtrl.text,
      'category': _categoryCtrl.text,
      'challenge': _challengeCtrl.text,
      'solution': _solutionCtrl.text,
      'result': _resultCtrl.text,
      'tech': _techCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      'imageUrls': _imageUrls,
      'accentColor': widget.project?.accentColor.toARGB32() ?? VivumColors.teal.toARGB32(),
      'colors': widget.project?.colors.map((c) => c.toARGB32()).toList() ?? [const Color(0xFF0D47A1).toARGB32(), const Color(0xFF1976D2).toARGB32()],
    };

    try {
      await DatabaseService.saveProject(projectData);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _industryCtrl.dispose();
    _locationCtrl.dispose();
    _categoryCtrl.dispose();
    _challengeCtrl.dispose();
    _solutionCtrl.dispose();
    _resultCtrl.dispose();
    _techCtrl.dispose();
    _imagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.project == null ? 'Add New Project' : 'Edit Project', style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 24),
                _buildField(_titleCtrl, 'Title'),
                _buildField(_industryCtrl, 'Industry'),
                _buildField(_locationCtrl, 'Location'),
                _buildField(_categoryCtrl, 'Category (Web, App, AI, Branding)'),
                _buildField(_challengeCtrl, 'Challenge', maxLines: 3),
                _buildField(_solutionCtrl, 'Solution', maxLines: 3),
                _buildField(_resultCtrl, 'Result'),
                _buildField(_techCtrl, 'Tech Tags (comma separated)'),
                const SizedBox(height: 24),
                Text('Images (${_imageUrls.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (_imageUrls.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: Scrollbar(
                      controller: _imagesScrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _imagesScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _imageUrls.length,
                        itemBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(_imageUrls[i], width: 100, height: 100, fit: BoxFit.cover),
                              ),
                              Positioned(
                                right: 0, top: 0,
                                child: IconButton.filled(
                                  onPressed: () => setState(() => _imageUrls.removeAt(i)),
                                  icon: const Icon(Icons.close_rounded, size: 14),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size(24, 24),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isUploading ? null : _uploadImages,
                  icon: _isUploading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add_photo_alternate_rounded),
                  label: const Text('Upload Images to Supabase'),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(backgroundColor: VivumColors.teal, foregroundColor: Colors.white),
                      child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Project'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
    );
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
          duration: 200.ms, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(color: widget.isActive ? VivumColors.teal : (_hovered ? theme.dividerColor : Colors.transparent), border: Border.all(color: widget.isActive ? VivumColors.teal : theme.dividerColor), borderRadius: BorderRadius.circular(24)),
          child: Text(widget.label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: widget.isActive ? Colors.white : theme.textTheme.bodySmall?.color)),
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
      decoration: BoxDecoration(color: VivumColors.teal.withValues(alpha: 0.08), border: Border.all(color: VivumColors.teal.withValues(alpha: 0.2)), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: VivumColors.teal, letterSpacing: 2)),
    );
  }
}
