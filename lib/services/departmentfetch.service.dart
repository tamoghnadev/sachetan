import 'package:m_ticket_app/models/Departments.dart';
import 'package:m_ticket_app/repository/repository.dart';

class DepartmentFetchService {
  Repository? _repository;

  DepartmentFetchService() {
    _repository = Repository();
  }



  getDepartments() async {
    try {
      return await _repository!.httpGet('get-department');
    } catch (e) {
      print(e.toString());
    }
  }


}