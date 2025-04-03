import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/employee_model.dart';
import '../../logic/cubits/employee_cubit.dart';
import '../../config/routes.dart';
import '../../core/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _selectedEmployeeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        title: const Text(
          "Employee List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<EmployeeCubit, List<Employee>>(
        builder: (context, employees) {
          if (employees.isEmpty) {
            return _buildNoEmployeesView();
          }

          List<Employee> currentEmployees =
              employees.where((e) => e.endDate == null).toList();
          List<Employee> previousEmployees =
              employees.where((e) => e.endDate != null).toList();

          return ListView(
            children: [
              if (currentEmployees.isNotEmpty)
                _buildEmployeeSection(
                    "Current Employees", currentEmployees),
              if (previousEmployees.isNotEmpty)
                _buildEmployeeSection(
                    "Previous Employees", previousEmployees),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(
              context, AppRoutes.addEditEmployee);
          if (result == true) {
            setState(() {});
          }
        },
        tooltip: 'Add Employee',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNoEmployeesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no-data.png',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            "No employee records found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSection(String title, List<Employee> employees) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionTitle(title),
      ...employees.map((employee) => Column(
            children: [
              _buildDismissibleEmployeeTile(employee),
              const Divider(), // Adds a line separator between employees
            ],
          )),
    ],
  );
}

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: appColor),
      ),
    );
  }

  Widget _buildDismissibleEmployeeTile(Employee employee) {
    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) {
        _deleteEmployee(context, employee);
      },
      child: _buildEmployeeTile(employee),
    );
  }

  Widget _buildEmployeeTile(Employee employee) {
    final dateFormat = DateFormat('d MMM, yyyy');
    String formattedJoinDate = dateFormat.format(employee.joinDate);
    String formattedEndDate =
        employee.endDate != null ? dateFormat.format(employee.endDate!) : '';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmployeeId =
              (_selectedEmployeeId == employee.id) ? null : employee.id;
        });
      },
      child: ListTile(
        title: Text(employee.name,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.position),
            Text(
              "From $formattedJoinDate${formattedEndDate.isNotEmpty ? ' - $formattedEndDate' : ''}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: _selectedEmployeeId == employee.id
            ? IconButton(
                icon: const Icon(Icons.edit, color: appColor),
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.addEditEmployee,
                    arguments: {'employee': employee},
                  );
                  if (result == true) {
                    setState(() {});
                  }
                },
              )
            : null,
      ),
    );
  }

  void _deleteEmployee(BuildContext context, Employee employee) {
    // Remove the employee from the state management
    context.read<EmployeeCubit>().deleteEmployee(employee.id);

    // Show SnackBar with Undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${employee.name} has been deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo deletion by re-adding the employee
            context.read<EmployeeCubit>().addEmployee(employee);
          },
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this employee?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
