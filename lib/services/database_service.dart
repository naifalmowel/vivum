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
}
