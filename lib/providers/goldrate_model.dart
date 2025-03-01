// TODO Implement this library.import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GoldrateModel {
  final String id;
  final String rate;
  final DateTime? timestamp; // Nullable to handle missing timestamps
  final double? pavan; //

  GoldrateModel({
    required this.id,
    required this.rate,
    this.timestamp, // Nullable timestamp
    this.pavan,
  });

  factory GoldrateModel.fromData(Map<String, dynamic> data) {
    return GoldrateModel(
      id: data['id'] ?? '', // Default to empty string if 'id' is null
      rate: data['rate'] ?? '0.0', // Default to '0.0' if 'rate' is null
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : null, // Handle null timestamp safely
      pavan: (data['pavan'] != null) ? (data['pavan'] as num).toDouble() : null,
    );
  }
}
