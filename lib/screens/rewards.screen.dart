import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/reward.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/providers/ad_state.dart';
import 'package:m_ticket_app/screens/create.ticket.screen.dart';
import 'package:m_ticket_app/screens/ticket.details.screen.dart';
import 'package:m_ticket_app/services/rewards.service.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsScreen extends StatefulWidget {
 /* final int? categoryId;
  final String? categoryName;
  RewardsScreen({this.categoryId, this.categoryName});*/

  @override
  _RewardsScreenState createState() =>
      _RewardsScreenState();
}

class _RewardsScreenState
    extends State<RewardsScreen> {
  SharedPreferences? _prefs;
  var _ticketService = TicketService();
  List<Reward> _tickets = [];
  bool _isLoading = false;

  bool _isCustomer = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp

    ]);
    _getAllRewards();
  }

  _getAllRewards() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (_prefs!.getString('type') == 'customer') {
        setState(() {
          _isCustomer = true;
        });
      }
      var _ticketService = RewardService();
      _tickets = [];
      var result = await _ticketService.getRewardsById(
          _prefs!.getInt('userId'));
      var tickets = json.decode(result.body);
      print("Ticket Body "+result.body.toString());
      tickets.forEach((data) {
        var ticket = Reward();

        ticket.id = data['id'];
        ticket.receipt_num = data['receipt_no'];
        ticket.gist = data['gist'];
        ticket.amount =data['amount'];// data['priority'];
        final DateTime creat = DateTime.parse(data['created_at']);
        final DateFormat formatter = DateFormat('dd MMM, yy');
        final String formatted = formatter.format(creat);
        ticket.datte = formatted;

        if (data['user_id'] != null && data['user_id'] != '')
          ticket.userId = int.parse(data['user_id'].toString());


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

  /*_showAlertMessage(BuildContext context, Reward ticket) {
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
  }*/

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
                               // _getAllOpenedTicketsByCategory();
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
        title: Text('Track the Rewards'),
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
      body: ListView.builder(
          itemCount: _tickets.length,
          itemBuilder: (BuildContext context,int index){
            return Card(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18.0,bottom: 5),
                            child: Text('Reward Id:   '+_tickets[index].id.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                          ),

                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0,bottom: 5),
                            child: Text('Receipt No. of Complaint:   '+_tickets[index].receipt_num.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                          ),

                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0,bottom: 5),
                            child: Text('Gist:   '+_tickets[index].gist.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                          ),

                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0,bottom: 25),
                                child: Text('Date:   '+_tickets[index].datte.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),
                              ),

                            ),
                          ),
                          Container(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0,bottom: 25,left: 85),
                                child: Text('Amount:   '+_tickets[index].amount.toString()+'/-',style: TextStyle(fontSize: 18,color: Colors.black),),
                              ),

                            ),
                          ),

                          ],

                      ),
                    ],

                  ),



            );

          }
      ),
    );
  }
}
