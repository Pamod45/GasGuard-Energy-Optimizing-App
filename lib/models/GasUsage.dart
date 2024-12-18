import 'package:cloud_firestore/cloud_firestore.dart';

class GasUsage {
  final String username;
  final int cylinderId;
  final double usage;
  final DateTime date; // Store the date as DateTime

  GasUsage({
    required this.username,
    required this.cylinderId,
    required this.usage,
    required this.date,
  });

  // Factory constructor to create a GasUsage instance from a map
  factory GasUsage.fromMap(Map<String, dynamic> data) {
    DateTime parsedDate = DateTime.now(); // Default fallback

    // If date field is a Firestore Timestamp, convert it to DateTime
    if (data['date'] is Timestamp) {
      Timestamp timestamp = data['date'];
      parsedDate = timestamp.toDate(); // Convert Timestamp to DateTime
    }

    return GasUsage(
      username: data['username'] ?? '',
      cylinderId: data['cylinderId'] ?? 0,
      usage: data['usage'] is String
          ? double.tryParse(data['usage']) ?? 0.0
          : (data['usage'] as num).toDouble(),
      date: parsedDate, // Store the DateTime object
    );
  }
}
