// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:m_ticket_app/helpers/localization.dart';
// import 'package:m_ticket_app/helpers/theme_settings.dart';
// import 'package:m_ticket_app/models/notification.dart';
// import 'package:m_ticket_app/models/ticket.dart';
// import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';
// import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
// import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
// import 'package:m_ticket_app/services/category.service.dart';
// import 'package:m_ticket_app/services/notification_service.dart';
// import 'package:m_ticket_app/services/push_notification_service.dart';
// import 'package:m_ticket_app/services/ticket.service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CreateTicketScreen extends StatefulWidget {
//   @override
//   _CreateTicketScreenState createState() => _CreateTicketScreenState();
// }

// class _CreateTicketScreenState extends State<CreateTicketScreen> {
//   SharedPreferences? _prefs;
//   var _subject = TextEditingController();
//   var _message = TextEditingController();
//   List<DropdownMenuItem> _priorities = [];
//   List<DropdownMenuItem> _categoryList = [];
//   var _ticketService = TicketService();
//   var _selectedPriority;
//   var _selectedCategory;
//   bool _isLoading = true;
//   File? _image;
//   String showImage = 'assets/screen-shot.png';
//   final imagePicker = ImagePicker();

//   @override
//   void initState() {
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       _getCategories();
//       _priorities.add(DropdownMenuItem(
//         child: Text('${getTranslated(context, 'Emergency')}'),
//         value: 'Emergency',
//       ));
//       _priorities.add(DropdownMenuItem(
//         child: Text('${getTranslated(context, 'High')}'),
//         value: 'High',
//       ));
//       _priorities.add(DropdownMenuItem(
//         child: Text('${getTranslated(context, 'Medium')}'),
//         value: 'Medium',
//       ));
//       _priorities.add(DropdownMenuItem(
//         child: Text('${getTranslated(context, 'Low')}'),
//         value: 'Low',
//       ));
//     });

//     super.initState();
//   }

//   _getCategories() async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       var _categoryService = CategoryService();
//       var result = await _categoryService.getCategories();
//       var categories = json.decode(result.body);
//       categories.forEach((category) {
//         setState(() {
//           _categoryList.add(DropdownMenuItem(
//             child: Text(category['name']),
//             value: category['id'],
//           ));
//         });
//       });
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       return e.toString();
//     }
//   }

//   Future _submitTicket(Ticket ticket) async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       return await _ticketService.createTicket(ticket);
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
//         width: 350,
//         height: 350,
//       );
//     }
//   }

//   Future _uploadTicketScreenshot(File imageFile, int ticketId) async {
//     _prefs = await SharedPreferences.getInstance();
//     return await _ticketService.uploadTicketScreenshot(imageFile, ticketId);
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
//                       '${getTranslated(context, 'Ticket Submitted Successfully')}',
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
//                       '${getTranslated(context, 'Ticket Submit Failed')}',
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

//   _showNotLoggedInMessage(BuildContext context) {
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
//                       '${getTranslated(context, 'Please log in to submit a Ticket')}',
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

//   _showDataValidationMessage(BuildContext context) {
//     return showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           contentPadding: EdgeInsets.all(0.0),
//           content: Container(
//             height: 360.0,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset('assets/failed.png')),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     '${getTranslated(context, 'Please fill all the fields and try again')}!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 24.0, color: Colors.red),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading == true
//         ? Center(
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: CircularProgressIndicator(),
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: appColor,
//               title: Center(
//                   child: Text('${getTranslated(context, 'Open A Ticket')}')),
//               leading: Text(''),
//               actions: <Widget>[
//                 InkWell(
//                   onTap: () async {
//                     _prefs = await SharedPreferences.getInstance();
//                     if (_prefs!.getString('type') == 'customer') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CustomerDashboardScreen(),
//                         ),
//                       );
//                     } else if (_prefs!.getString('type') == 'employee') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EmployeeDashboardScreen(),
//                         ),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AdminDashboardScreen(),
//                         ),
//                       );
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 18.0),
//                     child: Icon(Icons.close),
//                   ),
//                 )
//               ],
//             ),
//             body: SingleChildScrollView(
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         children: <Widget>[
//                           TextFormField(
//                             controller: _subject,
//                             decoration: InputDecoration(
//                                 hintText:
//                                     '${getTranslated(context, 'Write your subject here')}',
//                                 labelText:
//                                     '${getTranslated(context, 'Subject')}'),
//                           ),
//                           Container(
//                             child: DropdownButtonFormField(
//                               value: _selectedPriority,
//                               items: _priorities,
//                               hint: Text(
//                                   '${getTranslated(context, 'Select a priority')}'),
//                               onChanged: (dynamic value) {
//                                 setState(() {
//                                   _selectedPriority = value;
//                                 });
//                               },
//                             ),
//                           ),
//                           DropdownButtonFormField(
//                             value: _selectedCategory,
//                             items: _categoryList,
//                             hint: Text(
//                                 '${getTranslated(context, 'Select a category')}'),
//                             onChanged: (dynamic value) {
//                               setState(() {
//                                 _selectedCategory = value;
//                               });
//                             },
//                           ),
//                           TextFormField(
//                             controller: _message,
//                             maxLines: 100,
//                             minLines: 7,
//                             decoration: InputDecoration(
//                                 hintText:
//                                     '${getTranslated(context, 'Write your message here')}',
//                                 labelText:
//                                     '${getTranslated(context, 'Message')}'),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   _chooseImage();
//                                 },
//                                 child: Expanded(
//                                     child: Container(
//                                         height: 350, child: _showImage())),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: ButtonTheme(
//                               minWidth: 400.0,
//                               height: 45.0,
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                     backgroundColor: appColor,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(7.0)),
//                                     primary: appColor),
//                                 onPressed: () async {
//                                   setState(() {
//                                     _isLoading = true;
//                                   });
//                                   _prefs =
//                                       await SharedPreferences.getInstance();
//                                   int? userId = _prefs!.getInt('userId');

