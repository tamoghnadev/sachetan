import 'package:flutter/material.dart';
import 'package:m_ticket_app/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

const String ENGLISH = 'en';
const String SPANISH = 'es';
const String FRENCH = 'fr';
const String CHINESE = 'zh';
const String PORTUGEES = 'pt';

setLocale(String? languageCode) async {
  try {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(LAGUAGE_CODE, languageCode!);
    return _locale(languageCode);
  } catch (e) {
    print(e.toString());
  }
}

getLocale() async {
  try {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
    return _locale(languageCode);
  } catch (e) {
    print(e.toString());
  }
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case SPANISH:
      return Locale(SPANISH, "ES");
    case FRENCH:
      return Locale(FRENCH, "FR");
    case CHINESE:
      return Locale(CHINESE, "CN");
    case PORTUGEES:
      return Locale(PORTUGEES, "PT");
    default:
      return Locale(ENGLISH, 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  try {
    return AppLocalization.of(context)!.getTranslatedValue(key);
  } catch (e) {
    print(e.toString());
  }
}
