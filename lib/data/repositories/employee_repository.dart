import '../local/employee_db.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  final EmployeeDB _db;

  EmployeeRepository(this._db);

  Future<List<Employee>> getEmployees() => _db.getAllEmployees();
  Future<void> addEmployee(Employee employee) => _db.insertEmployee(employee);
  Future<void> updateEmployee(Employee employee) => _db.updateEmployee(employee); // Added update method
  Future<void> deleteEmployee(int id) => _db.deleteEmployee(id);
}
