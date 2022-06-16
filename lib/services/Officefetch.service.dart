import 'package:m_ticket_app/models/Offices.dart';
import 'package:m_ticket_app/repository/repository.dart';

class OfficeFetchService {
  Repository? _repository;

  OfficeFetchService() {
    _repository = Repository();
  }



  getOffices() async {
    try {
      return await _repository!.httpGet('get-office');
    } catch (e) {
      print(e.toString());
    }
  }


}