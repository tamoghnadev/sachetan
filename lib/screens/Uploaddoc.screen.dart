

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_ticket_app/screens/customer.dashboard.screen.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import '../helpers/theme_settings.dart';

class UploaddocScreen extends StatefulWidget {

  var Idd;


  UploaddocScreen({required this.Idd});

  @override
  _UploaddocScreenState createState() => _UploaddocScreenState();
}

class _UploaddocScreenState extends State<UploaddocScreen> {

  var progress;
  var selectedfile;
  late Response response;
  String pddf = "";
  String result = "";
  String img = "";
  Dio dio = new Dio();

  _getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? _token = _prefs.getString('token');
    return _token;
  }

  selectFile() async {
    /*selectedfile = await FilePicker.getFile(

      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'jpeg','doc','docx'],
      //allowed extension to choose
    );
    print(selectedfile);*/
    //for file_pocker plugin version 2 or 2+
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path.toString());
    }
    print(selectedfile);

    setState((){}); //update the UI so that file name is shown
  }

  uploadFile() async {
    String uploadurl = "https://scriptrix.net/demo/tickets/api/upload-attachment";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    String? _token = await _getToken();
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          selectedfile.path,
          filename: basename(selectedfile.path)
        //show only filename from path
      ),
      "complaint_id":widget.Idd,
      "reamaining_pdf":pddf,
      "reamaining_images":img
    });
print(formdata.toString());
    response = await dio.post(uploadurl,
      data: formdata,

      options: Options(
          followRedirects: false,
          headers: {'authorization': 'Bearer $_token'},
          validateStatus: (status) {
            return
            status! < 500;
          }
      ),
      onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          //update the progress
        });
      },);
print("Server Code "+response.statusCode.toString());
    print("Server Response "+response.toString());
    if(response.statusCode == 200){
      var f_result = json.decode(response.toString());
      pddf = f_result['reamaining_pdf'].toString();
      img = f_result['reamaining_images'].toString();
      result = f_result['result'];
      /*if((f_result['reamaining_images']=='0')&&(f_result['reamaining_pdf']=='0')){
      Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx)=>CustomerDashboardScreen()));
      }else{
        Alert(
          type: AlertType.error,
          title: "RFLUTTER ALERT",
          desc: "Flutter is more awesome with RFlutter Alert.",
          *//*buttons: [
            DialogButton(
              child: Text(
                "COOL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: ()
              width: 120,
            )
          ],*//*
        ).show();

      }*/
      //print response from server
    }else{
      print("Error during connection to server.");
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
            msg: "You Can Not Go Back From Here",  // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER,    // location
            timeInSecForIosWeb: 1               // duration
        );
        return false;
      },
    child: Scaffold(
        appBar: AppBar(
          title:Text("Documents Uploading"),
          backgroundColor: appColor,
        ), //set appbar
        body:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),

            child:Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 10.0, right: 10.0, bottom: 5.0),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text("Please Attach Your Documents, You can Upload 4 PDFs and 2 Images",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xFF255c92))),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: const EdgeInsets.only(top: 25.0),
                //show file name here
                child:Image.asset(
                  'assets/icon5.png',
                  width: 200,
                  height: 200,
                ),
                //show progress status here
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: const EdgeInsets.only(top: 25.0),
                //show file name here
                child:progress == null?
                Text("Progress: 0%",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),):
                Text(basename("Progress: $progress"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),),
                //show progress status here
              ),

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child:selectedfile == null?
                Text("Choose File"):
                Text(basename(selectedfile.path),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                //basename is from path package, to get filename from path
                //check if file is selected, if yes then show file name
              ),

              Container(
                width: 300,
                height: 40,
                  child:RaisedButton.icon(
                    onPressed: (){
                      selectFile();
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text("CHOOSE FILE"),
                    color: Color(0xFF255c92),
                    colorBrightness: Brightness.dark,
                  )
              ),

              //if selectedfile is null then show empty container
              //if file is selected then show upload button
              selectedfile == null?
              Container():
              Container(
                  width: 300,
                  height: 65,
                  padding: const EdgeInsets.only(top: 25.0),
                  child:RaisedButton.icon(
                    onPressed: (){
      if((pddf=='')&&(img=='')){
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Sachetan",
          desc: "You Can Upload Total Pdf: 4 and Image: 2",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () =>Navigator.pop(context, false),

              width: 120,
            )
          ],
        ).show();
        uploadFile();
      }else if((pddf=='0')&&(img=='0')){
        Alert(
          context: context,
          type: AlertType.error,
          title: "Sachetan",
          desc: "You Have Uploaded All The Documents For This Tickets...",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomerDashboardScreen())),
              width: 120,
            )
          ],
        ).show();
      }else{
        Alert(
          context: context,
          type: AlertType.success,
          title: "Sachetan",
          desc: "You Can Upload Total Pdf: "+pddf+" and Image: "+img,
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context, false),
              width: 120,
            )
          ],
        ).show();
        uploadFile();
      }


                    },
                    icon: Icon(Icons.upload_file),
                    label: Text("UPLOAD FILE"),
                    color: Color(0xFF255c92),
                    colorBrightness: Brightness.dark,
                  )
              ),
              Container(
                  width: 300,
                  height: 65,
                  padding: const EdgeInsets.only(top: 25.0),
                  child:RaisedButton.icon(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomerDashboardScreen()));
                    },
                    icon: Icon(Icons.close),
                    label: Text("Create Ticket Without Document"),
                    color: Color(0xFF5683b0),
                    colorBrightness: Brightness.dark,
                  )
              ),

            ],)
        )
    ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert!!"),
          content: new Text("You are awesome!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
