import 'package:flutter/material.dart';
import 'package:foodies/models/CheckIn.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/screens/reviewScreen/addReviewPhotos.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewScreen extends StatefulWidget {
  final CheckIn checkIn;
  final Restaurant restaurant;
   ReviewScreen({Key key,this.checkIn,this.restaurant}) : super(key: key);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
double _foodRating = 999;
double _serviceRating = 999;
double _pricesRating = 999;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
          body: SingleChildScrollView(
                      child: Container(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
SizedBox(height:30),
Text(widget.restaurant.name, style: TextStyle(fontFamily: "Montserrat",fontSize: 38,color: Colors.teal,fontWeight: FontWeight.bold),),
Text("Date of visit: " + widget.checkIn.time.day.toString() +"-" +widget.checkIn.time.month.toString()+"-"  + widget.checkIn.time.year.toString()),
SizedBox(height: 30,),
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

  SizedBox(height: 30,),
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
              print("rating value -> $value");
              // print("rating value dd -> ${value.truncate()}");
            },
        ),

SizedBox(height: 30,),
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
SizedBox(height: 30,),
        TextField(
      minLines: 8,
      maxLines: 15,
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
    ),
    SizedBox(height: 20,),
    RaisedButton.icon(
      color: Colors.teal[300],
      icon: Icon(Icons.add_a_photo_outlined), 
      label: Text("Add images"),
      onPressed: (){

             Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AddReviewPhotos()),
  );
      },)
        

              ],),
            ),
        )
      ),
          ),
    );
  }
}