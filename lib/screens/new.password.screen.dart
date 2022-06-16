import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/email.service.dart';

class NewPasswordScreen extends StatefulWidget {
  final String? code;
  NewPasswordScreen({this.code});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final newPassword = TextEditingController();

  EmailService _emailService = EmailService();

  bool _isLoading = false;

  _setNewPassword(String? code, String? password) async {
    try {
      var _result = await _emailService.resetPassword(code!, password!);
      var result = json.decode(_result.body);
      if (result['error']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 10.0),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            child: Text(
              'Sign in',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, top: 28.0, right: 28.0, bottom: 14.0),
              child: Text('New Password',
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, top: 0.0, right: 40.0, bottom: 14.0),
              child: Text(
                  'Please enter a new password'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 48.0, top: 14.0, right: 48.0, bottom: 10.0),
              child: TextField(
                controller: newPassword,
                obscureText: true,
                decoration: InputDecoration(hintText: '******'),
              ),
            ),
            ButtonTheme(
              minWidth: 320.0,
              height: 45.0,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: appColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(7.0)),
                    primary: appColor),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _setNewPassword(this.widget.code, newPassword.text);
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
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
      )),
    );
  }
}
