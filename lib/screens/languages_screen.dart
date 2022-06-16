import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/language.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/languages_services.dart';
import 'package:m_ticket_app/widgets/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  List<Language> _languageList = [];
  List<Color> _fontColors = [];
  List<FontWeight> _fontWeights = [];
  List<double> _fontSizes = [];
  List<IconData?> _defaultIcons = [];
  List<Color> _defaultIconColors = [];
  SharedPreferences? _prefs;
  bool isCheckedOne = false;
  bool isCheckedTwo = false;
  bool isCheckedThree = false;
  bool isCheckedFour = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getLanguages();
  }

  _getLanguages() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _prefs = await SharedPreferences.getInstance();
      final _languagesService = LanguagesService();
      var response = await _languagesService
          .getLanguagesByMemberId(_prefs!.getInt('userId'));
      var _languages = jsonDecode(response.body.toString());
      _languages.forEach((language) {
        var _language = Language();
        _language.languageId = int.parse(language['id'].toString());
        _language.languageName = language['name'];
        _language.languageCode = language['code'];
        _language.image = language['image'];
        if (int.parse(language['is_default'].toString()) == 1) {
          _language.isDefault = true;
          _defaultIcons.add(Icons.check);
          _defaultIconColors.add(appColor);
          _fontColors.add(Colors.green);
          _fontWeights.add(FontWeight.bold);
          _fontSizes.add(20);
        } else {
          _language.isDefault = false;
          _defaultIconColors.add(Colors.white);
          _defaultIcons.add(null);
          _fontWeights.add(FontWeight.normal);
          _fontColors.add(Colors.black);
          _fontSizes.add(16);
        }

        setState(() {
          _languageList.add(_language);
        });
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _makeDefault(int? languageId, int? memberId, String? languageCode) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final _languagesService = LanguagesService();
      var _language = Language();
      _language.languageId = languageId;
      _language.memberId = memberId;

      _language.languageCode = languageCode;
      await _languagesService.makeDefaultLanguage(_language);

      _changeLanguage(_language);
    } catch (e) {
      print(e.toString());
    }
  }

  void _changeLanguage(Language language) async {
    try {
      Locale _locale = await setLocale(language.languageCode);
      AppWidget.setLocale(context, _locale);
    } catch (e) {
      print(e.toString());
    }
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          elevation: 0.0,
          leading: InkWell(
            onTap: () async {
              _prefs = await SharedPreferences.getInstance();

              if (_prefs!.getString('token') != '' &&
                  _prefs!.getString('token') != null) {
                if (_prefs!.getString('type') == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboardScreen(),
                    ),
                  );
                } else if (_prefs!.getString('type') == 'customer') {
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
                      builder: (context) => SignInScreen(),
                    ),
                  );
                }
              }
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "${getTranslated(context, 'Languages') ?? 'Languages'}",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        body: _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Align(
                    child: Text(
                      "${getTranslated(context, 'Languages') ?? 'Languages'}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: appColor,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    height: 95 * (_languageList.length + 1.0),
                    child: ListView.builder(
                      itemCount: _languageList.length,
                      itemBuilder: (context, index) {
                        counter++;
                        return GestureDetector(
                          onTap: () {
                            if (_languageList[index].isDefault == false) {
                              _makeDefault(
                                  _languageList[index].languageId,
                                  _prefs!.getInt('userId'),
                                  _languageList[index].languageCode);
                              var _indexOfIconCheck =
                                  _defaultIcons.indexOf(Icons.check);
                              var _indexOfColor =
                                  _fontColors.indexOf(Colors.green);
                              var _indexOfFontWeight =
                                  _fontWeights.indexOf(FontWeight.bold);
                              var _indexOfFontSizes = _fontSizes.indexOf(20);

                              setState(() {
                                _languageList[_indexOfIconCheck].isDefault =
                                    false;
                                _languageList[index].isDefault = true;
                                _defaultIcons[index] = Icons.check;
                                _defaultIcons[_indexOfIconCheck] = null;
                                _defaultIconColors[_indexOfIconCheck] =
                                    Colors.white;
                                _defaultIconColors[index] = appColor;
                                _fontColors[index] = Colors.green;
                                _fontColors[_indexOfColor] = Colors.black;
                                _fontWeights[index] = FontWeight.bold;
                                _fontWeights[_indexOfFontWeight] =
                                    FontWeight.normal;
                                _fontSizes[index] = 20;
                                _fontSizes[_indexOfFontSizes] = 16;
                              });
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 25,
                                      child: Image.network(
                                          '${_languageList[index].image}'),
                                    ),
                                    Text(
                                      "${_languageList[index].languageName}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Icon(
                                      _defaultIcons[index],
                                      color: _defaultIconColors[index],
                                    )
                                  ],
                                ),
                              ),
                              (counter == _languageList.length) == true
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25, top: 20),
                                      child: Divider(
                                        height: 6,
                                        color: Colors.black,
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
