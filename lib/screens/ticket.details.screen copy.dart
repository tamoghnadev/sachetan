// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:m_ticket_app/helpers/helpers.dart';
// import 'package:m_ticket_app/helpers/localization.dart';
// import 'package:m_ticket_app/helpers/theme_settings.dart';
// import 'package:m_ticket_app/models/notification.dart';
// import 'package:m_ticket_app/models/ticket.dart';
// import 'package:m_ticket_app/models/ticket_reply.dart';
// import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
// import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
// import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
// import 'package:m_ticket_app/services/notification_service.dart';
// import 'package:m_ticket_app/services/push_notification_service.dart';
// import 'package:m_ticket_app/services/ticket.service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TicketDetailsScreen extends StatefulWidget {
//   final Ticket? ticket;

//   TicketDetailsScreen({this.ticket});

//   @override
//   _TicketDetailsScreenState createState() => _TicketDetailsScreenState();
// }

// class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
//   var _ticketService = TicketService();
//   var _message = TextEditingController();
//   List<Widget> _replyList = [];
//   SharedPreferences? _prefs;
//   bool _isLoading = false;
//   Widget? _screenShot;
//   Widget? _replyScreenShot;
//   Widget? _status;
//   File? _image;
//   String showImage = 'assets/screen-shot.png';
//   final imagePicker = ImagePicker();

//   bool _replyShowHide = false;

//   @override
//   void initState() {
//     super.initState();
//     print('ticket data :${widget.ticket!.screenShotPath}');
//     print('ticket data :${widget.ticket!.id}');
//     _status = this.widget.ticket!.status;
//     if (this.widget.ticket!.screenShotPath != null &&
//         this.widget.ticket!.screenShotPath != '') {
//       setState(() {
//         _screenShot = CachedNetworkImage(
//           placeholder: (context, url) => CircularProgressIndicator(),
//           imageUrl: this.widget.ticket!.screenShotPath!,
//           fit: BoxFit.cover,
//           height: 200,
//           width: 200,
//         );
//       });
//     } else {
//       setState(() {
//         _screenShot = Image.asset(
//           'assets/no-screen-shot.png',
//           width: 200,
//         );
//       });
//     }
//   }

//   _getRepliesByTicketId(width) async {
//     _prefs = await SharedPreferences.getInstance();
//     var _result =
//         await _ticketService.getTicketRepliesByTicketId(this.widget.ticket!.id!);
//     _replyList = [];
//     var replies = json.decode(_result.body);
//     replies.forEach((reply) {
//       var _reply = TicketReply();
//       _reply.replyMessage = reply['reply_message'];
//       if (reply['user'] != null)
//         _reply.userName = reply['user']['name'];
//       else
//         _reply.userName = 'No user found';
//       _reply.userType = reply['user_type'];
//       if (reply['screen_shot_path'] != null) {
//         setState(() {
//           _replyScreenShot = CachedNetworkImage(
//             placeholder: (context, url) => CircularProgressIndicator(),
//             imageUrl: reply['screen_shot_path'],
//             fit: BoxFit.cover,
//             height: 200,
//             width: 200,
//           );
//         });
//       } else {
//         _replyScreenShot = Image.asset(
//           'assets/no-screen-shot.png',
//           width: 200,
//         );
//       }

//       _reply.ticketId = int.parse(reply['ticket_id'].toString());
//       _reply.userId = int.parse(reply['user_id'].toString());
//       _reply.id = int.parse(reply['id'].toString());

//       setState(() {
//         _replyList.add(Container(
//           width: width,
//           padding: const EdgeInsets.all(10.0),
//           child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _reply.userType == 'customer'
//                       ? Container(
//                           height: 40,
//                           color: Colors.green,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   '${getTranslated(context, 'Customer reply ')}',
//                                   style: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                                 Text(
//                                   '${getTranslated(context, 'Replied by')} - ${_reply.userName}',
//                                   style: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container(
//                           height: 40,
//                           color: Colors.blue,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   '${capitalize(_reply.userType!)} ${getTranslated(context, 'reply')} ',
//                                   style: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                                 Text(
//                                   '${getTranslated(context, 'Replied by')} - ${_reply.userName}',
//                                   style: TextStyle(
//                                       fontSize: 14.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${_reply.replyMessage}',
//                       style: TextStyle(fontSize: 15.0),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: _replyScreenShot,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//       });
//     });
//   }

