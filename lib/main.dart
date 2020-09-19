import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodies/screens/wrapper.dart';
import 'package:foodies/services/auth.dart';
import 'dart:async';
import 'models/user.dart';
import 'router.dart' as router;
import 'package:provider/provider.dart';


void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
  runApp(MyApp());});}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    
  return StreamProvider<User>.value(
    value: AuthService().user,
      child: MaterialApp(
        // title: 'foodies club app',
        // onGenerateRoute: router.generateRoute,
        // initialRoute: "/",
        home: Wrapper(),



      ),
  );
        //----------------------KOMMENTER DETTE IND FOR AT STARTE MED DATABASER IGEN------------------
        //Her kan tilføjes multiprovider
        // StreamProvider<User>.value(
        //     value: AuthService().user,
        //     child: MaterialApp(
        //       home: Wrapper(),
            // ));
   }
}
