import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/screens/verification.code.screen.dart';
import 'package:m_ticket_app/services/email.service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController();

  EmailService _emailService = EmailService();
  bool _isEmailExists = false;
  bool _isInvalid = false;
  bool _isLoading = false;

  _forgotPassword(String email) async {
    try{
      var _result = await _emailService.sendEmail(email);
    var result = json.decode(_result.body);
    print("Mail "+_result.body.toString());
    if (result['result']) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => VerificationCodeScreen()));
    }
    } catch(exception){
      setState(() {
        _isLoading = false;
      });
      return exception.toString();
    }
  }

  bool validateEmail(String value) {
    try {
      RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    } catch (e) {
      return false;
    }
  }

  ifEmailExists(String email) async {
    try {
      var _emailService = EmailService();
      var data = await _emailService.ifEmailExists(email);
      var _result = json.decode(data.body);
      if (_result['result']) {
        setState(() {
          _isEmailExists = false;
        });
      } else {
        setState(() {
          _isEmailExists = true;
        });
      }
      return _result['result'];
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text('', style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.transparent,
        title: InkWell(
          child: Text(
            'Sign in',
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInScreen())),
        ),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(
                Icons.close,
                color: Colors.black,
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
                    left: 28.0, top: 28.0, right: 28.0, bottom: 14.0),
                child: Text('Forgot Password!',
                    style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 0.0, right: 20.0, bottom: 14.0),
                child:
                    Text('Please enter your email to to reset your password',style: TextStyle(fontSize: 18),),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 10.0, right: 28.0, bottom: 5.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text("Email Please",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    onChanged: (value) {
                      if (validateEmail(value)) {
                        setState(() {
                          _isInvalid = false;
                        });
                        ifEmailExists(value);
                      } else {
                        setState(() {
                          _isInvalid = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Please Input Your Email ID",hintStyle: TextStyle(fontSize: 16)
                    )),
              ),
              /*Padding(
                padding: const EdgeInsets.only(
                    left: 48.0, top: 14.0, right: 48.0, bottom: 10.0),
                child: TextField(
                  controller: email,
                  onChanged: (value) {
                    if (validateEmail(value)) {
                      setState(() {
                        _isInvalid = false;
                      });
                      ifEmailExists(value);
                    } else {
                      setState(() {
                        _isInvalid = true;
                      });
                    }
                  },
                  decoration:
                      InputDecoration(hintText: '${getTranslated(context, 'Enter your email address')}'),
                ),
              ),*/
              Visibility(
                visible: _isInvalid,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Invalid email address.',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isEmailExists,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'This email account does not exist',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:ButtonTheme(
                  minWidth: 320.0,
                  height: 45.0,
                  child: SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0)),
                          primary: appColor,
                          backgroundColor: appColor
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        _forgotPassword(email.text);
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(color: Colors.white,fontSize: 20),
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
