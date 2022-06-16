import 'package:m_ticket_app/repository/repository.dart';

class EmailService {
  Repository? _repository;
  EmailService() {
    _repository = Repository();
  }

  ifEmailExists(String? email) async {
    try {
      var data = {'email': email};
      return await _repository!.httpPost('check-email', data);
    } catch (e) {
      print(e.toString());
    }
  }

  sendEmail(String? email) async {
    try {
      var data = {'email': email};
      return await _repository!.httpPost('send-email', data);
    } catch (e) {
      print(e.toString());
    }
  }

  verifyCode(String? code) async {
    try {
      var data = {'code': code};
      return await _repository!.httpPost('verify-password-code', data);
    } catch (e) {
      print(e.toString());
    }
  }

  resetPassword(String? code, String? password) async {
    try {
      var data = {'code': code, 'password': password};
      return await _repository!.httpPost('reset-password', data);
    } catch (e) {
      print(e.toString());
    }
  }
}
