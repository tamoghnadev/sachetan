import 'package:m_ticket_app/models/district.dart';
import 'package:m_ticket_app/repository/repository.dart';

class DistrictService {
  Repository? _repository;

  DistrictService() {
    _repository = Repository();
  }



  getDistrict() async {
    try {
      return await _repository!.httpGet('get-district');
    } catch (e) {
      print(e.toString());
    }
  }


}