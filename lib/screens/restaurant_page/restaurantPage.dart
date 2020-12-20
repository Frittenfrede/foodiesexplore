import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/models/RestaurantReview.dart';
import 'package:foodies/models/user.dart';
import 'package:foodies/services/database.dart';
import 'package:provider/provider.dart';
import 'package:foodies/customicon/customIcon/custom_icons.dart' as CustomIcon;
import 'package:foodies/customicon/customIcon/chef_hat_icons.dart' as Chef_hats;
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantPage({Key key, this.restaurant}) : super(key: key);
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final database = DatabaseService(uid: user.uid);

    Widget _photoBuilder(RestaurantReview review) {
      if (review.photos.length == 0) {
        return null;
      } else if (review.photos.length == 1) {
        return Container(
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2, color: Colors.teal[300])),
            //height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.network(
              review.photos[0],
              fit: BoxFit.fill,
            ));
      } else if (review.photos.length == 2) {
        return Row(
          children: [
            Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.teal[300])),
                //height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.network(
                  review.photos[0],
                  fit: BoxFit.fill,
                )),
            SizedBox(
              width: 5,
            ),
            Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.teal[300])),
                //height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.network(
                  review.photos[1],
                  fit: BoxFit.fill,
                )),
          ],
        );
      } else if (review.photos.length > 2) {
        return Row(
          children: [
            Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.teal[300])),
                //height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.network(
                  review.photos[0],
                  fit: BoxFit.fill,
                )),
            Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.teal[300])),
                //height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.network(
                  review.photos[1],
                  fit: BoxFit.fill,
                )),
            Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: Colors.teal[300])),
                //height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.network(
                  review.photos[2],
                  fit: BoxFit.fill,
                )),
          ],
        );
      }
    }

    return Container(
        child: Scaffold(
            body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        CarouselSlider(
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.3, autoPlay: true),
          items: widget.restaurant.photos.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Image(image: NetworkImage(i)),
                );
              },
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.restaurant.name,
                  style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.normal)),
              Text(
                widget.restaurant.rating.toString(),
                style: TextStyle(
                    fontFamily: 'montserrat',
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  widget.restaurant.city + " " + widget.restaurant.country,
                  style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.normal)),
            )),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  widget.restaurant.street +
                      " " +
                      widget.restaurant.streetNumber,
                  style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.normal)),
            )),
        FutureBuilder<List<RestaurantReview>>(
            future: database.getARestaurantsReviews(widget.restaurant),
            builder: (BuildContext context,
                AsyncSnapshot<List<RestaurantReview>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Press button to start');
                case ConnectionState.waiting:
                  return new Text('Awaiting result...');
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else {
                    List<RestaurantReview> reviews = snapshot.data;

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      child: Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    reviews[index]
                                                        .foodie
                                                        .picturePath),
                                                fit: BoxFit.fill)),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.080,
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          reviews[index].header,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SmoothStarRating(
                                          rating: reviews[index].rating,
                                          isReadOnly: false,
                                          size: 24,
                                          filledIconData:
                                              Chef_hats.Chef_hat.chef_hat,
                                          halfFilledIconData:
                                              Chef_hats.Chef_hat.chef_hat,
                                          defaultIconData: Icons.star_border,
                                          starCount: 5,
                                          allowHalfRating: true,
                                          spacing: 2.0,
                                          onRated: (value) {
                                            print("rating value -> $value");
                                            // print("rating value dd -> ${value.truncate()}");
                                          },
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(reviews[index]
                                                        .review
                                                        .length >
                                                    80
                                                ? '${reviews[index].review.substring(0, 80)}...'
                                                : reviews[index].review)),

                                        _photoBuilder(reviews[index]),
                                        //  Container(
                                        //    //color: Colors.teal[300],
                                        //    decoration: BoxDecoration(
                                        //      color: Colors.teal[100],
                                        //      borderRadius: BorderRadius.all(Radius.circular(40))

                                        //      ),
                                        //    child: IconButton(

                                        //      //iconSize: 50,
                                        //      onPressed: (){},
                                        //      //alignment: Alignment.centerLeft,
                                        //      padding: EdgeInsets.all(0),
                                        //      icon:Icon(CustomIcon.Custom.kokkehattest2__1_,color: Color.fromRGBO(46, 98, 94, 1),size: 45,), color: Colors.teal[300],),
                                        //  ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          }),
                    );
                  }
                  ;
              }
            })
      ]),
    )));
  }
}
