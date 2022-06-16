import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/create.ticket.screen.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/signin.screen.dart';
import 'package:m_ticket_app/screens/ticket.details.screen.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenedTicketsScreen extends StatefulWidget {
  @override
  _OpenedTicketsScreenState createState() => _OpenedTicketsScreenState();
}

class _OpenedTicketsScreenState extends State<OpenedTicketsScreen> {
  SharedPreferences? _prefs;
  var _ticketService = TicketService();

  List<Ticket> _tickets = [];
  bool _isLoading = true;

  bool _isCustomer = false;

  @override
  void initState() {
    super.initState();
    _getOpenedTickets();
  }

  _getOpenedTickets() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (_prefs!.getString('type') == 'customer') {
        setState(() {
          _isCustomer = true;
        });
      }
      var result = await _ticketService
          .getOpenedTicketsByUserId(_prefs!.getInt('userId'));
      var tickets = json.decode(result.body);
      _tickets = [];
      tickets.forEach((data) {
        var ticket = Ticket();
        ticket.id = data['id'];
        ticket.subject = data['subject'];
        ticket.priority = data['priority'];
        ticket.status = Text(
          'Opened',
          style: TextStyle(color: Colors.red),
        );
        ticket.screenShotPath = data['screen_shot_path'];
        ticket.message = data['message'];
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              '${getTranslated(context, 'Show Details')}',
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
                    '${getTranslated(context, 'What do you want to do')}?',
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
                              await _closeATicket(ticket.id).then((_) {
                                _getOpenedTickets();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        leading: InkWell(
            onTap: () async {
              _prefs = await SharedPreferences.getInstance();

              if (_prefs!.getString('token') != '' &&
                  _prefs!.getString('token') != null) {
                if (_prefs!.getString('type') == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboardScreen(),
                    ),
                  );
                } else if (_prefs!.getString('type') == 'customer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDashboardScreen(),
                    ),
                  );
                } else if (_prefs!.getString('type') == 'employee') {
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
              }
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text('${getTranslated(context, 'Opened Tickets')}'),
        actions: <Widget>[
          _isCustomer == true
              ? InkWell(
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
                )
              : Text('')
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
                                  onLongPress: () {},
                                  child: Text(ticket.priority!))),
                              DataCell(InkWell(
                                  onLongPress: () {}, child: ticket.status)),
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
