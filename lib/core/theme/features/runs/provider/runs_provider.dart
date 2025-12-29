import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/run_model.dart';

class RunProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _runsRef() {
    final uid = _uid;
    if (uid == null) {
      throw Exception('Not authenticated');
    }
    return _db.collection('users').doc(uid).collection('runs');
  }

  Stream<List<Run>> runsStream() {
    final ref = _runsRef();
    return ref.orderBy('createdAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => Run.fromDoc(d)).toList(),
        );
  }

  Future<void> addRun({
    required String title,
    required String notes,
    required double distance,
    required int duration,
  }) async {
    final ref = _runsRef();
    final now = DateTime.now();

    await ref.add({
      'title': title,
      'notes': notes,
      'distance': distance,
      'duration': duration,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  Future<void> deleteRun(String runId) async {
    if (runId.trim().isEmpty) throw Exception('runId');
    final ref = _runsRef();
    await ref.doc(runId).delete();
  }

  Future<void> updateRun({
    required String runId,
    required String title,
    required String notes,
    required double distance,
    required int duration,
  }) async {
    if (runId.trim().isEmpty) throw Exception('runId');
    final ref = _runsRef();
    final now = DateTime.now();

    await ref.doc(runId).update({
      'title': title,
      'notes': notes,
      'distance': distance,
      'duration': duration,
      'updatedAt': Timestamp.fromDate(now),
    });
  }
}
