import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // In-memory cache for fast instant rendering without network hops
  static List<Map<String, dynamic>>? _cachedProjects;
  static Map<String, dynamic>? _cachedSettings;

  static List<Map<String, dynamic>>? get cachedProjects => _cachedProjects;
  static Map<String, dynamic>? get cachedSettings => _cachedSettings;

  static Map<String, dynamic>? getCachedProject(String id) {
    if (_cachedProjects == null) return null;
    try {
      final match = _cachedProjects!.firstWhere(
        (m) => m['id'] == id,
        orElse: () => {},
      );
      return match.isNotEmpty ? match : null;
    } catch (_) {
      return null;
    }
  }

  // Get single project (checks cache first, fallback to Firestore single doc)
  static Future<Map<String, dynamic>?> getProjectById(String id) async {
    final cached = getCachedProject(id);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    try {
      final doc = await _db.collection('projects').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return doc.data();
      }
    } catch (e) {
      debugPrint('Error fetching project $id: $e');
    }
    return null;
  }

  // Save or Update project
  static Future<void> saveProject(Map<String, dynamic> projectData) async {
    try {
      String? id = projectData['id'];
      if (id == null || id.isEmpty) {
        id = projectData['title'].toString().toLowerCase().replaceAll(' ', '_');
      }
      
      if (id.isEmpty) {
        id = DateTime.now().millisecondsSinceEpoch.toString();
      }

      projectData['id'] = id;
      await _db.collection('projects').doc(id).set(projectData, SetOptions(merge: true));

      if (_cachedProjects != null) {
        final index = _cachedProjects!.indexWhere((p) => p['id'] == id);
        if (index != -1) {
          _cachedProjects![index] = projectData;
        } else {
          _cachedProjects!.add(projectData);
        }
      }
    } catch (e) {
      debugPrint('Error saving project: $e');
      rethrow;
    }
  }

  // Delete project
  static Future<void> deleteProject(String id) async {
    try {
      await _db.collection('projects').doc(id).delete();
      _cachedProjects?.removeWhere((p) => p['id'] == id);
    } catch (e) {
      debugPrint('Error deleting project: $e');
      rethrow;
    }
  }

  // Stream of projects from Firestore with cache update
  static Stream<List<Map<String, dynamic>>> getProjectsStream() {
    return _db.collection('projects').snapshots().map((snapshot) {
      final list = snapshot.docs.map((doc) => doc.data()).toList();
      _cachedProjects = list;
      return list;
    });
  }

  // Save Contact Request
  static Future<void> saveContactRequest(Map<String, dynamic> data) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await _db.collection('contact_requests').doc(id).set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'id': id,
      });
    } catch (e) {
      debugPrint('Error saving contact request: $e');
      rethrow;
    }
  }

  // --- TESTIMONIALS SYSTEM ---

  // Submit a new review (pending by default)
  static Future<void> submitReview(Map<String, dynamic> data) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await _db.collection('testimonials').doc(id).set({
        ...data,
        'id': id,
        'status': 'pending', // Important: must be approved by admin
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error submitting review: $e');
      rethrow;
    }
  }

  // Stream of ONLY approved testimonials for the public site
  static Stream<List<Map<String, dynamic>>> getApprovedTestimonials() {
    return _db
        .collection('testimonials')
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  // --- SETTINGS SYSTEM ---

  // Get contact & social settings with cache
  static Stream<Map<String, dynamic>> getSettingsStream() {
    return _db.collection('settings').doc('contact_info').snapshots().map((doc) {
      if (doc.exists) {
        _cachedSettings = doc.data()!;
        return _cachedSettings!;
      }
      return {};
    });
  }
}
