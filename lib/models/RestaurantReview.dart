import 'package:foodies/models/user.dart';
import 'Restaurant.dart';

class RestaurantReview {
  User foodie;
  String review;
  Restaurant restaurant;
  double rating;
  String id;
  String city;
  String header;
  List<String> photoDescriptions;
  List<String> photos;

  RestaurantReview(
      {this.foodie,
      this.review,
      this.restaurant,
      this.rating,
      this.id,
      this.city,
      this.header,
      this.photoDescriptions,
      this.photos});
}