//                                   if (userId != null) {
//                                     if (_subject.text == '' ||
//                                         _message.text == '' ||
//                                         _selectedPriority == '' ||
//                                         _selectedCategory == '') {
//                                       setState(() {
//                                         _isLoading = false;
//                                       });
//                                       _showDataValidationMessage(context);
//                                     } else {
//                                       var _ticket = Ticket();
//                                       _ticket.subject = _subject.text;
//                                       _ticket.message = _message.text;
//                                       _ticket.priority = _selectedPriority;
//                                       _ticket.categoryId = _selectedCategory;
//                                       _ticket.isOpened = true;
//                                       _ticket.isReopened = false;
//                                       _ticket.isClosedResolved = false;
//                                       _ticket.isClosedUnResolved = false;
//                                       _ticket.userId = _prefs!.getInt('userId');

//                                       try {
//                                         await _submitTicket(_ticket)
//                                             .then((data) {
//                                           var _data = json.decode(data.body);
//                                           if (_data['id'] != null &&
//                                               _data['id'] != '') {
//                                             if (_image != null) {
//                                               _uploadTicketScreenshot(
//                                                       _image!, _data['id'])
//                                                   .then((_) {});
//                                             }
//                                             final _pushNotificationService =
//                                                 PushNotificationService();
//                                             final _notificationService =
//                                                 NotificationService();

//                                             var _notificationModel =
//                                                 NotificationModel();
//                                             _notificationModel
//                                                 .notificationQuantity = 1;
//                                             _notificationModel.type =
//                                                 'ticket-opened';
//                                             _notificationModel
//                                                     .notificationTitle =
//                                                 'New ticket opened';
//                                             _notificationModel
//                                                     .notificationMessage =
//                                                 'A new ticket opened - ${_ticket.subject}';
//                                             _notificationModel
//                                                     .notificationTypeId =
//                                                 _ticket.id;
//                                             _notificationModel.senderUserId =
//                                                 _ticket.userId.toString();
//                                             _notificationModel.sendToUserId =
//                                                 '0';
//                                             _notificationModel.isRead = 0;

//                                             _notificationService
//                                                 .saveNotificationInfo(
//                                                     _notificationModel);
//                                             _pushNotificationService
//                                                 .sendCategoryBasedTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-opened-category-${_ticket.categoryId.toString()}',
//                                                     _ticket.categoryId
//                                                         .toString(),
//                                                     _ticket.id.toString(),
//                                                     _prefs.getInt('userId'));
//                                             _pushNotificationService
//                                                 .sendAllTicketOpenedReOpenedResolvedAndUnResolvedRepliedPushMessage(
//                                                     _notificationModel,
//                                                     'ticket-opened',
//                                                     _ticket.id.toString(),
//                                                     _prefs.getInt('userId'));
//                                             setState(() {
//                                               _isLoading = false;
//                                             });
//                                             _showSuccessMessage(context);
//                                             Timer(Duration(seconds: 3), () {
//                                               Navigator.pop(context);
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       CustomerDashboardScreen(),
//                                                 ),
//                                               );
//                                             });
//                                           } else {
//                                             setState(() {
//                                               _isLoading = false;
//                                             });
//                                             _showFailedMessage(context);
//                                           }
//                                         });
//                                       } catch (e) {
//                                         setState(() {
//                                           _isLoading = false;
//                                         });
//                                         _showFailedMessage(context);
//                                       }
//                                     }
//                                   } else {
//                                     setState(() {
//                                       _isLoading = false;
//                                     });
//                                     _showNotLoggedInMessage(context);
//                                   }
//                                 },
//                                 child: Text(
//                                   '${getTranslated(context, 'Submit')}',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 20),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           _isLoading == false
//                               ? Container()
//                               : Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
// }
