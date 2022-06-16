import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:m_ticket_app/models/geotag.dart';
import 'package:m_ticket_app/screens/Upmored.screen.dart';
import 'package:m_ticket_app/services/geotagservice.dart';

import 'Uploaddoc.screen.dart';

class SearchPlacesScreen extends StatefulWidget {

  var Idd;


  SearchPlacesScreen({required this.Idd});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

const kGoogleApiKey = 'AIzaSyAbi8mbUlCfllUM3GItVU_ANTGun48G0jQ';
String nn = "";
var Latitude;
var Langitude;
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(22.5726, 88.3639), zoom: 14.0);

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;

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
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text("Google Search Places"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(FontAwesomeIcons.arrowCircleRight, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpmoredScreen(Idd: widget.Idd,ltt:Latitude,lnn:Langitude)));
              },
            ),
          ],
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          ElevatedButton(onPressed: _handlePressButton, child: const Text("Search Places")),
          /*Padding(
            padding: const EdgeInsets.all(45.0),
          child: Align(
            alignment: Alignment.topLeft,
          child: Container(

            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          child: InkWell(

            onTap: () {

            },

            child: Text("Proceed",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,),),
          ),
    ),
    ),
    ),*/
        ],
      ),
    )
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country,"IN")]);


    displayPrediction(p!,homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response){
    homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    
     Latitude = lat;
     Langitude = lng;

    markersList.clear();
    markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));
    nn = widget.Idd.toString();
    print("Golla"+widget.Idd.toString());

    setState(() {});

     googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
    
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
                    'GeoTagging Has Been Done Successfully,Now Its Time To Upload Few Documents',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
