import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/screens/new.password.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/email.service.dart';

class VerificationCodeScreen extends StatefulWidget {
  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final verificationCode = TextEditingController();
  EmailService _emailService = EmailService();
  bool _isLoading = false;

  _confirmVerificationCode(String code) async {
    try {
      var _result = await _emailService.verifyCode(code);
      var result = json.decode(_result.body);
      if (result['result']) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPasswordScreen(
                    code: result['data']['verification_code'])));
      }
    } catch (exception) {
      return exception.toString();
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, top: 28.0, right: 28.0, bottom: 14.0),
                child: Text('Verification Code',
                    style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 55.0, top: 0.0, right: 50.0, bottom: 14.0),
                child: Center(
                    child: Text(
                        'Check your email address and enter the verification code that we sent you')),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 48.0, top: 5.0, right: 48.0, bottom: 5.0),
                child:TextField(
                    controller: verificationCode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Please Input Your Verification Code",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ButtonTheme(
                  minWidth: 320.0,
                  height: 45.0,
                  child: SizedBox(
                    width: 200.0,
                    height: 50.0,
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
                        _confirmVerificationCode(verificationCode.text);
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
    );
  }
}
