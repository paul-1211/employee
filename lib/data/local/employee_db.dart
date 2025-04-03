import 'package:hive/hive.dart';
import '../models/employee_model.dart';

class EmployeeDB {
  static const String _boxName = "employees";

  /// Open Hive Box
  Future<Box<Employee>> _openBox() async {
    return await Hive.openBox<Employee>(_boxName);
  }

  /// Fetch all employees
  Future<List<Employee>> getAllEmployees() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Insert an employee
  Future<void> insertEmployee(Employee employee) async {
    final box = await _openBox();
    await box.put(employee.id, employee);
  }

  /// Delete an employee by ID
  Future<void> deleteEmployee(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  /// Update an existing employee
  Future<void> updateEmployee(Employee employee) async {
    final box = await _openBox();
    if (box.containsKey(employee.id)) {
      await box.put(employee.id, employee);
    }
  }
}
