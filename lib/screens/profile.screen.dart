import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:m_ticket_app/models/profile.model.dart';
import 'package:m_ticket_app/models/settings.dart';
import 'package:m_ticket_app/models/user_model.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:m_ticket_app/services/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences? _prefs;
  UserService? _userService;

  final imagePicker = ImagePicker();
  File? _image;
  Widget showAvatar = Image.asset(
    'assets/dummy.png',
    width: 100,
    height: 100,
  );
  bool _hideShowPassword = true;
  bool _hideShowConfirmPassword = true;
  bool _isLoading = false;

  int? _userId = 0;

  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  _getUserInfo() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _prefs = await SharedPreferences.getInstance();
      _userService = UserService();
      setState(() {
        _userId = _prefs!.getInt('userId');
      });

      var _result = await _userService!.getUserById(_userId);
      if (_result != null) {
        var _user = json.decode(_result.body);
        setState(() {
          _email.text = _user['email'];
          _name.text = _user['name'];
          if (_user['avatar'] != null && _user['avatar'] != 'null') {
            showAvatar = CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: _user['avatar'],
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            );
          }
        });
        if (_user['avatar'] != null && _user['avatar'] != 'null') {
          await _prefs!.setString('avatar', _user['avatar']);
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _chooseImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Widget _showImage() {
    if (_image != null) {
      return Image.file(_image!);
    } else {
      return showAvatar;
    }
  }

  _updateProfile(ProfileModel user) async {
    try {
      return await _userService!.updateUser(user, _userId);
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
        title: Center(child: Text('${getTranslated(context, 'My Profile')}')),
        leading: InkWell(
          onTap: () async {
            _prefs = await SharedPreferences.getInstance();
            if (_prefs!.getString('type') == 'customer') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDashboardScreen(),
                ),
              );
            } else if (_prefs!.getString('type') == 'employee') {
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
                  builder: (context) => AdminDashboardScreen(),
                ),
              );
            }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerDashboardScreen()));
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
          child: _isLoading == false
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                            child: Padding(

                              padding: const EdgeInsets.only(left: 80.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        _chooseImage();
                                      },
                                      child: GestureDetector(
                                        child: CircleAvatar(
                                          radius: 65,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(child: _showImage()),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                            TextFormField(
                              controller: _email,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: 'user@m-ticket.com',
                                  labelText:
                                      'Email'),
                            ),
                            TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                  hintText: 'John Doe',
                                  labelText:
                                      'Name'),
                            ),
                            TextFormField(
                              controller: _password,
                              obscureText: _hideShowPassword,
                              decoration: InputDecoration(
                                hintText: '******',
                                labelText:
                                    'New Password',
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _hideShowPassword
                                          ? _hideShowPassword = false
                                          : _hideShowPassword = true;
                                    });
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _confirmPassword,
                              obscureText: _hideShowConfirmPassword,
                              decoration: InputDecoration(
                                hintText: '******',
                                labelText:
                                    'Confirm Password',
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _hideShowConfirmPassword
                                          ? _hideShowConfirmPassword = false
                                          : _hideShowConfirmPassword = true;
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: appColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    if (_password.text ==
                                        _confirmPassword.text) {
                                      var user = ProfileModel();
                                      user.email = _email.text;
                                      user.id = _userId;
                                      user.name = _name.text;
                                      user.password = _password.text;

                                      setState(() {
                                        _isLoading = true;
                                      });
                                      if (_image != null) {
                                        user.base64 = base64Encode(
                                            _image!.readAsBytesSync());
                                        user.fileName =
                                            _image!.path.split("/").last;
                                      } else {
                                        user.base64 = null;
                                        user.fileName = null;
                                      }
                                      var response = await _updateProfile(user);
                                      var result =jsonDecode(response.body.toString());
                                      if (result['user'] != null) {
                                        await _prefs!.setString(
                                            'name', result['user']['name']);
                                        await _prefs!.setString(
                                            'email', result['user']['email']);
                                        if (result['user']['avatar'] != null &&
                                            result['user']['avatar'] !=
                                                'null') {
                                          await _prefs!.setString('avatar',
                                              result['user']['avatar']);
                                        }

                                        var _settingService = SettingsService();
                                        var _settingsInfo =
                                            await _settingService
                                                .getSettingsInfoByEmail(
                                                    result['user']['email']!);
                                        if (_settingsInfo.length > 0) {
                                          var _setting = Settings();
                                          _setting.name =
                                              result['user']['name'];
                                          _setting.email =
                                              result['user']['email'];
                                          _setting.passwordSetOrRemove = 0;
                                          _setting.password = '';
                                          _setting.userId =
                                              result['user']['id'];
                                          _setting.type =
                                              result['user']['type'];
                                          _setting.avatar =
                                              result['user']['avatar'];
                                          _setting.localToken =
                                              _prefs!.getString('token');
                                          _setting.language = '';
                                          _setting.fontSize = 14;
                                          _setting.fontColor = '';
                                          _setting.backgroundColor = '';
                                          _setting.createdAt =
                                              DateTime.now().toString();
                                          _setting.id = _settingsInfo[0]['id'];
                                          await _settingService
                                              .createSettings(_setting);
                                        }

                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Timer(Duration(seconds: 1), () {
                                          _showSnackBar(
                                            Text(
                                              "Profile information updated",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        });
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Timer(Duration(seconds: 1), () {
                                          _showSnackBar(
                                            Text(
                                              "Error while updating profile! Please try again later",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      _showSnackBar(
                                        Text(
                                          "Confirm password does not match!",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      ),
    );
  }
}
