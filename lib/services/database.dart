

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodies/models/CheckIn.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/models/RestaurantReview.dart';
import 'package:foodies/models/user.dart';

class DatabaseService {

  // collection reference
  final String uid;

  DatabaseService({this.uid});
  final CollectionReference restaurantCollection = Firestore.instance.collection("restaurants");
  final CollectionReference restaurantReviewCollection = Firestore.instance.collection("restaurantReviews");
  final CollectionReference userData = Firestore.instance.collection("userData");
  final CollectionReference userCheckIns = Firestore.instance.collection("userCheckIns");

  // Future addRestaurant(String name, String country, String city, String postalCode, String street, String streetNumber, List<String> restaurantReviewIds){

  // }
  Future<void> updateUserData(String email, String name, String picturePath) async{
return await userData.document(uid).setData({
  'id':uid,
  'email': email,
  'name':name,
  'picturePath':picturePath
});
  }

  Future<User> getUserFromId(String id) async{
    return userData.document(id).get().then((value) {
      return User(
        name: value.data['name'] ?? 'Anonnymous',
        email: value.data['email'] ?? '',
        uid: id ?? '',
        picturePath: value.data['picturePath'] ?? '');
    });}

    Future<Restaurant> getRestaurantFromId(String id) async{
      return restaurantCollection.document(id).get().then((doc) => 
         Restaurant(
         city: doc.data['city'] ?? '',
  country: doc.data['country'] ?? '',
  name: doc.data['name'] ?? '',
  photos: doc.data['photos'].cast<String>() ?? new List<String>(),
postalCode: doc.data['postalCode'] ?? '',
priceClass: doc.data['priceClass'] ?? '',
street: doc.data['street'] ?? '',
streetNumber: doc.data['streetNumber'] ?? '',
rating: doc.data['rating'],
id: doc.documentID,
reviews:  new List<RestaurantReview>())
      );
    }
  
  
   Future addRestaurant(Restaurant res) async{
List<String> reviewIds = new List<String>();
for(RestaurantReview review in res.reviews){
  reviewIds.add(review.id);
}

     return await restaurantCollection.document().setData({
       'name': res.name,
       'country': res.country,
       'city': res.city,
       'postalCode': res.postalCode,
       'street': res.street,
       'streetNumber': res.streetNumber,
       'rating':res.rating,
       'priceClass': res.priceClass,
       'coordinates': res.coordinates,
       'photos': res.photos,
        'reviews': reviewIds,
        'checkincode':res.checkincode,
     });
   }


   List<Restaurant> _resturantListFromSnapshot(QuerySnapshot snapshot) {
return snapshot.documents.map((doc){


return Restaurant(
  city: doc.data['city'] ?? '',
  country: doc.data['country'] ?? '',
  name: doc.data['name'] ?? '',
  photos: doc.data['photos'].cast<String>() ?? new List<String>(),
postalCode: doc.data['postalCode'] ?? '',
priceClass: doc.data['priceClass'] ?? '',
street: doc.data['street'] ?? '',
streetNumber: doc.data['streetNumber'] ?? '',
rating: doc.data['rating'],
coordinates: doc.data['coordinates'].cast<double>(),
checkincode: doc.data['checkincode'],
id: doc.documentID,

reviews:  new List<RestaurantReview>()
  );
}).toList();
   }

   Future<List<Restaurant>> getRestaurantsByCity(String city) async{
     return restaurantCollection.where('city', isEqualTo: city).orderBy('rating', descending: true).getDocuments().then((querySnapshot){  
 return _resturantListFromSnapshot(querySnapshot);
     });
   }

   Future <List<RestaurantReview>> getARestaurantsReviews(Restaurant restaurant) async {
return restaurantReviewCollection.where('restaurant', isEqualTo: restaurant.id).getDocuments().then((querysnapshot) async{
  List<RestaurantReview> reviews = _restaurantReviewListFromSnapshot(querysnapshot,restaurant);
  for(RestaurantReview review in reviews) {
    await getUserFromId(review.foodie.uid).then((value) => review.foodie = value);
  }
return reviews;
});
   }

   List<RestaurantReview> _restaurantReviewListFromSnapshot(QuerySnapshot snapshot,Restaurant res){
return snapshot.documents.map((doc) {
 return RestaurantReview(
id:doc.data['id'],
review: doc.data['review'],
rating: doc.data['rating'],
city:  doc.data['city'],
photos: doc.data['photos'].cast<String>() ?? new List<String>(),
header: doc.data['header'] ?? "",
restaurant: res ?? new Restaurant(id:doc.data['restaurant']),
foodie: new User(uid: doc.data['foodieId']),
);

}).toList();
   }

   Future addRestaurantReview(RestaurantReview resreview) async {
     return await restaurantReviewCollection.document().setData({
       'foodieId': resreview.foodie.uid,
       'review': resreview.review,
       'restaurant': resreview.restaurant.id,
       'photos': resreview.photos,
       'city': resreview.restaurant.city,
       'header': resreview.header,
       'rating': resreview.rating,
     });
   }

   Future<List<RestaurantReview>> getCitysReviews(String city) async{
return restaurantReviewCollection.where('city', isEqualTo: city).getDocuments().then((querysnapshot) async{
  List<RestaurantReview> reviews = _restaurantReviewListFromSnapshot(querysnapshot,null);
  for(RestaurantReview review in reviews){
  
  
    User haps = await getUserFromId(review.foodie.uid);
    await getRestaurantFromId(review.restaurant.id).then((value) => review.restaurant = value);
    review.foodie = haps;
  }
return reviews;
});
   }


// gets all checkins from one user
 Future<List<CheckIn>> getUserCheckIn() async{
return userCheckIns.where('foodie', isEqualTo: uid).getDocuments().then((querysnapshot) async{
  List<CheckIn> checkins =  _checkinsListFromSnapshot(querysnapshot);

  print("Get user checin method: " + checkins.runtimeType.toString());

  for(CheckIn checkIn in checkins){
    print(checkIn.restaurant);
    User user = await getUserFromId(checkIn.foodie.uid);
    await getRestaurantFromId(checkIn.restaurant.id).then((value) => checkIn.restaurant = value);
    checkIn.foodie = user;
  }
  checkins.sort((a, b) => a.time.compareTo(b.time));
return checkins;
});
  }

  //
  Future<Restaurant> getRestaurantFromCheckinCode(String checkincode){
return restaurantCollection.where('checkincode', isEqualTo: checkincode).getDocuments().then((value) => _resturantListFromSnapshot(value)[0]);
  }

// Converts querysnapshot to dart objects
  List<CheckIn> _checkinsListFromSnapshot(snapshot){
return snapshot.documents.map<CheckIn>((doc) {
  print(doc.data['foodie']);
  
 
 return CheckIn(
id:"haps",
restaurant: new Restaurant(id:doc.data['restaurant']),
foodie: new User(uid: doc.data['foodie']),
time:(doc.data["time"] as Timestamp).toDate()
);

}).toList();
   
  }

  Future AddCheckin(CheckIn checkIn)async{
    return await userCheckIns.document().setData({
       'foodie': checkIn.foodie.uid,
       'restaurant': checkIn.restaurant.id,
       'time': checkIn.time,
     });
   }
  



}