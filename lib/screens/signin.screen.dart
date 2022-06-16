import 'dart:convert';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/settings.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/create.account.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/forgot.password.screen.dart';
import 'package:m_ticket_app/services/auth.service.dart';
import 'package:m_ticket_app/services/email.service.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:m_ticket_app/services/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m_ticket_app/models/user_model.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with WidgetsBindingObserver {
  ScrollController? _controller;
  AuthService _authService = AuthService();
  final email = TextEditingController();
  final password = TextEditingController();
  SharedPreferences? _prefs;
  //FirebaseAuth auth = FirebaseAuth.instance;

  bool _hideShow = true;
  bool _isLoading = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  Future<void> _signInWithGoogle() async {
    try {
      var _result = await _googleSignIn.signIn();
      var _user = UserModel();
      _user.email = _result!.email;
      _user.avatar = _result.photoUrl;
      _user.googleUid = _result.id;
      _user.name = _result.displayName;
      _user.password = '12345678';
      await ifEmailExists(_user);
    } catch (error) {
      print(error);
    }
  }

  ifEmailExists(UserModel userModel) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _emailService = EmailService();
      var data = await _emailService.ifEmailExists(userModel.email);
      var _result = json.decode(data.body);
      if (_result['result']) {
        await _signInWithGoogleUID(userModel, context);
      } else {
        final _userService = UserService();
        var result = await _userService.createUser(userModel);
        var registeredUser = json.decode(result.body);
        if (registeredUser['type'] == 'customer') {
          await _signIn(userModel.email, userModel.password, context);
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  // signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  _signIn(String? email, String? password, BuildContext context) async {
    try {
      var _result = await _authService.signIn(email, password);
      var result = json.decode(_result.body);
      if (result['token'] != null) {
        _prefs = await SharedPreferences.getInstance();
        await _prefs!.setString('token', result['token']);
        await _prefs!.setInt('userId', result['user']['id']);
        if (result['user']['employee'] != null) {
          if (result['user']['employee']['category'] != null) {
            await _prefs!.setInt(
                'categoryId', result['user']['employee']['category']['id']);
          }
        }
        await _prefs!.setString('name', result['user']['name']);
        await _prefs!.setString('email', result['user']['email']);
        if (result['user']['avatar'] != null &&
            result['user']['avatar'] != 'null') {
          await _prefs!.setString('avatar', result['user']['avatar']);
        }
        await _prefs!.setString('type', result['user']['type']);
        var _settingService = SettingsService();
        var _settingsInfo =
        await _settingService.getSettingsInfoByEmail(email!);
        if (_settingsInfo.length > 0) {
          var _setting = Settings();
          _setting.name = result['user']['name'];
          _setting.email = email;
          _setting.passwordSetOrRemove = 0;
          _setting.password = '';
          _setting.userId = result['user']['id'];
          _setting.type = result['user']['type'];
          _setting.avatar = result['user']['avatar'];
          _setting.localToken = result['token'];
          _setting.language = '';
          _setting.fontSize = 14;
          _setting.fontColor = '';
          _setting.backgroundColor = '';
          _setting.createdAt = DateTime.now().toString();
          _setting.id = _settingsInfo[0]['id'];
          await _settingService.createSettings(_setting);
        } else {
          var settingsInfo = await _settingService.getSettings();
          if (settingsInfo.length > 0) {
            _settingService.deleteSettings();
          }
          var _setting = Settings();
          _setting.name = result['user']['name'];
          _setting.email = email;
          _setting.passwordSetOrRemove = 0;
          _setting.password = '';
          _setting.userId = result['user']['id'];
          _setting.type = result['user']['type'];
          _setting.avatar = result['user']['avatar'];
          _setting.localToken = result['token'];
          _setting.language = '';
          _setting.fontSize = 14;
          _setting.fontColor = '';
          _setting.backgroundColor = '';
          _setting.createdAt = DateTime.now().toString();
          await _settingService.createSettings(_setting);
        }

        if (result['user']['type'] == 'admin') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminDashboardScreen()));
        } else if (result['user']['type'] == 'customer') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerDashboardScreen()));
        } else if (result['user']['type'] == 'employee') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeDashboardScreen()));
        } else {
          _showFailedMessage(context);
        }
      } else {
        _showFailedMessage(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller,
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo_sachetan.png',
                      width: 280,
                      height: 180,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      /* child: Center(
                        child: Text(
                            'Think Ticket Based Customer Service, think M-Ticket',
                            style: TextStyle(
                                color: appColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0)),
                      ),*/
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 5.0, right: 48.0, bottom: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Email",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 5.0, right: 48.0, bottom: 5.0),
                      child:TextField(
                          controller: email,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "Please Input Your Mail Id",hintStyle: TextStyle(fontSize: 16)
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 10.0, right: 48.0, bottom: 5.0),
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Password",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 14.0, right: 48.0, bottom: 14.0),
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:ButtonTheme(
                        minWidth: 320.0,
                        height: 45.0,
                        child: SizedBox(
                          width: 320.0,
                          height: 50.0,
                          child: ElevatedButton(
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
                              _signIn(email.text, password.text, context);
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                          ),
                        ),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            child: Text('Forgot your password'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: Text('Sign Up'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    /*SignInButton(
                      Buttons.FacebookNew,
                      text:
                          'Sign up with Facebook',
                      onPressed: () async {
                        _handleFacebookLogin();
                      },
                    ),*/
                    SignInButton(
                      Buttons.Google,
                      text: "Sign in with Google",
                      onPressed: () async {
                        _signInWithGoogle();
                      },
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
            ],
          ),
        ),
      ),
    );
  }

  _signInWithGoogleUID(UserModel userModel, BuildContext context) async {
    try {
      var _result = await _authService.signInWithGoogleUID(userModel);
      var result = json.decode(_result.body);
      if (result['token'] != null) {
        _prefs = await SharedPreferences.getInstance();
        await _prefs!.setString('token', result['token']);
        await _prefs!.setInt('userId', result['user']['id']);
        if (result['user']['employee'] != null) {
          if (result['user']['employee']['category'] != null) {
            await _prefs!.setInt(
                'categoryId', result['user']['employee']['category']['id']);
          }
        }
        await _prefs!.setString('name', result['user']['name']);
        await _prefs!.setString('email', result['user']['email']);
        if (result['user']['avatar'] != null &&
            result['user']['avatar'] != 'null') {
          await _prefs!.setString('avatar', result['user']['avatar']);
        }
        await _prefs!.setString('type', result['user']['type']);
        var _settingService = SettingsService();
        var _settingsInfo =
        await _settingService.getSettingsInfoByEmail(userModel.email!);
        if (_settingsInfo.length > 0) {
          var _setting = Settings();
          _setting.name = result['user']['name'];
          _setting.email = userModel.email;
          _setting.passwordSetOrRemove = 0;
          _setting.password = '';
          _setting.userId = result['user']['id'];
          _setting.type = result['user']['type'];
          _setting.avatar = result['user']['avatar'];
          _setting.localToken = result['token'];
          _setting.language = '';
          _setting.fontSize = 14;
          _setting.fontColor = '';
          _setting.backgroundColor = '';
          _setting.createdAt = DateTime.now().toString();
          _setting.id = _settingsInfo[0]['id'];
          await _settingService.createSettings(_setting);
        } else {
          var settingsInfo = await _settingService.getSettings();
          if (settingsInfo.length > 0) {
            _settingService.deleteSettings();
          }
          var _setting = Settings();
          _setting.name = result['user']['name'];
          _setting.email = userModel.email;
          _setting.passwordSetOrRemove = 0;
          _setting.password = '';
          _setting.userId = result['user']['id'];
          _setting.type = result['user']['type'];
          _setting.avatar = result['user']['avatar'];
          _setting.localToken = result['token'];
          _setting.language = '';
          _setting.fontSize = 14;
          _setting.fontColor = '';
          _setting.backgroundColor = '';
          _setting.createdAt = DateTime.now().toString();
          await _settingService.createSettings(_setting);
        }

        if (result['user']['type'] == 'admin') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminDashboardScreen()));
        } else if (result['user']['type'] == 'customer') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerDashboardScreen()));
        } else if (result['user']['type'] == 'employee') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeDashboardScreen()));
        } else {
          _showFailedMessage(context);
        }
      } else {
        _showFailedMessage(context);
      }
    } catch (e) {
      _showFailedMessage(context);
    }
  }
}