import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gano/core/theme/features/auth/provider/auth_provider.dart';
import '../models/run_model.dart';

class RunProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  RunProvider(AuthProvider read);

  Stream<List<Run>> runsStream() {
    return _db
        .collection('runs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => Run.fromFirestore(e)).toList(),
        );
  }

  Future<void> addRun(Run run) async {
    final doc = _db.collection('runs').doc();
    await doc.set(run.toMap());
  }

  Future<void> updateRun(Run run) async {
    await _db.collection('runs').doc(run.id).update({
      'title': run.title,
      'notes': run.notes,
      'distance': run.distance,
      'duration': run.duration,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteRun(String id) async {
    await _db.collection('runs').doc(id).delete();
  }
}
