import 'package:flutter/material.dart';
import 'package:m_ticket_app/models/review.dart';

class Ticket {
  int? id;
  String? subject;

  String? message;
  String? created_at;
  String? comp_for;
  int? department;
  String? ctypee;
  int? office;
  String? prodid;
  int? district;
  int? officers;
  String? person;
  String? priority;
  String? propdets;
  String? geotag;
  Widget? color;
  String? screenShotPath;
  late List<dynamic> reviews;
  bool? isOpened;
  bool? isanonymous;
  bool? isReopened;
  bool? isClosedResolved;
  bool? isClosedUnResolved;
  int? categoryId;
  int? selectedStaffOrManager;
  int? userId;
  Widget? status;
  String? ticketStatus;
  String? category;

  toJson() {
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
  }
}
