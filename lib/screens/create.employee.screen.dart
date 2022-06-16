import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/employee.dart';
import 'package:m_ticket_app/screens/all.employees.screen.dart';
import 'package:m_ticket_app/services/category.service.dart';
import 'package:m_ticket_app/services/employee.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEmployeeScreen extends StatefulWidget {
  @override
  _CreateEmployeeScreenState createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  SharedPreferences? _prefs;

  DateTime _currentDate = new DateTime.now();

  var _name = TextEditingController();
  var _email = TextEditingController();
  var _cell = TextEditingController();
  var _jd = TextEditingController();

  var _address = TextEditingController();
  List<DropdownMenuItem> _categoryList = [];
  var _employeeService = EmployeeService();
  var _selectedCategory;
  bool _isLoading = false;
  File? _image;
  String showImage = 'assets/user_icon.png';
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? _selDate = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_selDate != null) {
      setState(() {
        _currentDate = _selDate;
      });
    }
  }

  _getCategories() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = CategoryService();
      var result = await _categoryService.getCategories();
      var categories = json.decode(result.body);
      categories.forEach((category) {
        setState(() {
          _categoryList.add(DropdownMenuItem(
            child: Text(category['name']),
            value: category['id'],
          ));
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

  Future _createEmployee(Employee employee) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      return await _employeeService.createEmployee(employee);
    } catch (e) {
      return e.toString();
    }
  }

  /*_chooseImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }*/

  Widget _showImage() {
    if (_image != null) {
      return Image.file(_image!);
    } else {
      return Image.asset(
        showImage,
        width: 100,
        height: 100,
      );
    }
  }

  Future _uploadEmployeePhoto(File imageFile, int employeeId) async {
    _prefs = await SharedPreferences.getInstance();
    return await _employeeService.uploadAvatar(
        imageFile, employeeId);
  }

  _showSuccessMessage(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/success.png'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${getTranslated(context, 'Employee created successful')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, color: appColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showFailedMessage(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/failed.png')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${getTranslated(context, 'There are some problems. Please try again later.')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showNotLoggedInMessage(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/failed.png')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${getTranslated(context, 'Please log in to submit a Ticket')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showDataValidationMessage(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/failed.png')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${getTranslated(context, 'Please fill all the fields and try again')}!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String _formateDate = DateFormat.yMMMd().format(_currentDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Center(child: Text('Create Employee')),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllEmployeesScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(Icons.close),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                          hintText:
                              '${getTranslated(context, 'Write employee name here')}',
                          labelText: '${getTranslated(context, 'Name')}'),
                    ),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText:
                              '${getTranslated(context, 'Write employee email here')}',
                          labelText: '${getTranslated(context, 'Email')}'),
                    ),
                    TextFormField(
                      controller: _cell,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText:
                              '${getTranslated(context, 'Write employee cell here')}',
                          labelText: '${getTranslated(context, 'Cell')}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${getTranslated(context, 'Date Of Joining')}:",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          Container(
                            height: 50,
                            width: 200,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      _selectDate(context);
                                    }),
                                Text(
                                    "${getTranslated(context, 'Date')}: $_formateDate"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    DropdownButtonFormField(
                      value: _selectedCategory,
                      items: _categoryList,
                      hint: Text(
                          '${getTranslated(context, 'Select a category')}'),
                      onChanged: (dynamic value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _address,
                      maxLines: 100,
                      minLines: 3,
                      decoration: InputDecoration(
                          hintText:
                              '${getTranslated(context, 'Write employee address here')}',
                          labelText: '${getTranslated(context, 'Address')}'),
                    ),
                    TextFormField(
                      controller: _jd,
                      maxLines: 100,
                      minLines: 7,
                      decoration: InputDecoration(
                          hintText:
                              '${getTranslated(context, 'Write employee job description here')}',
                          labelText:
                              '${getTranslated(context, 'Job Description')}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: TextButton(
                              onPressed: () {
                                //_chooseImage();
                              },
                              child: GestureDetector(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  child: _showImage(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _prefs = await SharedPreferences.getInstance();
                          int? userId = _prefs!.getInt('userId');

                          if (userId != null) {
                            if (_name.text == '' ||
                                _address.text == '' ||
                                _selectedCategory == '' ||
                                _selectedCategory == null) {
                              setState(() {
                                _isLoading = false;
                              });
                              _showDataValidationMessage(context);
                            } else {
                              var _empoyee = Employee();
                              _empoyee.name = _name.text;
                              _empoyee.email = _email.text;
                              _empoyee.address = _address.text;
                              _empoyee.jod = _formateDate;
                              _empoyee.jd = _jd.text;
                              _empoyee.categoryId =
                                  int.parse(_selectedCategory.toString());

                              try {
                                await _createEmployee(_empoyee).then((data) {
                                  var _data = json.decode(data.body);
                                  if (_data['id'] != null &&
                                      _data['id'] != '') {
                                    if (_image != null) {
                                      _uploadEmployeePhoto(_image!, _data['id'])
                                          .then((_) {});
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _showSuccessMessage(context);
                                    Timer(Duration(seconds: 3), () {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _showFailedMessage(context);
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                _showFailedMessage(context);
                              }
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            _showNotLoggedInMessage(context);
                          }
                        },
                        child: Text(
                          '${getTranslated(context, 'Submit')}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    _isLoading == false
                        ? Container()
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
