//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:m_ticket_app/providers/ad_state.dart';
import 'package:m_ticket_app/widgets/app.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //final initFuture = MobileAds.instance.initialize();
  //final adState = AdState(initFuture);
  runApp(
    Provider.value(
      //value: adState,
      value: null,
      builder: (context, child) => AppWidget(),
    ),
  );
}