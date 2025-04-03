import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/routes.dart';
import 'data/local/employee_db.dart';
import 'data/models/employee_model.dart';
import 'data/repositories/employee_repository.dart';
import 'logic/cubits/employee_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter()); // Now it will work

  // Open Hive box
  await Hive.openBox<Employee>('employees');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeCubit(EmployeeRepository(EmployeeDB())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.employeeList,
      ),
    );
  }
}
