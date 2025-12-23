import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/run_model.dart';

class RunProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<Run> _runs = [];
  List<Run> get runs => List.unmodifiable(_runs);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  DocumentSnapshot? _lastDoc;

  static const int _pageSize = 10;

  int get totalRuns => _runs.length;

  double get totalDistance => _runs.fold<double>(0, (acc, r) => acc + r.distance);

  // ====== READ (First Page) ======
  Future<void> fetchFirstPage() async {
    _isLoading = true;
    _hasMore = true;
    _lastDoc = null;
    _runs.clear();
    notifyListeners();

    try {
      final query = await _db
          .collection('runs')
          .orderBy('createdAt', descending: true)
          .limit(_pageSize)
          .get();

      if (query.docs.isNotEmpty) {
        _runs.addAll(query.docs.map((d) => Run.fromFirestore(d)));
        _lastDoc = query.docs.last;
      }

      if (query.docs.length < _pageSize) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('❌ fetchFirstPage error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====== READ (Load More) ======
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _lastDoc == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final query = await _db
          .collection('runs')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDoc!)
          .limit(_pageSize)
          .get();

      if (query.docs.isNotEmpty) {
        _runs.addAll(query.docs.map((d) => Run.fromFirestore(d)));
        _lastDoc = query.docs.last;
      }

      if (query.docs.length < _pageSize) {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('❌ loadMore error: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // ====== CREATE ======
  Future<void> addRun(Run run) async {
    try {
      final doc = _db.collection('runs').doc();
      final now = DateTime.now();

      final newRun = run.copyWith(
        id: doc.id,
        title: run.title,
        distance: run.distance,
        duration: run.duration,
        notes: run.notes,
        createdAt: run.createdAt,
        updatedAt: now,
      );

      await doc.set(newRun.toMap());

      // Insert at top (because orderBy createdAt desc)
      _runs.insert(0, newRun);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ addRun error: $e');
    }
  }

  // ====== UPDATE ======
  Future<void> updateRun(Run run) async {
    try {
      final updated = run.copyWith(
        id: run.id,
        title: run.title,
        distance: run.distance,
        duration: run.duration,
        notes: run.notes,
        createdAt: run.createdAt,
        updatedAt: DateTime.now(),
      );
      await _db.collection('runs').doc(updated.id).update(updated.toMap());

      final index = _runs.indexWhere((r) => r.id == updated.id);
      if (index != -1) {
        _runs[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ updateRun error: $e');
    }
  }

  // ====== DELETE ======
  Future<void> deleteRun(String id) async {
    try {
      await _db.collection('runs').doc(id).delete();
      _runs.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ deleteRun error: $e');
    }
  }

  void listenToRuns() {}
}
