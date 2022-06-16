import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/localization/app_localization.dart';

import 'package:m_ticket_app/screens/splash.screen.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);
  
  static void setLocale(BuildContext context, Locale local) {
    _AppWidgetState? _localState = context.findAncestorStateOfType<_AppWidgetState>();
    _localState!.setLocale(local);
  }

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(

        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale("es", "ES"),
          Locale("fr", "FR"),
          Locale("zh", "CH"),
          Locale("pt", "PT"),
        ],
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocals) {
          for (var locale in supportedLocals) {
            if (locale.languageCode == deviceLocale!.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocals.first;
        },
        title: 'Sachetan',
        home: SplashScreen(),
      );
    }
  }
}
