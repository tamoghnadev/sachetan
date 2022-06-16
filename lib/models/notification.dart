class NotificationModel {
  int? id;
  int? notificationQuantity;
  String? type;
  String? notificationTitle;
  String? notificationMessage;
  int? notificationTypeId;
  int? isReadAdmin;
  int? isReadEmployee;
  int? isReadCustomer;
  String? senderUserId;
  String? sendToUserId;
  String? sendToCategoryId;
  String? category;
  String? priority;

  toJson() {
    return {
      'id': this.id.toString(),
      'notification_quantity': this.notificationQuantity.toString(),
      'notification_type': this.type.toString(),
      'notification_title': this.notificationTitle.toString(),
      'notification_message': this.notificationMessage.toString(),
      'notification_type_id': this.notificationTypeId.toString(),
      'send_to_category_id': this.sendToCategoryId.toString(),
      'sender_user_id': this.senderUserId.toString(),
      'send_to_user_id': this.sendToUserId.toString(),
      'is_read_admin': this.isReadAdmin.toString(),
      'is_read_employee': this.isReadEmployee.toString(),
      'is_read_customer': this.isReadCustomer.toString(),
    };
  }
}