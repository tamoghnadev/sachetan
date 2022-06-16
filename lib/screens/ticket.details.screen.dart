import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_ticket_app/helpers/helpers.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/notification.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/models/ticket_reply.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/services/notification_service.dart';
import 'package:m_ticket_app/services/push_notification_service.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer.dashboard.screen.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Ticket? ticket;
  final String? userType;
  TicketDetailsScreen({this.ticket, this.userType});

  @override
  _TicketDetailsScreenState createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  var _ticketService = TicketService();
  var _message = TextEditingController();
  List<Widget> _replyList = [];
  List<dynamic>scrnn = [];
  bool _isLoading = false;
  Widget? _screenShot;
  Widget? _replyScreenShot;
  Widget? _status;
  String? _ticketStatus = "";
  File? _image;
  String showImage = 'assets/screen-shot.png';
  final imagePicker = ImagePicker();

  bool _replyShowHide = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp

    ]);
    _status = this.widget.ticket!.status;
    _ticketStatus = this.widget.ticket!.ticketStatus;
    scrnn = this.widget.ticket!.reviews;
    if(scrnn.length!=0){
      scrnn.forEach((datas) {
        if (this.widget.ticket!.reviews != null &&
            this.widget.ticket!.reviews != '') {
          setState(() {
            _screenShot = CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: datas['file_name'],
              fit: BoxFit.cover,
              height: 165,
              width: 165,
            );
          });
        } else {
          setState(() {
            _screenShot = Image.asset(
              'assets/no-screen-shot.png',
              width: 100,
            );
          });
        }
      });
    }else{
      setState(() {
        _screenShot = Image.asset(
          'assets/no-screen-shot.png',
          width: 100,
        );
      });
    }



  }



  _getRepliesByTicketId(width) async {
    try {
      var _result = await _ticketService
          .getTicketRepliesByTicketId(this.widget.ticket!.id!);
      _replyList = [];
      print(_result.body);
      var replies = json.decode(_result.body);
      replies.forEach(
        (reply) {
          print('reply ticket ${reply['ticket']}');
          var _reply = TicketReply();
          _reply.replyMessage = reply['reply_message'];
          if (reply['user'] != null)
            _reply.userName = reply['user']['name'];
          else
            _reply.userName = 'No user found';
          _reply.userType = reply['user_type'];
          print('before check : ${reply['screen_shot_path']}');
          if (reply['screen_shot_path'] != null) {
            print('${reply['screen_shot_path']}');
            setState(() {
              _replyScreenShot = CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: reply['screen_shot_path'],
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              );
            });
          } else {
            _replyScreenShot = Image.asset(
              'assets/no-screen-shot.png',
              width: 100,
            );
          }

          _reply.ticketId = int.parse(reply['ticket_id'].toString());
          _reply.userId = int.parse(reply['user_id'].toString());
          _reply.id = int.parse(reply['id'].toString());

          setState(
            () {
              _replyList.add(
                Container(
                  width: width,
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _reply.userType == 'customer'
                              ? Container(
                                  height: 40,
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Customer reply ',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Replied by - ${_reply.userName}',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 40,
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${capitalize(_reply.userType ?? "")} reply ',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '${getTranslated(context, 'Replied By')} - ${_reply.userName}',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_reply.replyMessage}',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _replyScreenShot,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future _submitTicketReply(TicketReply ticketReply) async {
    try {
      return await _ticketService.createTicketReply(ticketReply);
    } catch (e) {
      return e.toString();
    }
  }

 /* _chooseImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }*/

  Widget _showImage() {
    if (_image != null) {
      return Image.file(_image!);
    } else {
      return Image.asset(
        showImage,
        width: 100,
        height: 100,
      );
    }
  }

  Future _uploadTicketReplyScreenshot(
      File? imageFile, int ticketReplyId) async {
    if (imageFile != null) {
      return await _ticketService.uploadTicketReplyScreenshot(
          imageFile, ticketReplyId);
    }
  }

  _showSuccessMessage(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 360.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/success.png'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reply Submitted Successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0, color: appColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showFailedMessage(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 360.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/failed.png')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reply Submit Failed',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _closeATicket(int? ticketId) async {
    try {
      return await _ticketService.closeATicket(ticketId!);
    } catch (e) {
      return e.toString();
    }
  }

  Future _reOpenATicket(int? ticketId) async {
    try {
      return await _ticketService.reOpenATicket(ticketId!);
    } catch (e) {
      return e.toString();
    }
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
                        if (action == 'Close') {
                          await _closeATicket(ticket.id).then((_) {
                            setState(() {
                              _status = Text(
                                'Closed',
                                style: TextStyle(color: Colors.green),
                              );
                              _isLoading = false;
                            });
                          });
                        } else {
                          await _reOpenATicket(ticket.id).then((_) {
                            setState(() {
                              _status = Text(
                                'ReOpened',
                                style: TextStyle(color: Colors.red),
                              );
                              _isLoading = false;
                            });
                          });
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
      },
    );
  }

  _showDataValidationMessage(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
            height: 360.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/failed.png')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Please fill all the fields and try again!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    if (_counter == 0) _getRepliesByTicketId(MediaQuery.of(context).size.width);
    _counter++;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title:
            Center(child: Text('Complaint Details')),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              if (_prefs.getString('type') == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDashboardScreen(),
                  ),
                );
              } else if (_prefs.getString('type') == 'employee') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeDashboardScreen(),
                  ),
                );
              } else if (_prefs.getString('type') == 'customer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDashboardScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDashboardScreen(),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(Icons.close),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "Subject : ${this.widget.ticket!.subject}",style: TextStyle(fontSize: 18,color: Colors.black),),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Priority :  ${this.widget.ticket?.priority}",style: TextStyle(fontSize: 18,color: Colors.black),),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Message :  ${this.widget.ticket?.message}",style: TextStyle(fontSize: 18,color: Colors.black),),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Status :  ${this.widget.ticket?.ticketStatus}",style: TextStyle(fontSize: 18,color: Colors.black),),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Text("Screen shot : "),
                          _screenShot!,
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          _ticketStatus == "resolved"
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ButtonTheme(
                                    minWidth: 60.0,
                                    height: 40.0,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        primary: Colors.red,
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        _confirm(
                                            context,
                                            this.widget.ticket!,
                                            'ReOpen',
                                            'Are you sure you want to Re Open this ticket?');
                                      },
                                      child: Text(
                                        'Re Open',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _ticketStatus != "resolved"
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ButtonTheme(
                                    minWidth: 60.0,
                                    height: 40.0,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        primary: appColor,
                                        backgroundColor: appColor,
                                      ),
                                      onPressed: () async {
                                        _confirm(
                                            context,
                                            this.widget.ticket!,
                                            'Close',
                                            'Are you sure you want to close resolved this ticket?');
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      _isLoading == false
                          ? Container()
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _replyList,
          ),
          Container(
              child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ButtonTheme(
                        minWidth: 60.0,
                        height: 40.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              primary: Colors.blue,
                              backgroundColor: Colors.blue),
                          onPressed: () async {
                            setState(() {
                              _replyShowHide = !_replyShowHide;
                            });
                          },
                          child: Text(
                            '${getTranslated(context, 'Reply')} ...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _replyShowHide == true
                      ? Column(
                          children: [
                            TextFormField(
                              controller: _message,
                              maxLines: 100,
                              minLines: 7,
                              decoration: InputDecoration(
                                  hintText:
                                      '${getTranslated(context, 'Write your message here')}',
                                  labelText:
                                      '${getTranslated(context, 'Message')}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: TextButton(
                                      onPressed: () {
                                        //_chooseImage();
                                      },
                                      child: GestureDetector(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.transparent,
                                          child: _showImage(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ButtonTheme(
                                minWidth: 400.0,
                                height: 45.0,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      primary: appColor,
                                      backgroundColor: appColor),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    SharedPreferences _prefs =
                                        await SharedPreferences.getInstance();
                                    int? userId = _prefs.getInt('userId');

                                    if (userId != null) {
                                      if (_message.text == '') {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        _showDataValidationMessage(context);
                                      } else {
                                        var _ticketReply = TicketReply();
                                        _ticketReply.replyMessage =
                                            _message.text;
                                        _ticketReply.ticketId =
                                            this.widget.ticket!.id;
                                        _ticketReply.userType =
                                            _prefs.getString('type');
                                        _ticketReply.userId =
                                            _prefs.getInt('userId');
                                        try {
                                          await _submitTicketReply(_ticketReply)
                                              .then((data) {
                                            var _data = json.decode(data.body);
                                            if (_data['id'] != null &&
                                                _data['id'] != '') {
                                              if (_image != null) {
                                                _uploadTicketReplyScreenshot(
                                                        _image!, _data['id'])
                                                    .then((_) {});
                                              }

                                              // _updateNotificationAndSendPushNotification(
                                              //     _ticketReply,
                                              //     this.widget.ticket);

                                              setState(() {
                                                _isLoading = false;
                                              });
                                              _message.text = "";
                                              _showSuccessMessage(context);
                                              Timer(Duration(seconds: 3), () {
                                                _getRepliesByTicketId(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width);
                                                Navigator.pop(context);
                                              });
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              _showFailedMessage(context);
                                            }
                                          });
                                        } catch (e) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          _showFailedMessage(context);
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    '${getTranslated(context, 'Submit Reply')}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  // void _updateNotificationAndSendPushNotification(
  //     TicketReply ticketReply, Ticket? ticket) async {
  //   try {
  //     final _pushNotificationService = PushNotificationService();
  //
  //     final _notificationService = NotificationService();
  //
  //     NotificationModel _notificationModel = NotificationModel();
  //
  //     _pushNotificationService
  //         .sendCategoryBasedTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
  //             _notificationModel,
  //             'ticket-replied-category-',
  //             ticket!.categoryId.toString(),
  //             ticket.id.toString(),
  //             ticket.userId);
  //
  //     _pushNotificationService
  //         .sendAllTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
  //             _notificationModel,
  //             'ticket-replied',
  //             ticket.id.toString(),
  //             ticket.userId);
  //
  //     _pushNotificationService
  //         .sendUserBasedTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
  //             _notificationModel,
  //             'ticket-replied-${ticket.userId}',
  //             ticket.id.toString(),
  //             ticket.userId);
  //
  //     _notificationModel.notificationQuantity = 1;
  //     _notificationModel.type = 'ticket-replied';
  //     _notificationModel.notificationTitle = 'Ticket Updated';
  //     _notificationModel.notificationMessage =
  //         'A ticket updated - ${ticketReply.replyMessage}';
  //     _notificationModel.notificationTypeId = this.widget.ticket!.id;
  //     _notificationModel.senderUserId = ticketReply.userId.toString();
  //     _notificationModel.sendToUserId = ticket.userId.toString();
  //     _notificationModel.sendToCategoryId = ticket.categoryId.toString();
  //     _notificationModel.isReadAdmin = 0;
  //     await _notificationService.saveNotificationInfo(_notificationModel);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
