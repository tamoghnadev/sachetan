import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/providers/ad_state.dart';
import 'package:m_ticket_app/screens/create.ticket.screen.dart';
import 'package:m_ticket_app/screens/ticket.details.screen.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenedTicketsByCategoryScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  OpenedTicketsByCategoryScreen({this.categoryId, this.categoryName});

  @override
  _OpenedTicketsByCategoryScreenState createState() =>
      _OpenedTicketsByCategoryScreenState();
}

class _OpenedTicketsByCategoryScreenState
    extends State<OpenedTicketsByCategoryScreen> {
  SharedPreferences? _prefs;
  var _ticketService = TicketService();
  var ticket = Ticket();
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  bool _isCustomer = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp


    ]);
    _getAllOpenedTicketsByCategory();
  }

  _getAllOpenedTicketsByCategory() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (_prefs!.getString('type') == 'customer') {
        setState(() {
          _isCustomer = true;
        });
      }
      var _ticketService = TicketService();
      _tickets = [];
      var result = await _ticketService.getOpenedTicketsByCategoryIdAndUserId(
          _prefs!.getInt('userId'));
      var tickets = json.decode(result.body);
      print("Ticket Body "+result.body.toString());
      tickets.forEach((data) {
        var ticket = Ticket();

        ticket.id = data['id'];
        ticket.subject = data['subject'];
        ticket.message = data['message'];
        ticket.priority ='High';// data['priority'];
        final DateTime creat = DateTime.parse(data['created_at']);
        final DateFormat formatter = DateFormat('dd MMM, yy');
        final String formatted = formatter.format(creat);
        ticket.created_at = formatted;
        ticket.reviews = data['screen_shot_path'];
        ticket.userId = 0;
        if(data['is_opened']==1){
          ticket.ticketStatus = 'Opened';
          ticket.color = Text('Status: Opened',style: TextStyle(fontSize: 18,color: Color(
              0xFF265CE6)));
        }else if(data['is_reopened']==1){
          ticket.ticketStatus = 'Re-Opened';
          ticket.color = Text('Status: Re-Opened',style: TextStyle(fontSize: 18,color: Color(0xFFDE160C)));
        }else if(data['is_closed_resolved']==1){
          ticket.ticketStatus = 'Resolved';
          ticket.color = Text('Status: Resolved',style: TextStyle(fontSize: 18,color: Color(0xFF1FEC34)));
        }else if(data['is_closed_unresolved']==1){
          ticket.ticketStatus = 'Closed but Unresolved';
          ticket.color = Text('Status: Closed but Unresolved',style: TextStyle(fontSize: 18,color: Color(0xFFFFC300)));
        }
        if (data['user_id'] != null && data['user_id'] != '')
          ticket.userId = int.parse(data['user_id'].toString());

        ticket.categoryId = 0;
        if (data['category_id'] != null && data['category_id'] != '')
          ticket.categoryId = int.parse(data['category_id'].toString());



        setState(() {
          _tickets.add(ticket);
        });
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
      return e.toString();
    }
  }

  Future _closeAnOpenedTicket(int? ticketId) async {
    try {
      _prefs = await SharedPreferences.getInstance();
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
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12),
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
                              'Show Details',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
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
                    'What do you want to do?',
                    style: TextStyle(fontSize: 20.0),
                  ),
                )),
          );
        });
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
                              await _closeAnOpenedTicket(ticket.id).then((_) {
                                _getAllOpenedTicketsByCategory();
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
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //final adState = Provider.of<AdState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text('Track the Complaints'),
        actions: <Widget>[
          _isCustomer == true
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTicketScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Icon(Icons.add),
                  ),
                )
              : Text(''),
        ],
      ),
      body:ListView.builder(
          itemCount: _tickets.length,
        itemBuilder: (BuildContext context,int index){
                 return Card(
                   child: InkWell(
                     onTap: () {
                       _showAlertMessage(context, _tickets[index]);
                     },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                            padding: const EdgeInsets.only(top: 18.0,bottom: 5),
                            child: Text('Ticket Id:   '+_tickets[index].id.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                          ),

          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0,bottom: 5),
                            child: Text('Ticket Subject:   '+_tickets[index].subject.toString(),style: TextStyle(fontSize: 18,color: Colors.black),overflow: TextOverflow.ellipsis,),
                          ),

          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5),
                              child: Text('Date:   '+_tickets[index].created_at.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                            ),

                          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 25),
                              child: _tickets[index].color,
                            ),

                          ),
                        ),

                        ],

                  ),


)
          );

        }
      ),
    );
  }
}
