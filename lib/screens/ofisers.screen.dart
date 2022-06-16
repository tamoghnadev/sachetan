import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_ticket_app/helpers/localization.dart';
import 'package:m_ticket_app/helpers/theme_settings.dart';
import 'package:m_ticket_app/models/officerss.dart';
import 'package:m_ticket_app/models/reward.dart';
import 'package:m_ticket_app/models/ticket.dart';
import 'package:m_ticket_app/providers/ad_state.dart';
import 'package:m_ticket_app/screens/create.ticket.screen.dart';
import 'package:m_ticket_app/screens/ticket.details.screen.dart';
import 'package:m_ticket_app/services/rewards.service.dart';
import 'package:m_ticket_app/services/ticket.service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfisersScreen extends StatefulWidget {
  /* final int? categoryId;
  final String? categoryName;
  RewardsScreen({this.categoryId, this.categoryName});*/

  @override
  _OfisersScreenState createState() =>
      _OfisersScreenState();
}

class _OfisersScreenState
    extends State<OfisersScreen> {

  List<Officerss> _tickets = [];
  var customer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp

    ]);

    customer = Officerss("https://baruipurpolicedistrict.org/admin/images/Shri%20Indrajit%20Basu.jpg-1329_1644385953.jpg","Shri Indrajit Basu" , "Addl SP Zonal Baruipur Police Dist","9876543210");
    _tickets.add(customer);
    customer = Officerss("https://www.barasatpolicedistrict.in/home/uploads/scnior_officer_list/2019-04-16-14-00-12-IMG-20190416-WA0011.jpg","Shri Biswa Chand" , "Addl SP Zonal Barasat Police Dist","9654125874");
    _tickets.add(customer);
    customer = Officerss("https://www.barasatpolicedistrict.in/home/uploads/scnior_officer_list/2021-01-11-09-08-24-DSCN5300000.jpg","Dr. Shyamal Samanta" , "Addl. SP. Hqrs Barasat Police Dist","9874258965");
    _tickets.add(customer);
    customer = Officerss("https://pbs.twimg.com/media/Etyy6OBXYBAhN1z?format=jpg&name=small","Tauseef Ali Azhar" , "Addl SP Zonal Barasat Police Dist","8521474125");
    _tickets.add(customer);
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
        title: Text('Officers'),
        actions: <Widget>[

        ],
      ),
      body: ListView.builder(
          itemCount: _tickets.length,
          itemBuilder: (BuildContext context,int index){
            return Card(
              child: Column(
                children: <Widget>[
                  Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                child: Container(
                  child: Image.network(
                          _tickets[index].imgurl.toString(),
                          height: 100,
                          width: 100
                      ),



                ),
            ),

                Expanded(
                  flex: 10,
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Name: '+_tickets[index].name.toString(),style: TextStyle(fontSize: 18,color: Colors.lightBlue,fontWeight: FontWeight.bold),),
                        ),

                      ),




                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                        child: Text('Designation: '+_tickets[index].designation.toString(),style: TextStyle(fontSize: 18,color: Colors.black),overflow: TextOverflow.ellipsis,),

                        ),

                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                        child: Text('Contact: '+_tickets[index].contact.toString(),style: TextStyle(fontSize: 18,color: Colors.black),),


),
                      ),

                    ],



                  ),
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
