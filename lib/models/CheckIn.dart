import 'package:foodies/models/user.dart';

import 'Restaurant.dart';

class CheckIn {
  User foodie;
  Restaurant restaurant;
  DateTime time;
  String id;

  CheckIn({this.foodie, this.restaurant, this.time, this.id});
}
