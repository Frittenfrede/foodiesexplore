import 'package:foodies/models/user.dart';

import 'RestaurantReview.dart';

class FoodieReview {
  String id;
  RestaurantReview reviewToReview;
  User foodie;
  double rating;

  FoodieReview({this.id, this.reviewToReview, this.foodie, this.rating});
}
