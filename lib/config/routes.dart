import 'package:employee/presentation/screens/add_edit_employee.dart';
import 'package:employee/presentation/screens/home.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String employeeList = '/';
  static const String addEditEmployee = '/add_edit_employee';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case employeeList:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );

      case addEditEmployee:
        final args = settings.arguments as Map<String, dynamic>?; // Pass employee data
        return MaterialPageRoute(
          builder: (_) => AddEditEmployeeScreen(employee: args?['employee']),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
