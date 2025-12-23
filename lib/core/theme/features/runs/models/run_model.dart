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

  factory Run.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Run(
      id: doc.id,
      title: data['title'],
      notes: data['notes'],
      distance: (data['distance'] as num).toDouble(),
      duration: data['duration'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'notes': notes,
      'distance': distance,
      'duration': duration,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Run copyWith({String? id, required DateTime updatedAt, required DateTime createdAt, required String title, required double distance, required int duration, required String notes}) {
    return Run(
      id: id ?? this.id,
      title: title,
      notes: notes,
      distance: distance,
      duration: duration,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
