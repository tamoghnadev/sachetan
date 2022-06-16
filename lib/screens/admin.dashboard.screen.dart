import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/drawer_navigation.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/category.dart';
import 'package:m_ticket_app/screens/notifications_screen.dart';
import 'package:m_ticket_app/screens/opened.tickets.by.category.screen.dart';
import 'package:m_ticket_app/services/category.service.dart';
import 'package:m_ticket_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Category>? _categoryList;
  SharedPreferences? _prefs;
  Orientation? _orientation;
  int? _userId = 0;
  bool _isLoading = false;

  int _notificationQuantity = 0;

  @override
  void initState() {
    super.initState();
    _getCategories();
    //_initializeNotification();
    _getAllUnreadNotifications();
  }

  // _initializeNotification() async {
  //   try {
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
  //     await FirebaseMessaging.instance.subscribeToTopic('ticket-opened');
  //     await FirebaseMessaging.instance.subscribeToTopic('ticket-re-opened');
  //     await FirebaseMessaging.instance.subscribeToTopic('ticket-unresolved');
  //     await FirebaseMessaging.instance.subscribeToTopic('ticket-resolved');
  //     await FirebaseMessaging.instance.subscribeToTopic('ticket-replied');
  //
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       setState(() {
  //         _notificationQuantity += 1;
  //       });
  //     });
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  _getAllUnreadNotifications() async {
    try {
      _notificationQuantity = 0;
      final _notificationService = NotificationService();
      var response = await _notificationService.getAllUnreadNotifications();
      var _notifications = json.decode(response.body);

      setState(() {
        _notificationQuantity = _notifications['notifications'].length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _getCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _prefs = await SharedPreferences.getInstance();
      setState(() {
        _userId = _prefs!.getInt('userId');
      });

      var _categoryService = CategoryService();
      var result = await _categoryService
          .getCategoriesWithOpenedTicketsByUserId(_userId);
      var categories = json.decode(result.body);
      _categoryList = [];
      categories.forEach((category) {
        var _category = Category();
        _category.id = category['id'];
        _category.name = category['name'];
        _category.tickets = category['tickets'];
        setState(() {
          _categoryList!.add(_category);
        });
      });
      setState(() {
        _isLoading = false;
      });
    } catch (exception) {
      return exception.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Center(
          child: Text('M-Ticket - Admin'),
        ),
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
      drawer: DrawerNavigation(),
      body: _isLoading == false
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                itemCount: _categoryList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        _orientation == Orientation.portrait ? 2 : 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      elevation: 4,
                      shape:
                          Border(right: BorderSide(color: appColor, width: 5)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OpenedTicketsByCategoryScreen(
                                        categoryId: _categoryList![index].id,
                                        categoryName:
                                            _categoryList![index].name,
                                      )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                _categoryList![index].name!,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                            Center(
                                child: Text(
                              '${getTranslated(context, 'Opened Tickets')} : ${_categoryList![index].tickets.toString()}',
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
