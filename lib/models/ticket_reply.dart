class TicketReply {
  int? id;
  String? replyMessage;
  String? userType;
  String? userName;
  String? screenShotPath;
  int? ticketId;
  int? userId;

  toJson() {
    return {
      'id': id.toString(),
      'reply_message': replyMessage.toString(),
      'user_type': userType.toString(),
      'screen_shot_path': screenShotPath.toString(),
      'ticket_id': ticketId.toString(),
      'user_id': userId.toString(),
    };
  }
}
