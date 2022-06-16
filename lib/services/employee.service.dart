import 'dart:convert';
import 'dart:io';

import 'package:m_ticket_app/models/employee.dart';
import 'package:m_ticket_app/repository/repository.dart';

class EmployeeService {
  Repository? _repository;

  EmployeeService() {
    _repository = Repository();
  }

  createEmployee(Employee employee) async {
    try {
      return await _repository!.httpPost('create-employee', employee.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  getEmployees() async {
    try {
      return await _repository!.httpGet('get-employees');
    } catch (e) {
      print(e.toString());
    }
  }

  getEmployeeById(int? userId, String? token) async {
    try {
      return await _repository!.httpGetById('get-user-by-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  uploadAvatar(File imageFile, int? userId) async {
    try {
      String base64 = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;

      var data = {
        'id': userId.toString(),
        'base64': base64.toString(),
        'fileName': fileName
      };
      var resource =
          await _repository!.httpPost('upload-employee-avatar', data);
      return jsonDecode(resource.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  getAvatarByEmployeeId(int? employeeId, String? token) async {
    try{
      return await _repository!
        .httpGetById('get-avatar-by-employee-id', employeeId);
    } catch(e){
      print(e.toString());
    }
  }

  deleteEmployee(int? employeeId) async {
    try {
      return await _repository!
          .httpGetById('delete-employee-by-employee-id', employeeId);
    } catch (e) {
      print(e.toString());
    }
  }
}