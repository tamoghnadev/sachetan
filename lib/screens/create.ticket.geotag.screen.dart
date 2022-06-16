import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/notification.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/screens/admin.dashboard.screen.dart';

import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:m_ticket_app/screens/employee.dashboard.screen.dart';
import 'package:m_ticket_app/screens/search_places_screen.dart';
import 'package:m_ticket_app/services/Officefetch.service.dart';
import 'package:m_ticket_app/screens/Uploaddoc.screen.dart';
import 'package:m_ticket_app/services/category.service.dart';
import 'package:m_ticket_app/services/departmentfetch.service.dart';
import 'package:m_ticket_app/services/district.service.dart';
import 'package:m_ticket_app/services/notification_service.dart';
import 'package:m_ticket_app/services/officers.service.dart';
import 'package:m_ticket_app/services/push_notification_service.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/complain.service.dart';

class CreateTicketGeotagScreen extends StatefulWidget {
  @override
  _CreateTicketGeotagScreenState createState() => _CreateTicketGeotagScreenState();
}

class _CreateTicketGeotagScreenState extends State<CreateTicketGeotagScreen> {
  SharedPreferences? _prefs;
  var _subject = TextEditingController();
  var _message = TextEditingController();
  var _compliant = TextEditingController();
  var _propp = TextEditingController();
  List<DropdownMenuItem> _priorities = [];
  List<DropdownMenuItem> _persons = [];
  List<DropdownMenuItem> _categoryList = [];
  List<DropdownMenuItem> _Dist = [];
  List<DropdownMenuItem> _offcc = [];
  List<DropdownMenuItem> _departs = [];
  List<DropdownMenuItem> _fisers = [];
  List<DropdownMenuItem> c_type = [];
  var _ticketService = TicketService();
  var _selectedPriority;
  var _selecteddistrict,_selfisers,_selDeart,_seloffice,proptype;
  //int proptype = 0;
  //FilePickerResult? result;
  var _selectedOptions;
  var _selectedCategory;
  var _selectedCType;
  bool isSwitched = false;
  bool _isOption = false;
  bool _isSomeone = false;
  bool _isLoading = true;
  String fileType = 'MultipleFile';
  File? _image;
  String showImage = 'assets/screen-shot.png';
  final imagePicker = ImagePicker();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCategories();

