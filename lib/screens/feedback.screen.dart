import 'dart:async';
import 'dart:convert';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/feedback.model.dart';
import 'package:m_ticket_app/models/settings.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/create.account.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/forgot.password.screen.dart';
import 'package:m_ticket_app/services/auth.service.dart';
import 'package:m_ticket_app/services/email.service.dart';
import 'package:m_ticket_app/services/feedback.service.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:m_ticket_app/services/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m_ticket_app/models/user_model.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with WidgetsBindingObserver {
  ScrollController? _controller;
  AuthService _authService = AuthService();
  final email = TextEditingController();
  final password = TextEditingController();
  var name = TextEditingController();
  var name1 = TextEditingController();
  var name2 = TextEditingController();
  var _message1 = TextEditingController();
  SharedPreferences? _prefs;
  var feedi = FeedbackService();
  //FirebaseAuth auth = FirebaseAuth.instance;



  bool _hideShow = true;
  bool _isLoading = false;

  _submitFeedback(String name, String email, String mob, String mssg) async {
    try {
      var _user = FeedbackModel();
      _user.name = name;
      _user.email = email;
      _user.mob = mob;
      _user.mssg = mssg;
      final _result = await feedi.createFeedBack(_user);
      if (_result.body != null) {
        final data = json.decode(_result.body);
        if (data['success']) {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Feed Back Submitted Successfully",  // message
              toastLength: Toast.LENGTH_SHORT, // length
              gravity: ToastGravity.CENTER,    // location
              timeInSecForIosWeb: 1               // duration
          );
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerDashboardScreen()));
          });
          /*_showSuccessMessage(context);
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          });*/
        }
      }
    } catch (e) {
      //_showFailedMessage(context);
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
                          child: Text("Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 5.0, right: 48.0, bottom: 5.0),
                      child:TextField(
                          controller: name,
                          keyboardType: TextInputType.text,
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
                          left: 48.0, top: 10.0, right: 48.0, bottom: 5.0),
                      child:Align(
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
                          controller: name1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "Please Input Your Email",hintStyle: TextStyle(fontSize: 16)
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 10.0, right: 48.0, bottom: 5.0),
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Mobile Number",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, top: 5.0, right: 48.0, bottom: 5.0),
                      child:TextField(
                          controller: name2,
                          keyboardType: TextInputType.number,
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
                          left: 48.0, top: 10.0, right: 48.0, bottom: 5.0),
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text("Feed Back",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.lightBlue)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0, top: 10.0, right: 48.0, bottom: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                        controller: _message1,
                        maxLines: 100,
                        minLines: 7,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText:
                            'Write your message here',
                            ),
                        style: TextStyle(fontSize: 20),
                      ),

      ),
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
                              /*Fluttertoast.showToast(
                                  msg: "This is not functional",  // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.CENTER,    // location
                                  timeInSecForIosWeb: 1               // duration
                              );*/
                              _submitFeedback(name.text, name1.text, name2.text, _message1.text);
                            },
                            child: Text(
                              'Submit Feedback',
                              style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                          ),
                        ),

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

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}