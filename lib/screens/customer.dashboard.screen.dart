import 'dart:convert';
import 'dart:io';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_ticket_app/helpers/drawer_navigation.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:m_ticket_app/models/category.dart';
import 'package:m_ticket_app/screens/create.ticket.geotag.screen.dart';
import 'package:m_ticket_app/screens/create.ticket.screen.dart';
import 'package:m_ticket_app/screens/notifications_screen.dart';
import 'package:m_ticket_app/screens/opened.tickets.by.category.screen.dart';
import 'package:m_ticket_app/screens/rewards.screen.dart';
import 'package:m_ticket_app/services/category.service.dart';
import 'package:m_ticket_app/providers/ad_state.dart';
import 'package:m_ticket_app/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/languages_services.dart';
import 'languages_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  @override
  _CustomerDashboardScreenState createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final _notificationService = NotificationService();
  List<Category>? _categoryList;
  SharedPreferences? _prefs;
  var buttonss = <Map>[];
  bool isSwitched = false;
  List<DropdownMenuItem> _langa = [];
  var lancode;
  Orientation? _orientation;
  bool _isLoading = false;
  final List<String> imageList = ["https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'];
  int _notificationQuantity = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp


    ]);
    _getCategories();
    _getNotifications();
    _getLanguages();
    //_initializeNotification();
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
  //     _firebaseMessaging
  //         .subscribeToTopic('ticket-opened-${_prefs!.getInt('userId')}');
  //     _firebaseMessaging
  //         .subscribeToTopic('ticket-re-opened-${_prefs!.getInt('userId')}');
  //     _firebaseMessaging
  //         .subscribeToTopic('ticket-unresolved-${_prefs!.getInt('userId')}');
  //     _firebaseMessaging
  //         .subscribeToTopic('ticket-resolved-${_prefs!.getInt('userId')}');
  //     _firebaseMessaging
  //         .subscribeToTopic('ticket-replied-${_prefs!.getInt('userId')}');
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
  _getLanguages() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _languagesService = LanguagesService();
      var result = await _languagesService.getLanguagesByMemberId(_prefs!.getInt('userId'));
      print("Lalla"+result.body.toString());
      var categoriesL = json.decode(result.body);
      categoriesL.forEach((language) {
        setState(() {
          _langa.add(DropdownMenuItem(
            child: Text(language['name']),
            value: language['id'],
          ));
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
  _getCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _prefs = await SharedPreferences.getInstance();

      var _categoryService = CategoryService();
      var result = await _categoryService
          .getCategoriesWithOpenedTicketsByUserId(_prefs!.getInt('userId'));
      var categories = json.decode(result.body);
      _categoryList = [];
      categories.forEach((category) {
        if (_categoryList!.length > 0 && _categoryList!.length % 3 == 0) {
          _categoryList!.add(Category());
        }
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

  _getNotifications() async {
    try {
      _notificationQuantity = 0;
      _prefs = await SharedPreferences.getInstance();

      var response = await _notificationService
          .getUnreadNotificationsByUserId(_prefs!.getInt('userId'));
      var notifications = json.decode(response.body);
      notifications['notifications'].forEach((notification) {
        setState(() {
          _notificationQuantity +=
              int.parse(notification['notification_quantity'].toString());
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> _onBackPressed() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Are you sure?"),
        content:
            new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => exit(0),
            child: Text("YES"),
          ),
        ],
      ),
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
   /* buttonss.add({ 'Name'  : 'Lodge Complaint','Color' : Color(0xFFffffff)});
    buttonss.add({ 'Name'  : 'Geo Tag Properties','Color' : Color(0xFFffffff)});
    buttonss.add({ 'Name'  : 'Track Complaint','Color' : Color(0xFFffffff)});
    buttonss.add({ 'Name'  : 'My Rewards','Color' : Color(0xFFffffff)});*/
    return WillPopScope(
      onWillPop: _onBackPressed,

      child: SafeArea(

        child: Scaffold(

          resizeToAvoidBottomInset : false,
          appBar: AppBar(
            backgroundColor: appColor,
            title: Center(child: Text('Sachetan')),
            actions: <Widget>[
               new IconButton(
                icon: new Icon(FontAwesomeIcons.language, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (context) => new LanguagesScreen(),
                    ),
                  );
                },
              ),

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
                                    child:
                                        Text(_notificationQuantity.toString())),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

             /* InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateTicketScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Icon(Icons.add),
                ),
              )*/
            ],
          ),
          drawer: DrawerNavigation(),
          body: _isLoading == false

              ?
          SingleChildScrollView(

              child: Container(
            color: Color(0xFFf7f7f7),
             height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,

                  child: Column(
                    children: [
                       //new Text("ACB News",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 48.0, bottom: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("ACB News",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xFF255c92),)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),

                        child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(5.0),

                          child: ListView(
                            children: [
                              Card(
                                  color: Color(0xFFf7f7f7),
                                  child: ListTile(
                                    title:Text("State Govt. Notification of ACB, PS, No. 2208 PS Cell dt. 14.11.2012",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),) ,
                                    hoverColor: Colors.white,

                                  )
                              ),
                              Card(
                                color: Color(0xFFf7f7f7),
                                child: ListTile(
                                  title: Text("State Govt. Notification of ACB, PS, No. 2208 PS Cell dt. 14.11.2012",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Card(
                                  color: Color(0xFFf7f7f7),
                                  child: ListTile(
                                    title: Text("State Govt. Notification of ACB, PS, No. 2208 PS Cell dt. 14.11.2012",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  )
                              ),
                            ],
                            shrinkWrap: true,
                          )
                        ), //Container
                      ),
                      /*ListView.builder
                        (
                          itemCount: litems.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return new Text(litems[index]);
                          }
                      ),*/
                      /*CarouselSlider.builder(
                        itemCount: imageList.length,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          height: 200,
                           autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          reverse: false,
                          aspectRatio: 5.0,
                        ),
                        itemBuilder: (context, i, id){
                          //for onTap to redirect to another screen
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white,)
                              ),
                              //ClipRRect for image border radius
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  imageList[i],
                                  width: 500,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: (){
                              var url = imageList[i];
                              print(url.toString());
                            },
                          );
                        },
                      ),*/
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),

                child: Container(
                  color: Color(0xFFf7f7f7),
                  child:GridView.count(
                    crossAxisCount: 2,
                    children:[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateTicketScreen()));
                        },
                        child:Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xFFffffff),
                          ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icon1.png',
                              width: 64,
                              height: 64,
                            ),
                            Text("Lodge Complaint", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))
                          ],
                        ),
                      ),
          ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreateTicketGeotagScreen()));
                        },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFffffff),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icon3.png',
                              width: 64,
                              height: 64,
                            ),
                            Text("Geo Tag Properties", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))
                          ],
                        ),
                      ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OpenedTicketsByCategoryScreen()));
                        },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFffffff),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icon2.png',
                              width: 64,
                              height: 64,
                            ),
                            Text("Track Complaint",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))
                          ],

                        ),

                      ),
        ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RewardsScreen()));
                  },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xFFffffff),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              'assets/icon4.png',
                              width: 64,
                              height: 64,
                            ),
                            Text("My Rewards", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))
                          ],
                        ),
                      ),
                ),
                    ],
                    padding: EdgeInsets.all(15),
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  )
                ),
                 //Container
              ),


                        /*Expanded(
                        child: GridView.builder(
                          itemCount: _categoryList!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      _orientation == Orientation.portrait
                                          ? 2
                                          : 2),
                          itemBuilder: (context, index) {
                            if (index != 0 && index % 3 == 0) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Card(
                                  shape: Border(
                                    right:
                                        BorderSide(color: appColor, width: 5),
                                  ),
                                  elevation: 0.4,
                                  child: Container() *//*AdWidget(
                                    ad: BannerAd(
                                      adUnitId: adState.bannerAdUnitId,
                                      size: AdSize.mediumRectangle,
                                      request: AdRequest(),
                                      listener: adState.adListner,
                                    )..load(),
                                  ),*//*
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Card(
                                  elevation: 4,
                                  shape: Border(
                                    right:
                                        BorderSide(color: appColor, width: 5),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OpenedTicketsByCategoryScreen(
                                            categoryId:
                                                _categoryList![index].id,
                                            categoryName:
                                                _categoryList![index].name,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),*/
                      // Container(
                      //   height: 50,
                      //   child: AdWidget(
                      //       ad: BannerAd(
                      //           adUnitId: adState.bannerAdUnitId,
                      //           size: AdSize.fullBanner,
                      //           request: AdRequest(),
                      //           listener: adState.adListner)
                      //         ..load()),
                      // ),
                    ],
                  ),

                )
        )

              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
  _changeText() {
    /*setState(() {
      if (msg.startsWith('F')) {
        msg = 'We have learned FlutterRaised button example.';
      } else {
        msg = 'Flutter RaisedButton Example';
      }
    });*/
  }
}
