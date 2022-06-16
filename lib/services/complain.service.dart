import 'package:m_ticket_app/models/officers.dart';
import 'package:m_ticket_app/repository/repository.dart';

class ComplainService {
  Repository? _repository;

  ComplainService() {
    _repository = Repository();
  }



  getCompalins() async {
    try {
      return await _repository!.httpGet('get-complaint-type');
    } catch (e) {
      print(e.toString());
    }
  }


}