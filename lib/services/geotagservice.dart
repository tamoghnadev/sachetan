import 'package:m_ticket_app/models/geotag.dart';
import 'package:m_ticket_app/repository/repository.dart';

class GeoTagService {
  Repository? _repository;

  GeoTagService() {
    _repository = Repository();
  }

  updategeoticket(GeoTag user) async {
    try {
      // print(user.toJson());
      return await _repository!.httpPost('update-geotag', user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }


}
