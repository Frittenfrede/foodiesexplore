import "package:flutter/material.dart";

final theme = ThemeData(
  primaryColor: Colors.grey,
  secondaryHeaderColor: Colors.grey[500],
  //accentColor: Colors.grey[1000],
  fontFamily: 'Lato',
  textTheme: ThemeData.light().textTheme.copyWith(),
);

final constTextstyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Montserrat',
  color: Color.fromRGBO(46, 98, 94, 1),
  //fontWeight: FontWeight.bold,
);

dynamic textInputDecoration = InputDecoration(
    // fillColor: Colors.teal[250],
    // filled: true,
    // enabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.white,width: 2.0)
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Color.fromRGBO(46, 98, 94, 1),width: 2.0)
    // ),
    );
