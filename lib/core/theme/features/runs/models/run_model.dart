import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  final String id;
  final String title;
  final String notes;
  final double distance;
  final int duration;
  final DateTime createdAt;
  final DateTime updatedAt;

  Run({
    required this.id,
    required this.title,
    required this.notes,
    required this.distance,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'notes': notes,
        'distance': distance,
        'duration': duration,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  factory Run.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    final created = data['createdAt'];
    final updated = data['updatedAt'];

    return Run(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      notes: (data['notes'] ?? '').toString(),
      distance: (data['distance'] is num) ? (data['distance'] as num).toDouble() : 0.0,
      duration: (data['duration'] is num) ? (data['duration'] as num).toInt() : 0,
      createdAt: (created is Timestamp) ? created.toDate() : DateTime.now(),
      updatedAt: (updated is Timestamp) ? updated.toDate() : DateTime.now(),
    );
  }
}
