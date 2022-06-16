import 'package:m_ticket_app/models/language.dart';
import 'package:m_ticket_app/repository/repository.dart';

class LanguagesService {
  Repository? _repository;

  LanguagesService() {
    _repository = Repository();
  }

  getLanguageValues(int? userId) async {
    try {
      return await _repository!.httpGetById('get-language-values', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  getLanguage() async {
    try {
      return await _repository!.httpGet('get-languages');
    } catch (e) {
      print(e.toString());
    }
  }

  setTranslateValue(String? key) async {
    try {
      return await _repository!.httpGet('set-translate-value/$key');
    } catch (e) {
      print(e.toString());
    }
  }

  getLanguagesByMemberId(int? memberId) async {
    try {
      return await _repository!
          .httpGetById('get-languages-by-member-id', memberId);
    } catch (e) {
      print(e.toString());
    }
  }

  makeDefaultLanguage(Language language) async {
    try {
      return await _repository!
          .httpPost('make-default-language', language.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
