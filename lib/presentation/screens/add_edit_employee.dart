import 'package:employee/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/employee_model.dart';
import '../../logic/cubits/employee_cubit.dart';
import 'package:uuid/uuid.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeeScreen({super.key, this.employee});

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final uuid = Uuid();
  late TextEditingController _nameController;
  DateTime? _joinDate;
  DateTime? _endDate;
  String? _selectedPosition;

  final List<String> _positions = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _selectedPosition = widget.employee?.position;
    _joinDate = widget.employee?.joinDate ?? DateTime.now();
    _endDate = widget.employee?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _selectJoinDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    DateTime nextTuesday = now.add(Duration(days: (9 - now.weekday) % 7));
    DateTime afterOneWeek = now.add(const Duration(days: 7));

    DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempDate = _joinDate ?? now; // Default to today when adding a new employee

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSameDay(tempDate, now) ? appColor : appColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() => tempDate = now);
                              },
                              child:  Text('Today', style: TextStyle(color:isSameDay(tempDate, now) ? Colors.white:appColor)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSameDay(tempDate, nextMonday) ? appColor : appColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() => tempDate = nextMonday);
                              },
                              child:  Text('Next Monday', style: TextStyle(color:isSameDay(tempDate, nextMonday) ? Colors.white:appColor)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSameDay(tempDate, nextTuesday) ? appColor : appColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() => tempDate = nextTuesday);
                              },
                              child:  Text('Next Tuesday', style: TextStyle(color:isSameDay(tempDate, nextTuesday)? Colors.white:appColor)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSameDay(tempDate, afterOneWeek) ? appColor : appColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() => tempDate = afterOneWeek);
                              },
                              child:  Text('After 1 Week', style: TextStyle(color:isSameDay(tempDate, afterOneWeek) ? Colors.white:appColor)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: CalendarDatePicker(
                          initialDate: tempDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onDateChanged: (date) {
                            setState(() => tempDate = date);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: appColor),
                        Text(
                          DateFormat("d MMM, y").format(tempDate),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, tempDate),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _joinDate = selectedDate;
      });
    }
  }

  // Helper function to compare dates without time component
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _selectEndDate(BuildContext context) async {
    DateTime now = DateTime.now();
  
    DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime? tempDate = _endDate; // Default is "No Date"

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tempDate == null ? appColor : appColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() => tempDate = null);
                              },
                              child: Text('No Date', style: TextStyle(color:tempDate == null ? Colors.white:appColor)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tempDate == now ? appColor : appColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                setState(() => tempDate = now);
                              },
                              child: Text('Today', style: TextStyle(color:tempDate == null ?appColor:Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: CalendarDatePicker(
                          initialDate: tempDate ?? now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onDateChanged: (date) {
                            setState(() => tempDate = date);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: appColor),
                        Text(
                          tempDate == null ? 'No date' : DateFormat("d MMM, y").format(tempDate!),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, tempDate),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    setState(() {
      _endDate = selectedDate;
    });
  }

String _formatDate(DateTime? date) {
  if (date == null) return 'No date'; // Return "No date" when endDate is null
  DateTime now = DateTime.now();
  return (date.year == now.year && date.month == now.month && date.day == now.day)
      ? 'Today'
      : DateFormat("d MMM, y").format(date);
}

  void _showPositionPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: _positions.map((position) {
              return ListTile(
                title: Text(position),
                onTap: () {
                  setState(() {
                    _selectedPosition = position;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: widget.employee?.id ?? uuid.v4().hashCode,
        name: _nameController.text,
        position: _selectedPosition!,
        joinDate: _joinDate!,
        endDate: _endDate,
      );

      if (widget.employee == null) {
        context.read<EmployeeCubit>().addEmployee(employee);
      } else {
        context.read<EmployeeCubit>().updateEmployee(employee);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          widget.employee == null ? 'Add Employee Details' : 'Edit Employee',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          if (widget.employee != null)
          IconButton(
            icon: const Icon(Icons.delete_outline_sharp, color: Colors.white),
            onPressed: () async {
              final bool? confirmDelete = await _showDeleteConfirmationDialog(context);
              if (confirmDelete == true) {
                context.read<EmployeeCubit>().deleteEmployee(widget.employee!.id);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Employee Name',
                  prefixIcon: Icon(Icons.person_2_outlined, color: appColor),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: _showPositionPicker,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: _selectedPosition ?? 'Select role',
                      prefixIcon: Icon(Icons.work_outline, color: appColor),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) => _selectedPosition == null ? 'Please select a position' : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectJoinDate(context),
                    child: Container(
                      width:MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: appColor),
                          Text(_formatDate(_joinDate)),
                        ],
                      ),
                    )
                  ),
                  const Icon(Icons.arrow_forward, color: appColor),
                  GestureDetector(
                    onTap: () => _selectEndDate(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: appColor),
                          Text(_formatDate(_endDate)),                        
                        ],
                      ),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: appColor)),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _saveEmployee,
              style: ElevatedButton.styleFrom(backgroundColor: appColor),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
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