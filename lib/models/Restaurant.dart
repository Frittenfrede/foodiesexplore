import 'package:foodies/models/RestaurantReview.dart';

class Restaurant{
  String name;
  String country;
  String city;
  String postalCode;
  String street;
  String streetNumber;
  double rating;
  String checkincode;
  List<RestaurantReview> reviews;
  int priceClass;
  List<String> photos;
  String id;

  Restaurant({this.name, this.country,this.city,this.postalCode,this.street,this.streetNumber,this.checkincode,this.rating,this.reviews,this.priceClass,this.photos,this.id});

 static List<Restaurant> getRestaurants(){
   List<Restaurant> rests = new List<Restaurant>();
  
Restaurant one = Restaurant(name: "Restaurant Rømer",country: "Denmark", city: "Aarhus", postalCode: "8000", street: "Åboulevarden" ,streetNumber: "50",rating: 4.5,reviews: new List<RestaurantReview>(),priceClass: 2, photos: new List<String>(),id: "2");
Restaurant two = Restaurant(name: "Restaurant Ombord",country: "Denmark", city: "Aarhus", postalCode: "8000", street: "Jægergaardsgade", streetNumber: "71",rating: 4.8,reviews: new List<RestaurantReview>(),priceClass: 2, photos: new List<String>(),id: "3");
Restaurant three = Restaurant(name: "Grappa Deli",country: "Denmark", city: "Aarhus", postalCode: "8000", street: "Skt. Clemens Stræde", streetNumber: "8",rating: 4.1,reviews: new List<RestaurantReview>(),priceClass: 2, photos: new List<String>(),id: "4");
Restaurant four = Restaurant(name: "Nordisk Spisehus",country: "Denmark", city: "Aarhus", postalCode: "8000", street: "M.P Bruuns Gade 31", streetNumber: "31",rating: 4.2,reviews: new List<RestaurantReview>(),priceClass: 3, photos: new List<String>(),id: "5");
Restaurant five = Restaurant(name: "Restaurant Gastrome",country: "Denmark", city: "Aarhus", postalCode: "8000", street: "Rosengade 8", streetNumber: "8",rating: 3.72,reviews: new List<RestaurantReview>(),priceClass: 2, photos: new List<String>(),id: "6");
rests.add(one);
rests.add(two);
rests.add(three);
rests.add(four);
rests.add(five);
return rests;
}


}