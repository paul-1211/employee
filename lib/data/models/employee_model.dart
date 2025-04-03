import 'package:hive/hive.dart';

part 'employee_model.g.dart'; // Required for code generation

@HiveType(typeId: 0) // Unique ID for this model
class Employee {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String position;

  @HiveField(3)
  final DateTime joinDate;

  @HiveField(4)
  final DateTime? endDate;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.joinDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'position': position,
        'joinDate': joinDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      joinDate: DateTime.parse(json['joinDate']),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    );
  }
}
