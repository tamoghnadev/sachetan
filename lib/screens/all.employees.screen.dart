import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/drawer_navigation.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/employee.dart';
import 'package:m_ticket_app/screens/create.employee.screen.dart';
import 'package:m_ticket_app/services/employee.service.dart';

class AllEmployeesScreen extends StatefulWidget {
  @override
  _AllEmployeesScreenState createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  var _employeeService = EmployeeService();

  List<Employee> _empoyees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAllEmployees();
  }

  _getAllEmployees() async {
    try {
      var result = await _employeeService.getEmployees();
      var employees = json.decode(result.body);
      _empoyees = [];
      employees.forEach((employee) {
        var _employee = Employee();

        _employee.id = employee['id'];
        _employee.name = employee['name'];
        if (employee['category'] != null)
          _employee.category = employee['category']['name'];
        else
          _employee.category = 'No category selected';
        setState(() {
          _empoyees.add(_employee);
        });
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return e.toString();
    }
  }

  Future _deleteEmployee(int? employeeId) async {
    try {
      return await _employeeService.deleteEmployee(employeeId!);
    } catch (e) {
      return e.toString();
    }
  }

  _showAlertMessage(BuildContext context, Employee employee) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ButtonTheme(
                    minWidth: 20.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '${getTranslated(context, 'Candel')}',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ButtonTheme(
                        minWidth: 20.0,
                        height: 40.0,
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            _confirm(context, employee, 'Delete',
                                'Are you sure you want to Delete this Employee?');
                          },
                          child: Text(
                            '${getTranslated(context, 'Delete')}',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                '${getTranslated(context, 'What do you want to do')}?',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        );
      },
    );
  }

  _confirm(
      BuildContext context, Employee employee, String action, String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    minWidth: 30.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '${getTranslated(context, 'Candel')}',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    minWidth: 40.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          if (action == 'Delete') {
                            await _deleteEmployee(employee.id).then((_) {
                              _showSnackBar(
                                Text(
                                  "${getTranslated(context, 'Employee info deleted successfully')}!!",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              _getAllEmployees();
                            });
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Text(
                        '${getTranslated(context, 'Yes')}',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      _snackBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: true,
        title: Text('${getTranslated(context, 'All Employees')}'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEmployeeScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _isLoading == false
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text(
                        '${getTranslated(context, 'Name')}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                        label: Text(
                          '${getTranslated(context, 'Category')}',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: _empoyees
                        .map((employee) => DataRow(cells: [
                              DataCell(
                                InkWell(
                                  onLongPress: () {
                                    _showAlertMessage(context, employee);
                                  },
                                  child: Text(employee.name!),
                                ),
                              ),
                              DataCell(
                                InkWell(
                                  onLongPress: () {
                                    _showAlertMessage(context, employee);
                                  },
                                  child: Text(employee.category!),
                                ),
                              ),
                            ]))
                        .toList(),
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
