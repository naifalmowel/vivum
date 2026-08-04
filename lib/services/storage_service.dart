import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class StorageService {
  static final _supabase = Supabase.instance.client;

  /// Returns public URLs for the uploaded files
  static Future<List<String>> uploadProjectImages({
    required String projectFolderName,
  }) async {
    try {
      // 1. Pick Files
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result == null || result.files.isEmpty) return [];

      List<String> uploadedUrls = [];

      for (var file in result.files) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final path = '$projectFolderName/$fileName';

        // 2. Upload to Supabase Bucket 'projects'
        // Make sure you have created a public bucket named 'projects' in Supabase
        if (kIsWeb) {
          await _supabase.storage.from('projects').uploadBinary(
            path,
            file.bytes!,
            fileOptions: const FileOptions(upsert: true),
          );
        } else {
          await _supabase.storage.from('projects').upload(
            path,
            File(file.path!),
            fileOptions: const FileOptions(upsert: true),
          );
        }

        // 3. Get Public URL
        final url = _supabase.storage.from('projects').getPublicUrl(path);
        uploadedUrls.add(url);
      }

      return uploadedUrls;
    } catch (e) {
      debugPrint('Upload error: $e');
      return [];
    }
  }
}
