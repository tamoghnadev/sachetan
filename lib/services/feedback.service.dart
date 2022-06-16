import 'package:m_ticket_app/models/feedback.model.dart';
import 'package:m_ticket_app/repository/repository.dart';

class FeedbackService {
  Repository? _repository;

  FeedbackService() {
    _repository = Repository();
  }

  createFeedBack(FeedbackModel user) async {
    try {
      // print(user.toJson());
      return await _repository!.httpPost('contacts', user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }


}
