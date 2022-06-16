import 'package:flutter/material.dart';
import 'package:m_ticket_app/models/review.dart';

class Reward {
  int? id;
  int? userId;
  String? receipt_num;
  String? gist;
  String? amount;
  String? datte;


  /*toJson() {
    return {
      //'id': id.toString(),
      'com_for': comp_for.toString(),
      'department': department.toString(),
      'office': office.toString(),
      'district': district.toString(),
      'officers': officers.toString(),
      'geotag': geotag.toString(),
      'person': person.toString(),
      'complaint_type_id': ctypee.toString(),
      'propid':prodid.toString(),
      'propdetls': propdets.toString(),
      'subject': subject.toString(),
      'message': message.toString(),
      'is_anon': isanonymous.toString(),
      'is_opened': isOpened.toString(),
      'is_reopened': isReopened.toString(),
      'is_closed_resolved': isClosedResolved.toString(),
      'is_closed_unresolved': isClosedUnResolved.toString(),
      'selectedStaffOrManager': selectedStaffOrManager.toString(),
      'user_id': userId.toString(),
    };
  }*/
}
