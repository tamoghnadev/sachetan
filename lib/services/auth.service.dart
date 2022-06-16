import 'package:m_ticket_app/models/user_model.dart';
import 'package:m_ticket_app/repository/repository.dart';

class AuthService {
  Repository? _repository;

  AuthService() {
    _repository = Repository();
  }

  signIn(String? email, String? password) async {
    try {
      var data = {'email': email, 'password': password};
      var _result = await _repository!.httpPost('login', data);
      return _result;
    } catch (e) {
      print(e.toString());
    }
  }

  signOut() async {
    try {
      return await _repository!.httpPost('logout', {});
    } catch (e) {
      print(e.toString());
    }
  }

  signInWithGoogleUID(UserModel userModel) async {
    try {
      return await _repository!
          .httpPost('login-with-google-uid', userModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