//   Future _submitTicketReply(TicketReply ticketReply) async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       return await _ticketService.createTicketReply(ticketReply);
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   _chooseImage() async {
//     final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
//     setState(() {
//       _image = File(pickedFile!.path);
//     });
//   }

//   Widget _showImage() {
//     if (_image != null) {
//       return Image.file(_image!);
//     } else {
//       return Image.asset(
//         showImage,
//         width: 200,
//         height: 200,
//       );
//     }
//   }

//   Future _uploadTicketReplyScreenshot(File imageFile, int ticketReplyId) async {
//     _prefs = await SharedPreferences.getInstance();
//     return await _ticketService.uploadTicketReplyScreenshot(
//         imageFile, ticketReplyId);
//   }

//   _showSuccessMessage(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
//             contentPadding: EdgeInsets.all(0.0),
//             content: Container(
//               height: 360.0,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Image.asset('assets/success.png'),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${getTranslated(context, 'Reply Submitted Successfully')}',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 24.0, color: appColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   _showFailedMessage(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
//             contentPadding: EdgeInsets.all(0.0),
//             content: Container(
//               height: 360.0,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Image.asset('assets/failed.png')),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${getTranslated(context, 'Reply Submit Failed')}',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 24.0, color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   Future _closeATicket(int? ticketId) async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       return await _ticketService.closeATicket(ticketId!);
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future _reOpenATicket(int? ticketId) async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       return await _ticketService.reOpenATicket(ticketId!);
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   _confirm(BuildContext context, Ticket ticket, String action, String message) {
//     return showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return AlertDialog(
//             actions: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ButtonTheme(
//                       minWidth: 30.0,
//                       height: 40.0,
//                       child: TextButton(
//                         onPressed: () async {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           '${getTranslated(context, 'Cancel')}',
//                           style: TextStyle(color: Colors.black, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ButtonTheme(
//                       minWidth: 40.0,
//                       height: 40.0,
//                       child: TextButton(
//                         onPressed: () async {
//                           Navigator.pop(context);
//                           setState(() {
//                             _isLoading = true;
//                           });
//                           if (action == 'Close') {
//                             await _closeATicket(ticket.id).then((_) {
//                               setState(() {
//                                 _status = Text(
//                                   '${getTranslated(context, 'Closed')}',
//                                   style: TextStyle(color: Colors.green),
//                                 );
//                                 _isLoading = false;
//                               });
//                             });
//                           } else {
//                             await _reOpenATicket(ticket.id).then((_) {
//                               setState(() {
//                                 _status = Text(
//                                   '${getTranslated(context, 'ReOpened')}',
//                                   style: TextStyle(color: Colors.red),
//                                 );
//                                 _isLoading = false;
//                               });
//                             });
//                           }
//                         },
//                         child: Text(
//                           '${getTranslated(context, 'Yes')}',
//                           style: TextStyle(color: Colors.green, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
//             contentPadding: EdgeInsets.all(0.0),
//             content: Container(
//                 height: 60.0,
//                 width: MediaQuery.of(context).size.width,
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Text(
//                       message,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 20.0),
//                     ),
//                   ),
//                 )),
//           );
//         });
//   }

//   _showDataValidationMessage(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
//             contentPadding: EdgeInsets.all(0.0),
//             content: Container(
//               height: 360.0,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Image.asset('assets/failed.png')),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${getTranslated(context, 'Please fill all the fields and try again')}!',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 24.0, color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   int _counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     if (_counter == 0) _getRepliesByTicketId(MediaQuery.of(context).size.width);
//     _counter++;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appColor,
//         title:
//             Center(child: Text('${getTranslated(context, 'Ticket Details')}')),
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.arrow_back_ios),
//         ),
//         actions: <Widget>[
//           InkWell(
//             onTap: () async {
//               _prefs = await SharedPreferences.getInstance();
//               if (_prefs!.getString('type') == 'admin') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AdminDashboardScreen(),
//                   ),
//                 );
//               } else if (_prefs!.getString('type') == 'employee') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EmployeeDashboardScreen(),
//                   ),
//                 );
//               } else if (_prefs!.getString('type') == 'customer') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CustomerDashboardScreen(),
//                   ),
//                 );
//               } else {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CustomerDashboardScreen(),
//                   ),
//                 );
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(right: 18.0),
//               child: Icon(Icons.close),
//             ),
//           )
//         ],
//       ),
//       body: ListView(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                           '${getTranslated(context, 'Subject')} : ${this.widget.ticket!.subject}'),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Text(
//                           '${getTranslated(context, 'Priority')} :  ${this.widget.ticket!.priority}'),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Text(
//                           '${getTranslated(context, 'Category')} :  ${this.widget.ticket!.category}'),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Text(
//                           '${getTranslated(context, 'Message')} :  ${this.widget.ticket!.message}'),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Text('${getTranslated(context, 'Status')} : '),
//                           _status!
//                         ],
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Text('${getTranslated(context, 'Screen Shot')} : '),
//                           _screenShot!,
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: ButtonTheme(
//                               minWidth: 60.0,
//                               height: 40.0,
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(7.0)),
//                                   primary: appColor,
//                                 ),
//                                 onPressed: () {
//                                   _confirm(
//                                       context,
//                                       this.widget.ticket!,
//                                       '${getTranslated(context, 'ReOpen')}',
//                                       '${getTranslated(context, 'Are you sure you want to Re Open this ticket')}?');
//                                 },
//                                 child: Text(
//                                   '${getTranslated(context, 'Re Open')}',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: ButtonTheme(
//                               minWidth: 60.0,
//                               height: 40.0,
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(7.0)),
//                                   primary: appColor,
//                                 ),
//                                 onPressed: () async {
//                                   _confirm(
//                                       context,
//                                       this.widget.ticket!,
//                                       '${getTranslated(context, 'Close')}',
//                                       '${getTranslated(context, 'Are you sure you want to close resolved this ticket')}?');
//                                 },
//                                 child: Text(
//                                   '${getTranslated(context, 'Close')}',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       _isLoading == false
//                           ? Container()
//                           : Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: CircularProgressIndicator(),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: _replyList,
//           ),
//           Container(
//               child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           setState(() {
//                             _replyShowHide = !_replyShowHide;
//                           });
//                         },
//                         child: Text(
//                           'Reply ...',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                   _replyShowHide == true
//                       ? Column(
//                           children: [
//                             TextFormField(
//                               controller: _message,
//                               maxLines: 100,
//                               minLines: 7,
//                               decoration: InputDecoration(
//                                   hintText: 'Write your message here',
//                                   labelText: 'Message'),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: TextButton(
//                                       onPressed: () {
//                                         _chooseImage();
//                                       },
//                                       child: GestureDetector(
//                                         child: CircleAvatar(
//                                           radius: 50,
//                                           backgroundColor: Colors.transparent,
//                                           child: _showImage(),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   setState(() {
//                                     _isLoading = true;
//                                   });
//                                   _prefs =
//                                       await SharedPreferences.getInstance();
//                                   int? userId = _prefs!.getInt('userId');

//                                   if (userId != null) {
//                                     if (_message.text == '') {
//                                       setState(() {
//                                         _isLoading = false;
//                                       });
//                                       _showDataValidationMessage(context);
//                                     } else {
//                                       var _ticketReply = TicketReply();
//                                       _ticketReply.replyMessage = _message.text;
//                                       _ticketReply.ticketId =
//                                           this.widget.ticket!.id;
//                                       _ticketReply.userType =
//                                           _prefs!.getString('type');
//                                       _ticketReply.userId =
//                                           _prefs!.getInt('userId');
//                                       // try {
//                                       await _submitTicketReply(_ticketReply)
//                                           .then((data) {
//                                         var _data = json.decode(data.body);
//                                         if (_data['id'] != null &&
//                                             _data['id'] != '') {
//                                           if (_image != null) {
//                                             _uploadTicketReplyScreenshot(
//                                                 _image!, _data['id']);
//                                           }

//                                           if (_prefs!.getString('type') ==
//                                               'customer') {
//                                             final _pushNotificationService =
//                                                 PushNotificationService();
//                                             final _notificationService =
//                                                 NotificationService();

//                                             var _notificationModel =
//                                                 NotificationModel();
//                                             _notificationModel
//                                                 .notificationQuantity = 1;
//                                             _notificationModel.type =
//                                                 'ticket-replied';
//                                             _notificationModel
//                                                     .notificationTitle =
//                                                 'Ticket replied';
//                                             _notificationModel
//                                                     .notificationMessage =
//                                                 'Reply on ticket - ${this.widget.ticket!.subject}';
//                                             _notificationModel
//                                                     .notificationTypeId =
//                                                 this.widget.ticket!.id;
//                                             _notificationModel.senderUserId =
//                                                 _ticketReply.userId.toString();
//                                             _notificationModel.sendToUserId =
//                                                 '0';
//                                             _notificationModel.isRead = 0;

//                                             _notificationService
//                                                 .saveNotificationInfo(
//                                                     _notificationModel);
//                                             _pushNotificationService
//                                                 .sendCategoryBasedTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-replied-category',
//                                                     this
//                                                         .widget
//                                                         .ticket
//                                                         .categoryId
//                                                         .toString(),
//                                                     _ticketReply.id.toString(),
//                                                     _prefs!.getInt('userId'));
//                                             _pushNotificationService
//                                                 .sendAllTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-replied',
//                                                     _ticketReply.id.toString(),
//                                                     _prefs!.getInt('userId'));
//                                           } else if (_prefs!.getString('type') ==
//                                               'employee') {
//                                             final _pushNotificationService =
//                                                 PushNotificationService();
//                                             final _notificationService =
//                                                 NotificationService();

//                                             var _notificationModel =
//                                                 NotificationModel();
//                                             _notificationModel
//                                                 .notificationQuantity = 1;
//                                             _notificationModel.type =
//                                                 'ticket-replied';
//                                             _notificationModel
//                                                     .notificationTitle =
//                                                 'Ticket replied';
//                                             _notificationModel
//                                                     .notificationMessage =
//                                                 'Reply on ticket - ${this.widget.ticket!.subject}';
//                                             _notificationModel
//                                                     .notificationTypeId =
//                                                 this.widget.ticket!.id;
//                                             _notificationModel.senderUserId =
//                                                 _ticketReply.userId.toString();
//                                             _notificationModel.sendToUserId =
//                                                 '0';
//                                             _notificationModel.isRead = 0;

//                                             _notificationService
//                                                 .saveNotificationInfo(
//                                                     _notificationModel);
//                                             _pushNotificationService
//                                                 .sendUserBasedTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-opened',
//                                                     this
//                                                         .widget
//                                                         .ticket
//                                                         .userId
//                                                         .toString(),
//                                                     _ticketReply.id.toString(),
//                                                     _prefs!.getInt('userId'));
//                                             _pushNotificationService
//                                                 .sendAllTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-replied',
//                                                     _ticketReply.id.toString(),
//                                                     _prefs!.getInt('userId'));
//                                           } else {
//                                             final _pushNotificationService =
//                                                 PushNotificationService();
//                                             final _notificationService =
//                                                 NotificationService();

//                                             var _notificationModel =
//                                                 NotificationModel();
//                                             _notificationModel
//                                                 .notificationQuantity = 1;
//                                             _notificationModel.type =
//                                                 'ticket-replied';
//                                             _notificationModel
//                                                     .notificationTitle =
//                                                 'Ticket replied';
//                                             _notificationModel
//                                                     .notificationMessage =
//                                                 'Reply on ticket - ${this.widget.ticket!.subject}';
//                                             _notificationModel
//                                                     .notificationTypeId =
//                                                 this.widget.ticket!.id;
//                                             _notificationModel.senderUserId =
//                                                 _ticketReply.userId.toString();
//                                             _notificationModel.sendToUserId =
//                                                 '0';
//                                             _notificationModel.isRead = 0;

//                                             _notificationService
//                                                 .saveNotificationInfo(
//                                                     _notificationModel);
//                                             _pushNotificationService
//                                                 .sendCategoryBasedTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-opened-category-${this.widget.ticket!.categoryId.toString()}',
//                                                     this
//                                                         .widget
//                                                         .ticket
//                                                         .categoryId
//                                                         .toString(),
//                                                     _ticketReply.id.toString(),
//                                                     _prefs!.getInt('userId'));
//                                             _pushNotificationService
//                                                 .sendAllTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-replied',
//                                                     _ticketReply.id.toString(),
//                                                     _prefs!.getInt('userId'));
//                                           }

//                                           setState(() {
//                                             _isLoading = false;
//                                           });
//                                           _message.text = "";
//                                           _showSuccessMessage(context);
//                                           Timer(Duration(seconds: 3), () {
//                                             _getRepliesByTicketId(
//                                                 MediaQuery.of(context)
//                                                     .size
//                                                     .width);
//                                             Navigator.pop(context);
//                                           });
//                                         } else {
//                                           setState(() {
//                                             _isLoading = false;
//                                           });
//                                           _showFailedMessage(context);
//                                         }
//                                       });
//                                       // } catch (e) {
//                                       //   setState(() {
//                                       //     _isLoading = false;
//                                       //   });
//                                       //   _showFailedMessage(context);
//                                       // }
//                                     }
//                                   } else {
//                                     setState(() {
//                                       _isLoading = false;
//                                     });
//                                   }
//                                 },
//                                 child: Text(
//                                   '${getTranslated(context, 'Submit Reply')}',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 20),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
// }
