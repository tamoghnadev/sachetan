import 'dart:convert';
import 'dart:io';

import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/models/ticket_reply.dart';
import 'package:m_ticket_app/repository/repository.dart';

class RewardService {
  Repository? _repository;

  RewardService() {
    _repository = Repository();
  }



  getRewardsById(int? id) async {
    try {
      return await _repository!.httpGetById('get-reward-by-user_id', id);
    } catch (e) {
      print(e.toString());
    }
  }

}
