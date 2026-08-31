import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    } catch (e) {
      debugPrint('Error saving project: $e');
      rethrow;
    }
  }

  // Delete project
  static Future<void> deleteProject(String id) async {
    try {
      await _db.collection('projects').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting project: $e');
      rethrow;
    }
  }

  // Stream of projects from Firestore
  static Stream<List<Map<String, dynamic>>> getProjectsStream() {
    return _db.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
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

  // Get contact & social settings
  static Stream<Map<String, dynamic>> getSettingsStream() {
    return _db.collection('settings').doc('contact_info').snapshots().map((doc) {
      if (doc.exists) return doc.data()!;
      return {};
    });
  }
}
