import 'dart:async';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPasswordScreen extends StatefulWidget {
  @override
  _AppPasswordScreenState createState() => _AppPasswordScreenState();
}

class _AppPasswordScreenState extends State<AppPasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? _prefs;
  SettingsService? _settingService;
  var _settingsService = SettingsService();
  final _password = TextEditingController();

  String setOrRemovePasswordButtonName = 'Set Password';

  bool _hideShow = true;
  bool _hideShowPasswordTextField = false;
  bool _hideShowRemovePasswordButton = false;
  int? _userId = 0;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  _getUserInfo() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        _userId = _prefs!.getInt('userId');
      });
      _settingService = SettingsService();
      var settings = await _settingService!.getSettings();
      if (settings.length > 0) {
        if (settings[0].passwordSetOrRemove > 0) {
          setState(() {
            setOrRemovePasswordButtonName =
                '${getTranslated(context, 'Change Password')}';
            _hideShowPasswordTextField = false;
            _hideShowRemovePasswordButton = true;
          });
        } else {
          setState(() {
            setOrRemovePasswordButtonName =
                '${getTranslated(context, 'Set Password')}';
            _hideShowPasswordTextField = false;
            _hideShowRemovePasswordButton = true;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _updateSettings(String password, int userId) async {
    try {
      int _passwordSetOrRemove = 0;

      if (password.trim() != '') {
        _passwordSetOrRemove = 1;
      }
      return await _settingsService.updateSettings(
          _passwordSetOrRemove, password, userId);
    } catch (e) {
      print(e.toString());
    }
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Center(child: Text('${getTranslated(context, 'App Password')}')),
        leading: InkWell(
          onTap: () async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            if (_prefs.getString('type') == 'admin') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboardScreen(),
                ),
              );
            } else if (_prefs.getString('type') == 'customer') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDashboardScreen(),
                ),
              );
            } else if (_prefs.getString('type') == 'employee') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeDashboardScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              );
            }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              if (_prefs.getString('type') == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardScreen(),
                  ),
                );
              } else if (_prefs.getString('type') == 'customer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDashboardScreen(),
                  ),
                );
              } else if (_prefs.getString('type') == 'employee') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDashboardScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              }
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black12,
                            ),
                            onPressed: () {
                              setState(() {
                                _hideShowPasswordTextField = true;
                              });
                            },
                            child: Text(
                              setOrRemovePasswordButtonName,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        _hideShowRemovePasswordButton == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0)),
                                    primary: Colors.black12,
                                  ),
                                  onPressed: () async {
                                    try {
                                      var result = await _updateSettings(
                                          _password.text.trim(), _userId!);
                                      if (result > 0) {
                                        setState(() {
                                          setOrRemovePasswordButtonName =
                                              '${getTranslated(context, 'Set Password')}';
                                          _hideShowPasswordTextField = false;
                                          _hideShowRemovePasswordButton = false;
                                        });
                                        Timer(Duration(seconds: 1), () {
                                          _showSnackBar(Text(
                                            "${getTranslated(context, 'Password is removed successfully')}!!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),);
                                        });
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: Text(
                                    '${getTranslated(context, 'Remove Password')}',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    _hideShowPasswordTextField == true
                        ? TextFormField(
                            controller: _password,
                            obscureText: _hideShow,
                            decoration: InputDecoration(
                              hintText: '******',
                              labelText:
                                  '${getTranslated(context, 'App Password')}',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _hideShow
                                        ? _hideShow = false
                                        : _hideShow = true;
                                  });
                                },
                                child: Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ButtonTheme(
                        minWidth: 400.0,
                        height: 45.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            primary: appColor,
                          ),
                          onPressed: () async {
                            if (_password.text.trim() != '') {
                              var result = await _updateSettings(
                                  _password.text.trim(), _userId!);
                              if (result > 0) {
                                Timer(Duration(seconds: 1), () {
                                  _showSnackBar(Text(
                                    "${getTranslated(context, 'Settings information updated')}!",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                                });
                              }
                            } else {
                              Timer(Duration(seconds: 1), () {
                                _showSnackBar(Text(
                                  "${getTranslated(context, 'Please give a password')}",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ));
                              });
                            }
                          },
                          child: Text(
                            '${getTranslated(context, 'Submit')}',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
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
