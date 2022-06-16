// import 'dart:convert';
//
// import 'package:http/http.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:m_ticket_app/models/notification.dart';
//
// class PushNotificationService {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   static final Client _httpClient = Client();
//   final String serverKey =
//       "AAAAZgc6boo:APA91bH5K1Uv0D1Sd3PO_fQIt2nCh46_BHHtxdeHZyKsc6VNHJPNQ9ifqv3nVr2kKI5PT_EohT2qTUFBbd2RueezUX9p7YvwZDOHcvlT_FgpmG-ofdeTgseVWlfmvMYyEpi2BO8jqo8K";
//
//   sendCategoryBasedTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
//       NotificationModel notificationModel,
//       String? topic,
//       String? categoryId,
//       String? ticketId,
//       int? userId) async {
//     _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     _httpClient.post(Uri.https('fcm.googleapis.com', '/fcm/send'),
//         body: json.encode({
//           'notification': {
//             'body': '${notificationModel.notificationMessage}',
//             'title': '${notificationModel.notificationTitle}',
//           },
//           'priority': 'high',
//           'data': {
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': '1',
//             'status': 'done',
//             'ticket_id': ticketId,
//             'user_id': userId,
//           },
//           'to': '/topics/$topic-$categoryId',
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey'
//         });
//   }
//
//   void sendAllTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
//       NotificationModel notificationModel,
//       String? topic,
//       String? ticketId,
//       int? userId) async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     _httpClient.post(Uri.https('fcm.googleapis.com', '/fcm/send'),
//         body: json.encode({
//           'notification': {
//             'body': '${notificationModel.notificationMessage}',
//             'title': '${notificationModel.notificationTitle}',
//           },
//           'priority': 'high',
//           'data': {
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': '1',
//             'status': 'done',
//             'ticket_id': ticketId,
//             'user_id': userId,
//           },
//           'to': '/topics/$topic',
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey'
//         });
//   }
//
//   sendUserBasedTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
//       NotificationModel notificationModel,
//       String? topic,
//       String? ticketId,
//       int? userId) async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     _httpClient.post(Uri.https('fcm.googleapis.com', '/fcm/send'),
//         body: json.encode({
//           'notification': {
//             'body': '${notificationModel.notificationMessage}',
//             'title': '${notificationModel.notificationTitle}',
//           },
//           'priority': 'high',
//           'data': {
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': '1',
//             'status': 'done',
//             'ticket_id': ticketId,
//             'user_id': userId,
//           },
//           'to': '/topics/$topic',
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey'
//         });
//   }
//
//   sendUserBasedTicketAssignmentPushNotification(
//       NotificationModel notificationModel,
//       String? topic,
//       String? categoryId,
//       String? ticketId,
//       selectedStaffOrManager) async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     _httpClient.post(Uri.https('fcm.googleapis.com', '/fcm/send'),
//         body: json.encode({
//           'notification': {
//             'body': '${notificationModel.notificationMessage}',
//             'title': '${notificationModel.notificationTitle}',
//           },
//           'priority': 'high',
//           'data': {
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': '1',
//             'status': 'done',
//             'category_id': categoryId,
//             'ticket_id': ticketId,
//             'user_id': selectedStaffOrManager,
//           },
//           'to': '/topics/$topic-$selectedStaffOrManager',
//         }),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey'
//         });
//   }
// }
