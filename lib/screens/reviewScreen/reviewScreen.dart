import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodies/models/CheckIn.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/models/RestaurantReview.dart';
import 'package:foodies/models/user.dart';
import 'package:foodies/screens/reviewScreen/addReviewPhotos.dart';
import 'package:foodies/services/database.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewScreen extends StatefulWidget {
  final CheckIn checkIn;
  final Restaurant restaurant;
  ReviewScreen({Key key, this.checkIn, this.restaurant}) : super(key: key);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _foodRating = 999;
  double _serviceRating = 999;
  double _pricesRating = 999;
  String _headerText = "";
  String _reviewText = "";
  String _informationLine = "Your pictures was succesfully added";
  ReviewPhotoData _reviewPhotoData;
  RestaurantReview _resReview = new RestaurantReview();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final database = DatabaseService(uid: user.uid);

    Future<List<String>> _addPhotosToFirebase(List<File> photos) async {
      List<String> photoPaths = new List<String>();
      for (File file in photos) {
        String filePath = 'review_images/ ' +
            widget.restaurant.name +
            "/" +
            DateTime.now().toString() +
            ".png";
        final FirebaseStorage _storage = FirebaseStorage(
            storageBucket: "gs://foodies-club-7c753.appspot.com");
        StorageUploadTask _uploadTask =
            _storage.ref().child(filePath).putFile(file);
        String docUrl =
            await (await _uploadTask.onComplete).ref.getDownloadURL();
        photoPaths.add(docUrl);
      }
      return photoPaths;
    }

    Widget _bottomScreenWidget() {
      return _reviewPhotoData == null
          ? RaisedButton.icon(
              color: Colors.teal[300],
              icon: Icon(Icons.add_a_photo_outlined),
              label: Text("Add images"),
              onPressed: () async {
                ReviewPhotoData tempData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddReviewPhotos()),
                );
                setState(() {
                  _reviewPhotoData = tempData;
                });
              },
            )
          : Column(
              children: [
                Text(_informationLine),
                RaisedButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: Text("Add review"),
                    onPressed: () async {
                      print(_headerText);
                      if (_foodRating != 999 &&
                          _serviceRating != 999 &&
                          _pricesRating != 999) {
                        if (_headerText != "") {
                          if (_reviewText != "") {
                            List<RestaurantReview> formerReviews =
                                await database.getARestaurantsReviews(widget.restaurant);
                            double averageRating = (_foodRating + _serviceRating + _pricesRating) /3;
                            double finalRating = (formerReviews.length > 0)
                                ? ((widget.restaurant.rating * formerReviews.length) + averageRating) /
                                  (formerReviews.length + 1)
                                : averageRating;
                            List<String> uploadedPhotos = await _addPhotosToFirebase(_reviewPhotoData.images);
                            RestaurantReview resReview = new RestaurantReview(
                                city: widget.restaurant.city,
                                foodie: user,
                                header: _headerText,
                                review: _reviewText,
                                restaurant: widget.restaurant,
                                photoDescriptions:
                                    _reviewPhotoData.descriptions,
                                photos: uploadedPhotos,
                                rating: averageRating);

                            await database.addRestaurantReview(resReview);
                            await database.updateRestaurantRating(
                                widget.restaurant, finalRating);
                            await database.deleteCheckIn(widget.checkIn);
                            Navigator.of(context).pop(true);
                          } else {
                            setState(() {
                              _informationLine = "Please write a review";
                            });
                          }
                        } else {
                          setState(() {
                            _informationLine = "Please write a header";
                          });
                        }
                      } else {
                        setState(() {
                          _informationLine = "Please choose the 3 parameters";
                        });
                      }
                    })
              ],
            );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 30, 8, 10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Text(
                  widget.restaurant.name,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 38,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
                Text("Date of visit: " +
                    widget.checkIn.time.day.toString() +
                    "-" +
                    widget.checkIn.time.month.toString() +
                    "-" +
                    widget.checkIn.time.year.toString()),
                SizedBox(
                  height: 30,
                ),
                Text("How happy were you with the food?"),
                SmoothStarRating(
                  rating: 3,
                  isReadOnly: false,
                  size: 22,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {
                    _foodRating = value;
                    print("rating value -> $value");
                    // print("rating value dd -> ${value.truncate()}");
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Text("How happy were you with the service?"),
                SmoothStarRating(
                  rating: 3,
                  isReadOnly: false,
                  size: 22,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {
                    _serviceRating = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Text("How happy were you with the prices?"),
                SmoothStarRating(
                  rating: 3,
                  isReadOnly: false,
                  size: 22,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {
                    _pricesRating = value;
                    print("rating value -> $value");
                    // print("rating value dd -> ${value.truncate()}");
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  minLines: 1,
                  maxLines: 12,
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Write your header here',
                    filled: true,
                    fillColor: Color(0xFFDBEDFF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (text) {
                    _headerText = text;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  minLines: 6,
                  maxLines: 12,
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Write your review here',
                    filled: true,
                    fillColor: Color(0xFFDBEDFF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (text) {
                    _reviewText = text;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _bottomScreenWidget(),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
