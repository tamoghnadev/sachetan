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

class RewardschemeScreen extends StatefulWidget {
  @override
  _RewardschemeScreenState createState() => _RewardschemeScreenState();
}

class _RewardschemeScreenState extends State<RewardschemeScreen>
    with WidgetsBindingObserver {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text('Reward Scheme'),
        actions: <Widget>[

        ],
      ),
      body: SingleChildScrollView(
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                ),
    ),
            ],
          ),
        ),
      ),
    );
  }


}