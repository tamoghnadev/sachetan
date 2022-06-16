import 'dart:async';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/password.protected.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/languages_services.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final String? email;
  SplashScreen({this.email});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  SettingsService _settingsService = SettingsService();
  SharedPreferences? _prefs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getSettingsInfo();

  }

  _getSettingsInfo() async {
    try {
      var _result = await _settingsService.getSettings();
      if (_result.length > 0) {
        _prefs = await SharedPreferences.getInstance();
        var _languagesService = LanguagesService();
        var response =
            await _languagesService.getLanguageValues(_prefs!.getInt('userId'));
        if (response.statusCode == 200) {
          await _prefs!.setInt('userId', _result[0].userId);
          await _prefs!.setString('token', _result[0].localToken);
          await _prefs!.setString('name', _result[0].name);
          await _prefs!.setString('email', _result[0].email);
          if (_result[0].avatar != null) {
            await _prefs!.setString('avatar', _result[0].avatar);
          }
          await _prefs!.setString('type', _result[0].type);
          await _prefs!
              .setInt('passwordSetOrRemove', _result[0].passwordSetOrRemove);

          setState(() {
            _isLoading = false;
          });
          if (_result[0].passwordSetOrRemove > 0) {
            Timer(
              Duration(seconds: 2),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PasswordProtectedScreen(),
                ),
              ),
            );
          } else if (_result[0].passwordSetOrRemove == 0 &&
              _result[0].localToken != '' &&
              _result[0].localToken != null) {
            Timer(
              Duration(seconds: 2),
              () {
                if (_result[0].type == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboardScreen(),
                    ),
                  );
                } else if (_result[0].type == 'employee') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDashboardScreen(),
                    ),
                  );
                } else if (_result[0].type == 'customer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDashboardScreen(),
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
            );
          } else
            Timer(
              Duration(seconds: 2),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              ),
            );
        } else {
          _prefs = await SharedPreferences.getInstance();
          var _languagesService = LanguagesService();
          var response = await _languagesService
              .getLanguageValues(_prefs!.getInt('userId'));
          if (response.statusCode == 200) {
            Timer(
              Duration(seconds: 2),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              ),
            );
          }
        }
      } else {
        _prefs = await SharedPreferences.getInstance();
        var _languagesService = LanguagesService();
        var response =
            await _languagesService.getLanguageValues(_prefs!.getInt('userId'));
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });

          Timer(
            Duration(seconds: 2),
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInScreen(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(image: DecorationImage(
                      image: AssetImage("assets/scrn.jpg"), fit: BoxFit.fill)),
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              /*child: Text(
                                'Think Ticket Based Customer Service, think M-Ticket',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),*/
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
