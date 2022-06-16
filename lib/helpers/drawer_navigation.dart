import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:m_ticket_app/helpers/helpers.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/all.categories.screen.dart';
import 'package:m_ticket_app/screens/all.employees.screen.dart';
import 'package:m_ticket_app/screens/all.tickets.screen.dart';
import 'package:m_ticket_app/screens/app.password.screen.dart';
import 'package:m_ticket_app/screens/create.ticket.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/feedback.screen.dart';
import 'package:m_ticket_app/screens/languages_screen.dart';
import 'package:m_ticket_app/screens/ofisers.screen.dart';
import 'package:m_ticket_app/screens/opened.tickets.screen.dart';
import 'package:m_ticket_app/screens/profile.screen.dart';
import 'package:m_ticket_app/screens/re.opened.tickets.screen.dart';
import 'package:m_ticket_app/screens/resolved.tickets.screen.dart';
import 'package:m_ticket_app/screens/rewardscheme.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/screens/unresolved.tickets.screen.dart';
import 'package:m_ticket_app/services/auth.service.dart';
import 'package:m_ticket_app/services/settings.service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/opened.tickets.by.category.screen.dart';

class DrawerNavigation extends StatefulWidget {
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  SharedPreferences? _prefs;
  List<Widget> _menus = [];
  //GoogleSignIn _googleSignIn = GoogleSignIn();
var opta;
  final List<String> items = [
    'Profile',
    'Officers',
    'HelpLine',
    'Rewads Scheme',
  ];
  String? selectedValue;
  String _loginMenuText = 'Login';
  String? _name = 'John Doe';
  String? _email = 'johndoe@gamil.com';
  Widget _userIcon = Image.asset(
    'assets/user_icon.png',
    fit: BoxFit.cover,
    height: 100,
    width: 100,
  );

