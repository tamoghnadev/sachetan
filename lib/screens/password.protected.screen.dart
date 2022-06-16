import 'dart:async';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordProtectedScreen extends StatefulWidget {
  @override
  _PasswordProtectedScreenState createState() =>
      _PasswordProtectedScreenState();
}

class _PasswordProtectedScreenState extends State<PasswordProtectedScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SettingsService _settingsService = SettingsService();
  final _password = TextEditingController();
  bool _hideShow = true;
  bool _isLoading = false;

  int _userId = 0;
  String password = "";

  @override
  void initState() {
    super.initState();
    _getSettingsInfo();
  }

  _getSettingsInfo() async {
    try {
      var _result = await _settingsService.getSettings();
      if (_result.length > 0) {
        setState(() {
          _userId = _result[0].userId;
          password = _result[0].password;
        });
      }
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
      body: Center(
        child: _isLoading == false
            ? Container(
                height: 200.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ButtonTheme(
                                minWidth: 400.0,
                                height: 45.0,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0)),
                                    primary: appColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_userId > 0) {
                                      if (password == _password.text) {
                                        Timer(Duration(seconds: 2), () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerDashboardScreen()));
                                        });
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        Timer(Duration(seconds: 1), () {
                                          _showSnackBar(
                                            Text(
                                              "${getTranslated(context, 'Password does not match')}. ${getTranslated(context, 'Please try again')}",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    '${getTranslated(context, 'Continue')}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
