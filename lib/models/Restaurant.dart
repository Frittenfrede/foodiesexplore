import 'package:foodies/models/RestaurantReview.dart';

class Restaurant {
  String name;
  String country;
  String city;
  String postalCode;
  String street;
  String streetNumber;
  double rating;
  String checkincode;
  List<double> coordinates;
  List<RestaurantReview> reviews;
  int priceClass;
  List<String> photos;
  String id;

  Restaurant(
      {this.name,
      this.country,
      this.city,
      this.postalCode,
      this.street,
      this.streetNumber,
      this.checkincode,
      this.coordinates,
      this.rating,
      this.reviews,
      this.priceClass,
      this.photos,
      this.id});

  
}
