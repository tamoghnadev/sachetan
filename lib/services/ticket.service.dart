import 'dart:convert';
import 'dart:io';

import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/models/ticket_reply.dart';
import 'package:m_ticket_app/repository/repository.dart';

class TicketService {
  Repository? _repository;

  TicketService() {
    _repository = Repository();
  }

  createTicket(Ticket ticket) async {
    try {
      return await _repository!.httpPost('tickets', ticket.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  getTicketById(int? id) async {
    try {
      return await _repository!.httpGetById('tickets', id);
    } catch (e) {
      print(e.toString());
    }
  }

  getTicketsByUserId(int? userId) async {
    try {
      return await _repository!.httpGetById('get-tickets-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  getTicketsByCategoryIdAndUserId(int? categoryId, int? userId) async {
    try {
      return await _repository!.httpGetById(
          'get-tickets-by-category-id-and-user-id/' + categoryId.toString(),
          userId);
    } catch (e) {
      print(e.toString());
    }
  }

  getOpenedTicketsByCategoryIdAndUserId(int? userId) async {
    try {
      return await _repository!.httpGetById(
          'get-opened-tickets-by-category-id-and-user-id' ,userId);
    } catch (e) {
      print(e.toString());
    }
  }

  uploadTicketScreenshot(File imageFile, int? ticketId) async {
    try {
      String base64 = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;

      var data = {
        'id': ticketId.toString(),
        'base64': base64.toString(),
        'fileName': fileName
      };
      var resource = await _repository!.httpPost('upload-screen-shot', data);
      return jsonDecode(resource.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  closeATicket(int? ticketId) async {
    try {
      return await _repository!.httpGetById('close-a-ticket', ticketId);
    } catch (e) {
      print(e.toString());
    }
  }

  getOpenedTicketsByUserId(int? userId) async {
    try {
      return await _repository!
          .httpGetById('get-opened-tickets-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  getReOpenedTicketsByUserId(int? userId) async {
    try {
      return await _repository!
          .httpGetById('get-reopened-tickets-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  getResolvedTicketsByUserId(int? userId) async {
    try {
      return await _repository!
          .httpGetById('get-resolved-tickets-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  getUnResolvedTicketsByUserId(int? userId) async {
    try {
      return await _repository!
          .httpGetById('get-unresolved-tickets-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  reOpenATicket(int? ticketId) async {
    try {
      return await _repository!.httpGetById('reopen-a-ticket', ticketId);
    } catch (e) {
      print(e.toString());
    }
  }

  createTicketReply(TicketReply ticketReply) async {
    try {
      return await _repository!.httpPost('reply-ticket', ticketReply.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  uploadTicketReplyScreenshot(File imageFile, int? ticketReplyId) async {
    try {
      String base64 = base64Encode(imageFile.readAsBytesSync());
      String fileName = imageFile.path.split("/").last;

      var data = {
        'id': ticketReplyId.toString(),
        'base64': base64.toString(),
        'fileName': fileName
      };
      var resource =
          await _repository!.httpPost('upload-reply-ticket-screen-shot', data);
      return jsonDecode(resource.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  getTicketRepliesByTicketId(int? ticketId) async {
    try {
      return await _repository!
          .httpGetById('get-ticket-replies-by-ticket-id', ticketId);
    } catch (e) {
      print(e.toString());
    }
  }
}
