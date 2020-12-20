import 'package:foodies/models/user.dart';
import 'package:foodies/screens/home/home.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/login_choice.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // Return either home or authenticate widget
    if (user == null) {
      return LoginChoice();
    } else {
      return Home();
    }
  }
}
