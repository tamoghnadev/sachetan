import 'package:m_ticket_app/models/officers.dart';
import 'package:m_ticket_app/repository/repository.dart';

class OfficersService {
  Repository? _repository;

  OfficersService() {
    _repository = Repository();
  }



  getOfficers() async {
    try {
      return await _repository!.httpGet('get-officer');
    } catch (e) {
      print(e.toString());
    }
  }


}