      _priorities.add(DropdownMenuItem(
        child: Text('Land'),
        value: '1',
      ));
      _priorities.add(DropdownMenuItem(
        child: Text('Other Land'),
        value: '2',
      ));
      _priorities.add(DropdownMenuItem(
        child: Text('Residential House'),
        value: '3',
      ));
      _priorities.add(DropdownMenuItem(
        child: Text('Cash'),
        value: '4',
      ));
      _priorities.add(DropdownMenuItem(
        child: Text('Others'),
        value: '5',
      ));
    });

    _getDistrist();
    getDapartment();
    getOffices();
    getOfficers();
    getComplains();

    _persons.add(DropdownMenuItem(
      child: Text("Self"),
      value: '1',
    ));
    _persons.add(DropdownMenuItem(
      child: Text("Someone Else"),
      value: '2',
    ));

    super.initState();
  }

  getComplains() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = ComplainService();
      var result = await _categoryService.getCompalins();
      var complains = json.decode(result.body);
      complains.forEach((comps) {
        setState(() {
          c_type.add(DropdownMenuItem(
            child: Text(comps['name']),
            value: comps['id'],
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
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = CategoryService();
      var result = await _categoryService.getCategories();
      var categories = json.decode(result.body);
      categories.forEach((category) {
        setState(() {
          _categoryList.add(DropdownMenuItem(
            child: Text(category['name']),
            value: category['id'],
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

  getOfficers() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = OfficersService();
      var result = await _categoryService.getOfficers();
      var oficers = json.decode(result.body);
      oficers.forEach((officers) {
        setState(() {
          _fisers.add(DropdownMenuItem(
            child: Text(officers['name']),
            value: officers['id'],
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

  _getDistrist() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = DistrictService();
      var result = await _categoryService.getDistrict();
      var district = json.decode(result.body);
      // print(district);
      district.forEach((district) {
        setState(() {
          _Dist.add(DropdownMenuItem(
            child: Text(district['name']),
            value: district['id'],
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

  getDapartment() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = DepartmentFetchService();
      var result = await _categoryService.getDepartments();
      var departs = json.decode(result.body);
      // print(district);
      departs.forEach((department) {
        setState(() {
          _departs.add(DropdownMenuItem(
            child: Text(department['name']),
            value: department['id'],
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

  getOffices() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      var _categoryService = OfficeFetchService();
      var result = await _categoryService.getOffices();
      var offices = json.decode(result.body);
      // print(district);
      offices.forEach((offices) {
        setState(() {
          _offcc.add(DropdownMenuItem(
            child: Text(offices['name']),
            value: offices['id'],
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

  Future _submitTicket(Ticket ticket) async {
    try {
      _prefs = await SharedPreferences.getInstance();
      return await _ticketService.createTicket(ticket);
    } catch (e) {
      return e.toString();
    }
  }

  /* _chooseImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Widget _showImage() {
    if (_image != null) {
      return Image.file(_image!);
    } else {
      return Image.asset(
        showImage,
        width: 350,
        height: 350,
      );
    }
  }*/

  Future _uploadTicketScreenshot(File imageFile, int ticketId) async {
    _prefs = await SharedPreferences.getInstance();
    return await _ticketService.uploadTicketScreenshot(imageFile, ticketId);
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
                  child: Text('Now Proceeding For Geo Tagging, Please Wait...',
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
                      '${getTranslated(context, 'Complaint submission failed')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showNotLoggedInMessage(BuildContext context) {
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
                      '${getTranslated(context, 'Please log in to submit a Complaint')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title:
        Center(child: Text('Submit Geo Tag Complaint')),
        leading: Text(''),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              _prefs = await SharedPreferences.getInstance();
              if (_prefs!.getString('type') == 'customer') {
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
                    builder: (context) => AdminDashboardScreen(),
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
      body: _isLoading == true
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CircularProgressIndicator(),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _selectedOptions,
                            items: _persons,
                            hint: Text("Complaint For",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selectedOptions = value;
                                if(_selectedOptions=='2'){
                                  _isSomeone = true;
                                }else{
                                  _isSomeone = false;
                                }

                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _isSomeone,
                          child:Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFormField(
                              controller: _compliant,
                              decoration: InputDecoration(
                                  hintText:"Write The Name",
                                  labelText:"Name Please"),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _selectedCType,
                            items: c_type,
                            hint: Text("Complaint Type",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selectedCType = value;

                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _selDeart,
                            items: _departs,
                            hint: Text("Select Your Department",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selDeart = value;

                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _seloffice,
                            items: _offcc,
                            hint: Text("Select Your Office",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _seloffice = value;

                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _selecteddistrict,
                            items: _Dist,
                            hint: Text("Select Your District",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selecteddistrict = value;


                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _selfisers,
                            items: _fisers,
                            hint: Text("Select Your Officers",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selfisers = value;

                              });
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: proptype,
                            items: _priorities,
                            hint: Text("Select Property Type",style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                proptype = value;
                                if(proptype=="5"){
                                _isOption = true;
                                }else{
                                  _isOption = false;
                                }

                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _isOption,
                          child:Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFormField(
                              controller: _propp,
                              decoration: InputDecoration(
                                  hintText:"Write Property Description",
                                  labelText:"Property Description Please"),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: TextFormField(
                            controller: _subject,
                            decoration: InputDecoration(
                                hintText:
                                'Write your subject here',
                                labelText:
                                '${getTranslated(context, 'Subject')}'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),

                        /*Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: DropdownButtonFormField(
                                  value: _selectedPriority,
                                  items: _priorities,
                                  hint: Text(
                                      'Select a priority'),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _selectedPriority = value;
                                    });
                                  },
                                ),
                              ),*/
                        /*Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: DropdownButtonFormField(
                            value: _selectedCategory,
                            items: _categoryList,
                            hint: Text(
                                'Select a category',style: TextStyle(fontSize: 20),),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _message,
                            maxLines: 100,
                            minLines: 7,
                            decoration: InputDecoration(
                                hintText:
                                'Write your message here',
                                labelText:
                                '${getTranslated(context, 'Message')}'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text("To Be Anonymous ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;


                                });
                              },
                              activeTrackColor: Color(0xFF000000),
                              activeColor: Colors.lightBlue,
                            ),
                          ),
                        ),

                        /*Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),

                                  child: TextButton(
                                    onPressed: () async {
                                    pickFiles(fileType);
                                    },  child: Container(
                                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    color: Colors.black12,
                                    child: Text("Pick The PDF Files"),

                                  ),


                                  ),
                                ),

                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),

                                  child: TextButton(
                                    onPressed: () async {
                                      pickFiles(fileType);
                                    },  child: Container(
                                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    color: Colors.black12,
                                    child: Text("Pick The Image Files"),

                                  ),


                                  ),
                                ),

                              ),*/
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ButtonTheme(
                            minWidth: 800.0,
                            height: 45.0,
                            child: SizedBox(
                              width: 350.0,
                              height: 50.0,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: appColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(7.0)),
                                    primary: appColor),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _prefs =
                                  await SharedPreferences.getInstance();
                                  int? userId = _prefs!.getInt('userId');

                                  if (userId != null) {
                                    if (_subject.text == '' ||
                                        _message.text == '' ||
                                        _selectedOptions==''||_selDeart==''
                                        ||_seloffice==''||_selecteddistrict==''||_selfisers=='') {

                                      setState(() {
                                        _isLoading = false;
                                      });
                                      _showDataValidationMessage(context);
                                    } else {
                                      var _ticket = Ticket();

                                      _ticket.comp_for = _selectedOptions;
                                      _ticket.department = _selDeart;
                                      _ticket.ctypee = _selectedCType;
                                      _ticket.office = _seloffice;
                                      _ticket.district = _selecteddistrict;
                                      _ticket.officers = _selfisers;
                                      _ticket.person = _compliant.text;
                                      _ticket.prodid = proptype;
                                      _ticket.propdets = _propp.text;
                                      _ticket.subject = _subject.text;
                                      _ticket.message = _message.text;
                                      _ticket.geotag = "Y";
                                      _ticket.isanonymous = isSwitched;
                                      _ticket.isOpened = true;
                                      _ticket.isReopened = false;
                                      _ticket.isClosedResolved = false;
                                      _ticket.isClosedUnResolved = false;
                                      _ticket.userId =
                                          _prefs!.getInt('userId');

                                      try {
                                        await _submitTicket(_ticket)
                                            .then((data) {
                                          var _data =json.decode(data.body);
                                          print("Ticc "+data.body.toString());
                                          if (_data['id'] != null &&
                                              _data['id'] != '') {

                                            /*if (_image != null) {
                                                  _uploadTicketScreenshot(
                                                          _image!, _data['id'])
                                                      .then((_) {});
                                                }*/

                                            // _updateNotificationAndSendPush(
                                            //     _ticket, userId);

                                            setState(() {
                                              _isLoading = false;
                                            });
                                            _showSuccessMessage(context);
                                            Timer(Duration(seconds: 3), () {
                                              Navigator.pop(context);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SearchPlacesScreen(Idd:_data['id']),
                                                  )
                                              );
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
                                    _showNotLoggedInMessage(context);
                                  }
                                },
                                child: Text('Proceed For GeoTag',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
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
          ],
        ),
      ),
    );
  }

/*  void pickFiles(String? filetype) async {
    switch (filetype) {
      case 'MultipleFile':
        result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom,allowedExtensions: ['jpg', 'pdf', 'mp4']);
        if (result == null) return;
        //loadSelectedFiles(result!.files);
        break;
    }
  }*/

/*void loadSelectedFiles(List<PlatformFile> files){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => FileList(files: files, onOpenedFile:viewFile ))
    );

  }*/

/*void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }*/



// _updateNotificationAndSendPush(Ticket? ticket, int? userId) async {
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
//             'ticket-opened-category',
//             ticket!.categoryId.toString(),
//             ticket.id.toString(),
//             userId);
//
//     _pushNotificationService
//         .sendAllTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
//             _notificationModel,
//             'ticket-opened',
//             ticket.id.toString(),
//             userId);
//
//     _pushNotificationService
//         .sendUserBasedTicketOpenedReOpenedResolvedUnResolvedAndRepliedPushNotification(
//             _notificationModel,
//             'ticket-opened${ticket.userId}',
//             ticket.id.toString(),
//             userId);
//
//     _notificationModel.notificationQuantity = 1;
//     _notificationModel.type = 'ticket-opened';
//     _notificationModel.notificationTitle = 'Ticket Opened';
//     _notificationModel.notificationMessage =
//         'A New Ticket Opened Successfully!';
//     _notificationModel.notificationTypeId = ticket.id;
//     _notificationModel.senderUserId = userId.toString();
//     _notificationModel.sendToUserId = ticket.userId.toString();
//     _notificationModel.sendToCategoryId = ticket.categoryId.toString();
//     _notificationModel.isReadAdmin = 0;
//     await _notificationService.saveNotificationInfo(_notificationModel);
//   } catch (e) {
//     print(e.toString());
//   }
// }
}
