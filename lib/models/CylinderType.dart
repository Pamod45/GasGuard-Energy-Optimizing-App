class CylinderType {
  final String name;
  final List<dynamic> weights;

  CylinderType({required this.name, required this.weights});

  factory CylinderType.fromFirestore(Map<String, dynamic> data) {
    return CylinderType(
      name: data['name'] as String,
      weights: data['weights'] as List<dynamic>,
    );
  }
}