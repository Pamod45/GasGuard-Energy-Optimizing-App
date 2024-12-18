import 'package:intl/intl.dart';

class Cylinder {
  int id; // Mutable property for setting later
  final String name;
  final String type;
  final double weight;
  late final double currentWeight;
  final String startDate;
  late final String renewalDate;

  // Constructor (without `id`)
  Cylinder({
    this.id = -1, // Default value for uninitialized ID
    required this.name,
    required this.type,
    required this.weight,
    required this.currentWeight,
    required this.startDate,
    this.renewalDate = ''
  });

  int getRemainingDays() {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime start;
    if(renewalDate != ''){
      start = dateFormat.parse(renewalDate);
    }else{
      start = dateFormat.parse(startDate);
    }
    DateTime currentDate = DateTime.now();

    print("Start :$start currentDate :$currentDate");

    int daysUsed = currentDate.difference(start).inDays;
    double totalWeightUsed = weight - currentWeight;

    print("Days used :$daysUsed");

    //for default value
    if(daysUsed.toInt() == 0){
      return 30;
    }

    double avgDailyUsage = totalWeightUsed / daysUsed;

    if (avgDailyUsage == 0) {
      print("Error: No usage recorded or zero daily usage.");
      return 30;
    }

    double remainingDays = currentWeight / avgDailyUsage;

    if(remainingDays > 60 ){
      return 60;
    }
    return remainingDays.toInt();
  }

  // Convert a Cylinder object to a Firestore-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'weight': weight,
      'currentWeight': currentWeight,
      'startDate': startDate,
      'renewalDate':renewalDate,
    };
  }

  // Create a Cylinder object from a Firestore Map
  factory Cylinder.fromMap(Map<String, dynamic> map) {
    return Cylinder(
      id: map['id'] ?? -1,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      currentWeight: (map['currentWeight'] as num?)?.toDouble() ?? 0.0,
      startDate: map['startDate'] ?? '',
      renewalDate: map['renewalDate'] ?? ''
    );
  }
}
