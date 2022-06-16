import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/user_model.dart';
import 'package:m_ticket_app/screens/forgot.password.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/email.service.dart';
import 'package:m_ticket_app/services/user.service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final cell = TextEditingController();

  var _userService = UserService();
  bool _isEmailExists = false;
  bool _isInvalid = false;
  bool _hideShow = true;
  bool _isLoading = false;

  _createAccount(String name, String cell, String email, String password) async {
    try {
      var _user = UserModel();
      _user.name = name;
      _user.cell = cell;
      _user.email = email;
      _user.password = password;
      final _result = await _userService.createUser(_user);
      print(_result.body.toString());
      if (_result.body != null) {
        final data = json.decode(_result.body);
        if (data['message'] == "Register Successfully Done") {
          setState(() {
            _isLoading = false;
          });
          _showSuccessMessage(context);
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          });
        }
      }
    } catch (e) {
      _showFailedMessage(context);
    }
  }

  _showFailedMessage(BuildContext context) {
    setState(() {
      _isLoading = false;
    });
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
                  child: Image.asset('assets/failed.png'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Wrong information',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    'Account Successfully Created',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool validateEmail(String value) {
    try {
      RegExp regex = new RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
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
          _isEmailExists = true;
        });
      } else {
        setState(() {
          _isEmailExists = false;
        });
      }
      return _result['result'];
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
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
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 28.0, right: 28.0, bottom: 14.0),
                child: Text(
                    'Lets create your account',
                    style:
                        TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 10.0, right: 28.0, bottom: 5.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text("Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 5.0, right: 28.0, bottom: 5.0),
                child:TextField(
                  keyboardType: TextInputType.name,
                    controller: name,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Please Input Your Name",hintStyle: TextStyle(fontSize: 16)
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 10.0, right: 28.0, bottom: 5.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text("Mobile Number",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                    controller: cell,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Please Input Your Mobile Number",hintStyle: TextStyle(fontSize: 16)
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 10.0, right: 28.0, bottom: 5.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text("Email",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 10.0, right: 28.0, bottom: 5.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text("Password",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, top: 14.0, right: 28.0, bottom: 14.0),
                child: TextField(
                  controller: password,
                    obscureText: _hideShow,
                    decoration: InputDecoration(
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Set Your Password",hintStyle: TextStyle(fontSize: 16)
                    )),
              ),
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
                              'Invalid email address',
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
                              'This email account already exist',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please use a different email to sign up',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 2.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: FittedBox(
                            child: Text(
                                'Sign in to your account')),
                      )),
                  Text('|'),
                  Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 4.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgotPasswordScreen()));
                        },
                        child: FittedBox(
                            child: Text(
                                'Forgot your password')),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 65.0, top: 14.0, right: 65.0, bottom: 14.0),
                child: Text(
                  'By signing up you accept the Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
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
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: appColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        if (!_isEmailExists)
                          _createAccount(
                              name.text, cell.text, email.text, password.text);
                      },
                      child: Text(
                        'Sign Up',
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
