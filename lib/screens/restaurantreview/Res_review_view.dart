import 'package:flutter/material.dart';
import 'package:foodies/models/RestaurantReview.dart';
import 'package:foodies/screens/restaurant_page/restaurantPage.dart';

class ResReviewView extends StatefulWidget {
  final RestaurantReview resreview;
  ResReviewView({Key key, this.resreview}) : super(key: key);

  @override
  _ResReviewViewState createState() => _ResReviewViewState();
}

class _ResReviewViewState extends State<ResReviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 26,
          ),
          GestureDetector(
              child: Text(
                widget.resreview.restaurant.name,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantPage(
                          restaurant: widget.resreview.restaurant)),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Row(children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image:
                              NetworkImage(widget.resreview.foodie.picturePath),
                          fit: BoxFit.fill)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.resreview.review),
                  ),
                )
              ]),
              onTap: () {
                //TODO
              },
            ),
          ),
        ],
      ),
    );
  }
}
