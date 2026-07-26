import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUploadScreen extends StatefulWidget {
  const AdminUploadScreen({super.key});

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _folderCtrl = TextEditingController();
  List<String> _urls = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _folderCtrl.dispose();
    super.dispose();
  }

  void _startUpload() async {
    if (_folderCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a folder name (e.g., skyline_project)')),
      );
      return;
    }

    setState(() => _isUploading = true);

    final urls = await StorageService.uploadProjectImages(
      projectFolderName: _folderCtrl.text.trim(),
    );

    setState(() {
      _urls = urls;
      _isUploading = false;
    });

    if (urls.isNotEmpty) {
      final textToCopy = urls.map((u) => "'$u',").join('\n');
      Clipboard.setData(ClipboardData(text: textToCopy));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful! URLs copied to clipboard.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Developer Upload Tool')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Use this tool to upload images to Supabase Storage and get the URLs to paste into portfolio_screen.dart',
              style: GoogleFonts.inter(fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _folderCtrl,
              decoration: const InputDecoration(
                labelText: 'Folder Name (Project ID)',
                hintText: 'e.g. project_sumer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _startUpload,
                icon: _isUploading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.upload_file),
                label: Text(_isUploading ? 'Uploading...' : 'Select & Upload Images'),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Generated URLs (Ready to copy):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _urls.length,
                  itemBuilder: (c, i) => Text("'${_urls[i]}',", style: GoogleFonts.firaCode(fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
