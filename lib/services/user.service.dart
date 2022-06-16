import 'package:m_ticket_app/models/profile.model.dart';
import 'package:m_ticket_app/models/user_model.dart';
import 'package:m_ticket_app/repository/repository.dart';

class UserService {
  Repository? _repository;

  UserService() {
    _repository = Repository();
  }

  createUser(UserModel user) async {
    try {
     // print(user.toJson());
      return await _repository!.httpPost('register', user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  getUserById(int? userId) async {
    try {
      return await _repository!.httpGetById('get-user-by-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  updateUser(ProfileModel user, int? userId) async {
    try {
      return await _repository!.httpPost('update-user', user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  getAvatarByUserId(int? userId) async {
    try {
      return await _repository!.httpGetById('get-avatar-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }
}
