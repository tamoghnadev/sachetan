import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/notification.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  SharedPreferences? _preferences;
  final _notificationService = NotificationService();
  bool _isLoading = true;
  List<NotificationModel> _notificationList = [];

  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  _getNotifications() async {
    try {
      _preferences = await SharedPreferences.getInstance();

      if (_preferences!.getInt('userId') != 0 &&
          _preferences!.getInt('userId') != null) {
        var response = await _notificationService
            .getUnreadNotificationsByUserId(_preferences!.getInt('userId'));
        var notifications = json.decode(response.body);
        _notificationList = [];

        notifications['notifications'].forEach((notification) {
          print(notification['ticket']['category']);
          var _notification = NotificationModel();
          _notification.id = int.parse(notification['id'].toString());
          _notification.type = notification['notification_type'];
          _notification.priority = notification['ticket']['priority'];
          _notification.notificationTitle = notification['notification_title'];
          _notification.notificationMessage =
              notification['notification_message'];
          _notification.notificationQuantity =
              int.parse(notification['notification_quantity'].toString());
          _notification.notificationTypeId =
              int.parse(notification['notification_type_id'].toString());
          _notification.senderUserId =
              notification['sender_user_id'].toString();
          _notification.sendToUserId =
              notification['send_to_user_id'].toString();
          _notification.sendToCategoryId =
              notification['send_to_category_id'].toString();
          _notification.category =
              notification['ticket']['category']['name'].toString();

          setState(() {
            _notificationList.add(_notification);
          });
        });

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            print('user type : ${_prefs.getString('type')}');
            if (_prefs.getString('type') == 'admin') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboardScreen(),
                ),
              );
            } else if (_prefs.getString('type') == 'customer') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerDashboardScreen(),
                ),
              );
            } else if (_prefs.getString('type') == 'employee') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeDashboardScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              );
            }
          },
        ),
        title: Text('${getTranslated(context, 'Notifications')}'),
      ),
      body: _isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              Text(
                                '${getTranslated(context, 'Priority')} : ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                              Text(
                                '${_notificationList[index].priority}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              Text(
                                '${getTranslated(context, 'Status')} : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                '${_notificationList[index].notificationTitle}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              Text(
                                '${getTranslated(context, 'Category')} : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                '${_notificationList[index].category}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _notificationList.length,
            ),
    );
  }
}
