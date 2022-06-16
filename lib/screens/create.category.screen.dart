import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/category.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/services/category.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  SharedPreferences? _prefs;
  var _name = TextEditingController();
  var _categoryService = CategoryService();
  bool _isLoading = false;

  Future _createCategory(Category category) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      return await _categoryService.createCategory(
          category);
    } catch (e) {
      return e.toString();
    }
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
                      '${getTranslated(context, 'Category Created Successfully')}',
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
                      '${getTranslated(context, 'Could not create category')}!',
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
                      '${getTranslated(context, 'Please log in to create a Category')}',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Center(child: Text('${getTranslated(context, 'Create Category')}')),
        leading: Text(''),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerDashboardScreen()));
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
                          hintText: '${getTranslated(context, 'Write category name')}',
                          labelText: '${getTranslated(context, 'Category Name')}'),
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
                            if (_name.text == '') {
                              setState(() {
                                _isLoading = false;
                              });
                              _showDataValidationMessage(context);
                            } else {
                              var _category = Category();
                              _category.name = _name.text;

                              try {
                                await _createCategory(_category).then((data) {
                                  var _data = json.decode(data.body);
                                  if (_data['id'] != null &&
                                      _data['id'] != '') {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _showSuccessMessage(context);
                                    Timer(Duration(seconds: 3), () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminDashboardScreen()));
                                    });
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
