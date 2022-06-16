import 'package:m_ticket_app/models/notification.dart';
import 'package:m_ticket_app/repository/repository.dart';

class NotificationService {
  Repository? _repository;

  NotificationService() {
    _repository = Repository();
  }

  getUnreadNotificationsByUserId(int? userId) async {
    try {
      return await _repository!
          .httpGetById('get-unread-notifications-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  saveNotificationInfo(NotificationModel notification) async {
    try {
      return await _repository!
          .httpPost('notifications', notification.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  markAsRead(int? id) async {
    try {
      return await _repository!.httpGetById('mark-notification-as-read', id);
    } catch (e) {
      print(e.toString());
    }
  }

  getUnreadNotificationsByCategoryId(int? categoryId) async {
    try {
      return await _repository!
          .httpGetById('get-unread-notifications-by-category-id', categoryId);
    } catch (e) {
      print(e.toString());
    }
  }

  getAllUnreadNotifications() async {
    try {
      return await _repository!.httpGet('get-all-unread-notifications');
    } catch (e) {
      print(e.toString());
    }
  }
}