  @override
  void initState() {
    super.initState();
    _isLoggedIn();
  }
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // _socialLogOut() async {
  //   try {
  //     bool gb = await _googleSignIn.isSignedIn();
  //     if (gb) {
  //       _googleSignIn.signOut();
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  _isLoggedIn() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      int? userId = _prefs!.getInt('userId');
      String? avatar = _prefs!.getString('avatar');
      if (userId != null) {
        setState(() {
          _loginMenuText = "Logout";
          _name = _prefs!.getString('name');
          _email = _prefs!.getString('email');
        });
        if (avatar != null && avatar != '') {
          setState(() {
            _userIcon = CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: avatar,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            );
          });
        }
      } else {
        setState(() {
          _loginMenuText = "Login";
        });
      }
      _getDrawerMenus();
    } catch (e) {
      print(e.toString());
    }
  }

  _getDrawerMenus() async {
    _prefs = await SharedPreferences.getInstance();
    _menus = [];
    /*if (_prefs!.getString('type') == 'admin') {
      setState(() {
        _menus.add(Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    _name!,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(_email!),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    child: ClipOval(
                      child: _userIcon,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: appColor,
                ),
              ),
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'Dashboard')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AdminDashboardScreen()));
              },
            ),
            ListTile(
              title: Text('${getTranslated(context, 'My Profile')}',
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.userAlt, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('${getTranslated(context, 'Languages')}',
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.language, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new LanguagesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'All Categories')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.category,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AllCategoriesScreen()));
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'All Employees')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.userTie,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AllEmployeesScreen()));
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'All Tickets')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.ticketAlt,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AllTicketsScreen()));
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'Opened Tickets')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.bookOpen,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new OpenedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'ReOpened Tickets')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.bookOpen,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new ReOpenedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'Closed Resolved')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.uniregistry,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new ResolvedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text(
                '${getTranslated(context, 'Closed UnResolved')}',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.doorClosed,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new UnResolvedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text('${getTranslated(context, 'App Password')}',
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.key, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AppPasswordScreen()));
              },
            ),
            GestureDetector(
              onTap: () async {
                if (await canLaunch('$faqSupport')) {
                  await launch('$faqSupport');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0),
                child: ListTile(
                  leading: Icon(Icons.help, color: Colors.white),
                  title: Text(
                      '${getTranslated(context, 'FAQ')} & ${getTranslated(context, 'Support')}',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0),
              child: InkWell(
                onTap: () async {
                  try {
                    final _settingService = SettingsService();
                    final _authService = AuthService();
                    final settingsInfo = await _settingService.getSettings();
                    if (settingsInfo.length > 0) {
                      _prefs!.clear();
                      _settingService.deleteSettings();
                      _authService.signOut();
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                  );
                },
                child: ListTile(
                  leading:
                      Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                  title: Text(_loginMenuText,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 17, bottom: 20.0),
              child: InkWell(
                  onTap: () async {
                    if (await canLaunch('$tramAndCondition')) {
                      await launch('$tramAndCondition');
                    }
                  },
                  child: Text(
                      '${getTranslated(context, 'Terms & Conditions and Privacy Policy')}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ))),
            ),
          ],
        ));
      });
    } else*/ if (_prefs!.getString('type') == 'employee') {
      setState(() {
        _menus.add(Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    _name!,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(_email!),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    child: ClipOval(
                      child: _userIcon,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: appColor,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new EmployeeDashboardScreen()));
              },
            ),
            ListTile(
              title: Text("Profiles",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.userAlt, color: Colors.white),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is now Disabled",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
                /*Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );*/
              },
            ),
            ListTile(
              title: Text("Officers",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.language, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new LanguagesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                "Help Line",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.ticketAlt,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AllTicketsScreen()));
              },
            ),
            ListTile(
              title: Text("Rewards & Scheme",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.bookOpen,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new OpenedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text("Government",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.bookOpen,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new ReOpenedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text("Feed Back",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.uniregistry,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new ResolvedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text("Support",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.doorClosed,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new UnResolvedTicketsScreen()));
              },
            ),
            ListTile(
              title: Text("Social Media",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.key, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AppPasswordScreen()));
              },
            ),
            ListTile(
              title: Text("Track Inputs",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.key, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AppPasswordScreen()));
              },
            ),


            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0),
              child: InkWell(
                onTap: () async {
                  try {
                    var _settingService = SettingsService();
                    var settingsInfo = await _settingService.getSettings();
                    if (settingsInfo.length > 0) {
                      _prefs!.clear();
                      _settingService.deleteSettings();
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: ListTile(
                  leading:
                  Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                  title: Text(_loginMenuText,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 17, bottom: 20.0),
              child: InkWell(
                  onTap: () async {
                    if (await canLaunch('')) {
                      await launch('');
                    }
                  },
                  child: Text(
                      'Terms & Conditions and Privacy Policy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ))),
            ),
          ],
        ));
      });
    } else if (_prefs!.getString('type') == 'customer') {
      setState(() {
        _menus.add(Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    _name!,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(_email!),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    child: ClipOval(
                      child: _userIcon,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: appColor,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new CustomerDashboardScreen()));
              },
            ),
            ListTile(
              title:DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,

                  hint: Text(
                    'ACB',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white, // <-- SEE HERE
                  ),
                  items: items
                      .map((item) =>
                      DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                      if(selectedValue=='Profile'){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new ProfileScreen()));
                      }else if(selectedValue=='Officers'){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new OfisersScreen()));
                      }else if(selectedValue=='HelpLine'){
                        _makingPhoneCall();
                      }else if(selectedValue=='Rewads Scheme'){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) => new RewardschemeScreen()));
                      }

                    });
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                  dropdownDecoration: BoxDecoration(
                    boxShadow: null,
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFF01509d),
                  ),

                ),
              ),
              leading: Icon(
                Icons.list,
                color: Colors.white,
              ),
             /* onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new CustomerDashboardScreen()));
              },*/
            ),
            /*ListTile(
              title: Text("Profile",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.userAlt, color: Colors.white),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
                *//*Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );*//*
              },
            ),
            ListTile(
              title: Text("Officers",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(FontAwesomeIcons.language, color: Colors.white),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
                *//*Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new LanguagesScreen(),
                  ),
                );*//*
              },
            ),
            ListTile(
              title: Text(
                "Help Line",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.ticketAlt,
                color: Colors.white,
              ),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
                *//*Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AllTicketsScreen()));*//*
              },
            ),
            ListTile(
              title: Text("Rewards & Scheme",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                FontAwesomeIcons.bookOpen,
                color: Colors.white,
              ),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
                *//*Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new OpenedTicketsScreen()));*//*
              },
            ),*/
            ListTile(
              title: Text("Government",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.star,
                color: Colors.white,
              ),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
               /* Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new ReOpenedTicketsScreen()));*/
              },
            ),
            ListTile(
              title: Text("Feed Back",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.feedback,
                color: Colors.white,
              ),
              onTap: () {
                /*Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );*/
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new FeedbackScreen()));
              },
            ),
            ListTile(
              title: Text("Support",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.contact_support,
                color: Colors.white,
              ),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
                /*Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new UnResolvedTicketsScreen()));*/
              },
            ),
            ListTile(
              title: Text("Social Media",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.share, color: Colors.white),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );
               /* Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new AppPasswordScreen()));*/
              },
            ),
            ListTile(
              title: Text("Track Inputs",
                  style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.track_changes, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new OpenedTicketsByCategoryScreen()));
               /* Fluttertoast.showToast(
                    msg: "This Option is Disabled Temporary",  // message
                    toastLength: Toast.LENGTH_SHORT, // length
                    gravity: ToastGravity.CENTER,    // location
                    timeInSecForIosWeb: 1               // duration
                );*/

              },
            ),


            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0),
              child: InkWell(
                onTap: () async {
                  try {
                    var _settingService = SettingsService();
                    var settingsInfo = await _settingService.getSettings();
                    if (settingsInfo.length > 0) {
                      _prefs!.clear();
                      _settingService.deleteSettings();
                      _googleSignIn.signOut();
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: ListTile(
                  leading:
                  Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                  title: Text(_loginMenuText,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 17, bottom: 20.0),
              child: InkWell(
                  onTap: () async {
                    if (await canLaunch('')) {
                      await launch('');
                    }
                  },
                  child: Text(
                      'Terms & Conditions and Privacy Policy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ))),
            ),
          ],
        ));
      });
    } /*else {
      setState(() {
        _menus.add(Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) => new ProfileScreen(),
                  ),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    _name!,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(_email!),
                ),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    child: ClipOval(
                      child: _userIcon,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: appColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (await canLaunch('$faqSupport')) {
                  await launch('$faqSupport');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0),
                child: ListTile(
                  leading: Icon(Icons.help, color: Colors.white),
                  title: Text(
                      '${getTranslated(context, 'FAQ')} & ${getTranslated(context, 'Support')}',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0, bottom: 0.0),
              child: InkWell(
                onTap: () async {
                  try {
                    var _settingService = SettingsService();
                    var settingsInfo = await _settingService.getSettings();
                    if (settingsInfo.length > 0) {
                      //_socialLogOut();
                      _prefs!.clear();
                      _settingService.deleteSettings();
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
                child: ListTile(
                  leading:
                      Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                  title: Text(_loginMenuText,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 17, bottom: 20.0),
              child: InkWell(
                onTap: () async {
                  if (await canLaunch('$tramAndCondition')) {
                    await launch('$tramAndCondition');
                  }
                },
                child: Text(
                  '${getTranslated(context, 'Terms & Conditions and Privacy Policy')}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ));
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appColor,
      child: Drawer(
        child: Container(
          color: appColor,
          child: ListView(
            children: _menus,
          ),
        ),
      ),
    );
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:8017541863");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
