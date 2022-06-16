import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

import 'db.connection.dart';

class Repository {
  DatabaseConnection? _connection;

  // PLEASE DO NOT USE LOCALHOST. SIMPLY LOCALHOST DOES NOT WORK IN MOBILE APP.
  String? url = 'http://tickets.scriptrix.net/api';

  Repository() {
    _connection = new DatabaseConnection();
  }

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;

    _db = await _connection!.setDb();
    return _db;
  }

  _getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? _token = _prefs.getString('token');
    return _token;
  }

  httpGet(String api) async {
    try {
      String? _token = await _getToken();
      return await http.get(Uri.parse('$url/$api'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'})
        ..persistentConnection;
    } catch (exception) {
      print(exception.toString());
    }
  }

  httpGetById(String api, int? id) async {
    try {
      String? _token = await _getToken();

      return await http.get(
          Uri.parse(this.url! + '/' + api + '/' + id.toString()),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'})
        ..persistentConnection;
    } catch (exception) {
      print(exception.toString());
    }
  }

  httpPost(String api, data) async {
    try {
      print(data);
      String? _token = await _getToken();
      return await http.post(Uri.parse(this.url! + '/' + api),
          body: data,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'})
        ..persistentConnection;
    } catch (exception) {
      print(exception.toString());
    }
  }

  httpPut(String api, data, int? id) async {
    try {
      String? _token = await _getToken();
      return await http.put(
          Uri.parse(this.url! + '/' + api + '/' + id.toString()),
          body: data,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'})
        ..persistentConnection;
    } catch (exception) {
      print(exception.toString());
    }
  }

  httpDelete(String api, int? id) async {
    try {
      String? _token = await _getToken();
      return await http.delete(
          Uri.parse(this.url! + '/' + api + '/' + id.toString()),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_token'})
        ..persistentConnection;
    } catch (exception) {
      print(exception.toString());
    }
  }

  save(table, data) async {
    try {
      var conn = await db;
      return await conn!.insert(table, data);
    } catch (exception) {
      print(exception.toString());
    }
  }

  getAll(table) async {
    try {
      var conn = await db;
      List<Map> list = await conn!.query(table);
      return list;
    } catch (exception) {
      print(exception.toString());
    }
  }

  update(table, obj) async {
    try {
      var conn = await db;
      return await conn!
          .update(table, obj, where: 'id = ?', whereArgs: [obj['id']]);
    } catch (exception) {
      print(exception.toString());
    }
  }

  delete(table) async {
    try {
      var conn = await db;
      return await conn!.delete(table);
    } catch (exception) {
      print(exception.toString());
    }
  }

  getByEmail(table, email) async {
    try {
      var _con = await db;
      return await _con!
          .query(table, where: 'email=?', whereArgs: <String>[email]);
    } catch (exception) {
      print(exception.toString());
    }
  }
}
