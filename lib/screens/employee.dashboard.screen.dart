import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/drawer_navigation.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/screens/ticket.details.screen.dart';
import 'package:m_ticket_app/screens/notifications_screen.dart';
import 'package:m_ticket_app/services/notification_service.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  @override
  _EmployeeDashboardScreenState createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  SharedPreferences? _prefs;
  var _ticketService = TicketService();

  List<Ticket> _tickets = [];
  bool _isLoading = true;
  int _notificationQuantity = 0;

  @override
  void initState() {
    super.initState();
    _getAllTickets();
    //_initializeNotification();
    _getUnreadNotificationsByCategoryId();
  }

  // Future _initializeNotification() async {
  //   try {
  //     _prefs = await SharedPreferences.getInstance();
  //     final _firebaseMessaging = FirebaseMessaging.instance;
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
  //     _firebaseMessaging.subscribeToTopic(
  //         'ticket-opened-category-${_prefs!.getInt('categoryId')}');
  //     _firebaseMessaging.subscribeToTopic(
  //         'ticket-re-opened-category-${_prefs!.getInt('categoryId')}');
  //     _firebaseMessaging.subscribeToTopic(
  //         'ticket-unresolved-category-${_prefs!.getInt('categoryId')}');
  //     _firebaseMessaging.subscribeToTopic(
  //         'ticket-resolved-category-${_prefs!.getInt('categoryId')}');
  //     _firebaseMessaging.subscribeToTopic(
  //         'ticket-replied-category-${_prefs!.getInt('categoryId')}');
  //
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       setState(() {
  //         _notificationQuantity += 1;
  //       });
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  _getUnreadNotificationsByCategoryId() async {
    try {
      _notificationQuantity = 0;
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      final _notificationService = NotificationService();
      var response = await _notificationService
          .getUnreadNotificationsByCategoryId(_prefs.getInt('categoryId'));
      var _notifications = json.decode(response.body);
      _notifications['notifications'].forEach((notification) {
        setState(() {
          _notificationQuantity +=
              int.parse(notification['notification_quantity'].toString());
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _getAllTickets() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var result =
          await _ticketService.getTicketsByUserId(_prefs!.getInt('userId'));
      var tickets = json.decode(result.body);
      _tickets = [];
      tickets.forEach((data) {
        var ticket = Ticket();
        Widget? status;

        if (data['is_opened'] == 1 || data['is_opened'] == '1') {
          setState(() {
            status = Text(
              'Opened',
              style: TextStyle(color: Colors.red),
            );
          });
        } else if (data['is_reopened'] == 1 || data['is_reopened'] == '1') {
          setState(() {
            status = Text(
              'ReOpened',
              style: TextStyle(color: Colors.red),
            );
          });
        } else if (data['is_closed_resolved'] == 1 ||
            data['is_closed_resolved'] == '1') {
          setState(() {
            status = Text(
              'Resolved',
              style: TextStyle(color: appColor),
            );
          });
        } else if (data['is_closed_unresolved'] == 1 ||
            data['is_closed_unresolved'] == '1') {
          setState(() {
            status = Text(
              'UnResolved',
              style: TextStyle(color: Colors.yellow),
            );
          });
        }
        ticket.id = data['id'];
        ticket.subject = data['subject'];
        ticket.priority = data['priority'];
        ticket.status = status;
        ticket.screenShotPath = data['screen_shot_path'];
        ticket.message = data['message'];
        ticket.userId = 0;
        if (data['user_id'] != null && data['user_id'] != '')
          ticket.userId = int.parse(data['user_id'].toString());

        ticket.categoryId = 0;
        if (data['category_id'] != null && data['category_id'] != '')
          ticket.categoryId = int.parse(data['category_id'].toString());

        if (data['category'] != null)
          ticket.category = data['category']['name'];
        else
          ticket.category = 'No category';
        setState(() {
          _tickets.add(ticket);
        });
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return e.toString();
    }
  }

  Future _closeATicket(int? ticketId) async {
    try {
      return await _ticketService.closeATicket(ticketId!);
    } catch (e) {
      return e.toString();
    }
  }

  _showAlertMessage(BuildContext context, Ticket ticket) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ButtonTheme(
                    minWidth: 20.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '${getTranslated(context, 'Cancel')}',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ButtonTheme(
                        minWidth: 20.0,
                        height: 40.0,
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            _confirm(
                                context,
                                ticket,
                                '${getTranslated(context, 'Close')}',
                                '${getTranslated(context, 'Are you sure you want to close resolved this ticket')}?');
                          },
                          child: Text(
                            '${getTranslated(context, 'Close')}',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ButtonTheme(
                        minWidth: 20.0,
                        height: 40.0,
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TicketDetailsScreen(ticket: ticket),
                              ),
                            );
                          },
                          child: Text(
                            '${getTranslated(context, 'Show Details')}',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                '${getTranslated(context, 'What do you want to do')}?',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        );
      },
    );
  }

  _confirm(BuildContext context, Ticket ticket, String action, String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    minWidth: 30.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '${getTranslated(context, 'Cancel')}',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    minWidth: 40.0,
                    height: 40.0,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          if (action == 'Close') {
                            await _closeATicket(ticket.id).then((_) {
                              _getAllTickets();
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TicketDetailsScreen(ticket: ticket)));
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Text(
                        '${getTranslated(context, 'Yes')}',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: true,
        title: Text('M Ticket - Employee Dashboard'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 150,
                width: 30,
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      child: Stack(
                        children: <Widget>[
                          Icon(Icons.brightness_1,
                              size: 25, color: Colors.black),
                          Positioned(
                            top: 4.0,
                            right: 8.0,
                            child: Center(
                                child: Text(_notificationQuantity.toString())),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _isLoading == false
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text('${getTranslated(context, 'Subject')}')),
                      DataColumn(
                          label: Text('${getTranslated(context, 'Priority')}')),
                      DataColumn(
                          label: Text('${getTranslated(context, 'Status')}')),
                    ],
                    rows: _tickets
                        .map((ticket) => DataRow(cells: [
                              DataCell(InkWell(
                                  onLongPress: () {
                                    _showAlertMessage(context, ticket);
                                  },
                                  child: Text(ticket.subject!))),
                              DataCell(InkWell(
                                  onLongPress: () {
                                    _showAlertMessage(context, ticket);
                                  },
                                  child: Text(ticket.priority!))),
                              DataCell(InkWell(
                                  onLongPress: () {
                                    _showAlertMessage(context, ticket);
                                  },
                                  child: ticket.status)),
                            ]))
                        .toList(),
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
