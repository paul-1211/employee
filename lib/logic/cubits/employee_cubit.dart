import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee/data/repositories/employee_repository.dart';
import '../../data/models/employee_model.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final EmployeeRepository _repository;

  EmployeeCubit(this._repository) : super([]);

  void loadEmployees() async {
    final employees = await _repository.getEmployees();
    emit(employees);
  }

  void addEmployee(Employee employee) async {
    await _repository.addEmployee(employee);
    loadEmployees(); // Refresh list
  }

  void deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
    loadEmployees(); // Refresh list
  }

  void updateEmployee(Employee employee) {
    _repository.updateEmployee(employee);
    loadEmployees(); // Refresh list
  }
}
