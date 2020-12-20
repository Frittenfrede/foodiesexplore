import 'package:flutter/material.dart';
import 'package:foodies/screens/home/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Home());
  }
}
