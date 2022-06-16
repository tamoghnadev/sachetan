import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/services/languages_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Map<String?, String?> _localizedValues = {};

  Future load() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _languagesService = LanguagesService();
      var response =
          await _languagesService.getLanguageValues(_prefs.getInt('userId'));
      var result = json.decode(response.body.toString());
      Map<String, dynamic> mappedJson = result;
      _localizedValues =
          mappedJson.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      print(e.toString());
    }
  }

  String? getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'fr', 'zh', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization _appLocalization = AppLocalization(locale);
    await _appLocalization.load();
    return _appLocalization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
