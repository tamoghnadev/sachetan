import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/drawer_navigation.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/category.dart';
import 'package:m_ticket_app/screens/create.category.screen.dart';
import 'package:m_ticket_app/services/category.service.dart';

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  var _categoryService = CategoryService();

  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  _getAllCategories() async {
    try {
      var result = await _categoryService.getCategories();
      var categories = json.decode(result.body);
      _categories = [];
      categories.forEach((category) {
        var _category = Category();

        _category.id = category['id'];
        _category.name = category['name'];
        setState(() {
          _categories.add(_category);
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

  Future _deleteCategory(int? categoryId) async {
    try {
      return await _categoryService.deleteCategory(categoryId!);
    } catch (e) {
      return e.toString();
    }
  }

  _showAlertMessage(BuildContext context, Category category) {
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
                        '${getTranslated(context, 'Cancel')}',
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
                            _confirm(context, category, 'Delete',
                                'Are you sure you want to Delete this category?');
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
      BuildContext context, Category category, String action, String message) {
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
                        '${getTranslated(context, 'Cancel')}',
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
                            await _deleteCategory(category.id).then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                              _showSnackBar(
                                Text(
                                  "${getTranslated(context, 'Category is deleted successfully')}!!",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              );

                              _getAllCategories();
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
        title: Text('${getTranslated(context, 'All Categories')}'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCategoryScreen(),
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
                          label: Text('${getTranslated(context, 'Name')}')),
                    ],
                    rows: _categories
                        .map((category) => DataRow(cells: [
                              DataCell(
                                InkWell(
                                  onLongPress: () {
                                    _showAlertMessage(context, category);
                                  },
                                  child: Text(category.name!),
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
