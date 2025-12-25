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

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static DateTime _toDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString()) ?? DateTime.now();
  }

  factory Run.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Run(
      id: doc.id,
      title: data['title'] ?? '',
      notes: data['notes'] ?? '',
      distance: _toDouble(data['distance']),
      duration: _toInt(data['duration']),
      createdAt: _toDate(data['createdAt']),
      updatedAt: _toDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'notes': notes,
      'distance': distance,
      'duration': duration,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Run copyWith({
    String? title,
    String? notes,
    double? distance,
    int? duration,
  }) {
    return Run(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
