import 'package:m_ticket_app/models/settings.dart';
import 'package:m_ticket_app/repository/repository.dart';

class SettingsService {
  Repository? _repository;

  SettingsService() {
    _repository = new Repository();
  }

  createSettings(Settings settings) async {
    try {
      if (settings.id != null) {
        return await _repository!.update('settings', settings.toMap());
      }
      return await _repository!.save('settings', settings.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  getSettings() async {
    try {
      var _settings = await _repository!.getAll('settings');
      List<Settings> _settingsList = [];
      for (int i = 0; i < _settings.length; i++) {
        var _setting = Settings();
        _setting.name = _settings[i]['name'];
        _setting.email = _settings[i]['email'];
        _setting.passwordSetOrRemove = _settings[i]['passwordSetOrRemove'];
        _setting.password = _settings[i]['password'];
        _setting.userId = _settings[i]['userId'];
        _setting.type = _settings[i]['type'];
        _setting.avatar = _settings[i]['avatar'];
        _setting.localToken = _settings[i]['localToken'];
        _setting.language = _settings[i]['language'];
        _setting.fontSize = _settings[i]['fontSize'];
        _setting.fontColor = _settings[i]['fontColor'];
        _setting.backgroundColor = _settings[i]['backgroundColor'];
        _setting.createdAt = _settings[i]['createdAt'];
        _setting.id = _settings[i]['id'];
        _settingsList.add(_setting);
      }
      return _settingsList;
    } catch (e) {
      print(e.toString());
    }
  }

  getSettingsInfoByEmail(String? email) async {
    try {
      return await _repository!.getByEmail('settings', email);
    } catch (e) {
      print(e.toString());
    }
  }

  deleteSettings() async {
    try {
      return await _repository!.delete('settings');
    } catch (e) {
      print(e.toString());
    }
  }

  updateSettings(
      int? passwordSetOrRemove, String? password, int? userId) async {
    try {
      var _settings = await getSettings();

      var _setting = Settings();

      if (_settings.length > 0) {
        _setting.name = _settings[0].name;
        _setting.email = _settings[0].email;
        _setting.passwordSetOrRemove = passwordSetOrRemove;
        _setting.password = password;
        _setting.userId = userId;
        _setting.avatar = _settings[0].avatar;
        _setting.localToken = _settings[0].localToken;
        _setting.language = _settings[0].language;
        _setting.fontSize = _settings[0].fontSize;
        _setting.fontColor = _settings[0].fontColor;
        _setting.backgroundColor = _settings[0].backgroundColor;
        _setting.createdAt = _settings[0].createdAt;
        _setting.id = _settings[0].id;
        return await _repository!.update('settings', _setting.toMap());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
