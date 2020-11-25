import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:foodies/models/CheckIn.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/models/RestaurantReview.dart';
import 'package:foodies/models/user.dart';
import 'package:foodies/models/user.dart';
import 'package:foodies/screens/check_in/Scan.dart';
import 'package:foodies/screens/profile/profile.dart';
import 'package:foodies/screens/restaurant_page/restaurantPage.dart';
import 'package:foodies/screens/restaurantreview/Res_review_view.dart';
import 'package:foodies/screens/reviewScreen/reviewScreen.dart';
import 'package:foodies/services/database.dart';
import 'package:foodies/shared/constants.dart';
import 'package:foodies/services/auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  int _selectedIndex = 0;
  Future<String> _city;
  Future<List<Restaurant>> _restaurants;
  Future<List<CheckIn>> _checkins;
  Future<List<RestaurantReview>> _reviews;
  User _user;
  DatabaseService _database;
   String barcode = "";
  
  int _index = 0;
final AuthService _auth = AuthService();



    @override
  void initState() {
    super.initState();
    _database = new DatabaseService();

    //  WidgetsBinding.instance
    //     .addPostFrameCallback((_) => yourFunction(context));

    // initial load
    _city =  _getCurrentLocation();
    _checkins = _database.getUserCheckIn();
    _restaurants = _database.getRestaurantsByCity("Aarhus");
    _reviews = _database.getCitysReviews("Aarhus");
     
  }

 

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];


  @override
  Widget build(BuildContext context) {

  int _index = 0;

  

 final tabs = [
    _HomeScreen(context),
    Center(child: Text("Search"),),
    _reviewScreen(context),
    Center(child: Text("Notifications"),),
    UserProfilePage(),
  ];

    


    return Scaffold(
      backgroundColor: Colors.white,
      
      body: tabs[_selectedIndex],
      




      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromRGBO(46, 98, 94, 1),
        selectedFontSize: 14,
        type:BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt,size: 35),

            title: Text('Review!'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('My Profile'),
          ),
          
        ],
        
        selectedItemColor: Colors.teal[300],

        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
   
  }
  Future<String> _getCurrentLocation()async{
    List<Restaurant> rests = Restaurant.getRestaurants();
    
  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   
          final coordinates = new Coordinates(position.latitude, position.longitude);
          List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          Address address = addresses[0];
          
  return address.locality;
  }




  Widget _generateCard(String city){
    return FutureBuilder(
      future: _reviews,
      builder: (BuildContext context, AsyncSnapshot<List<RestaurantReview>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none: return new Text('Press button to start');
      case ConnectionState.waiting: return new Text('Awaiting result...');
      default:
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else{
         List<RestaurantReview> reviews = snapshot.data;

        return Flexible(
                  child: ListView.builder(
            scrollDirection: Axis.horizontal,
            
            itemCount: reviews.length,
            itemBuilder: (BuildContext context, int index) {

            return  GestureDetector(
              onTap: (){
                 Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ResReviewView(resreview: reviews[index])),
  );
              },
                          child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 160,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                      children:<Widget>[
                     GestureDetector(
          child: Container(
          width: 160,
          height: 120,
          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                image: DecorationImage(image: NetworkImage(reviews[index].photos[0]),fit: BoxFit.fill)),
          ),
          onTap: (){
 Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ResReviewView(resreview: reviews[index])),
  );
          },
          
      ),
      Text(reviews[index].restaurant.name),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              GestureDetector(
                  child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(reviews[index].foodie.picturePath),fit: BoxFit.fill)),
                  ),
                  onTap: (){
           //TODO
                  },
              ),
              Text(reviews[index].foodie.name),
          ],
        ),
      ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Text(reviews[index].review.length > 40 ? '${reviews[index].review.substring(0, 40)}...' : reviews[index].review),
        ),
      
                        ListTile(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //title: Text(reviews[index].foodie.name),
                          subtitle: SmoothStarRating(
                  rating: reviews[index].rating,
                  isReadOnly: false,
                  size: 16,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {
                    print("rating value -> $value");
                    // print("rating value dd -> ${value.truncate()}");
                  },
                )),
                      ]
                    )),
                  ),
              ),
            );
            }),
        );
        
        }
    }
  });
       
    
  }

  Widget _generateRestaurants(BuildContext context,String city){
    
    
return new FutureBuilder<List<Restaurant>>(
  future: _restaurants,
builder: (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none: return new Text('Press button to start');
      case ConnectionState.waiting: return new Text('Awaiting result...');
      default:
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else{
         List<Restaurant> restaurants = snapshot.data;
         
        
          return Center(
        child: SizedBox(
          height: 200, // card height
          child: PageView.builder(
            itemCount: restaurants.length,
            controller: PageController(viewportFraction: 0.7),
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (_, i) {
              return Transform.scale(
                scale: i == _index ? 1 : 0.9,
                child: Card(
                  elevation: 4,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: GestureDetector(
                                      child: Stack(
                                        children:   [Center(
                                          child: Container(
          
          height: 200,
          decoration: BoxDecoration(
             borderRadius: BorderRadius.only(
              topRight: Radius.circular(7.0),
              bottomRight: Radius.circular(7.0),
             topLeft: Radius.circular(7.0),
              bottomLeft: Radius.circular(7.0)), 

            image: DecorationImage(image: NetworkImage(restaurants[i].photos[0]),fit: BoxFit.fill)),
          ),
                                          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Align(
              alignment: Alignment.bottomLeft,
                          child: Container(
                
                color: Colors.white54,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("   "+restaurants[i].name,style: TextStyle(fontFamily: "montserrat", fontSize: 16),
                      ),
                      Text(restaurants[i].rating.toString()+"  ")
        //             SmoothStarRating(
        //   rating: 3,
        //   isReadOnly: false,
        //   size: 16,
        //   filledIconData: Icons.star,
        //   halfFilledIconData: Icons.star_half,
        //   defaultIconData: Icons.star_border,
        //   starCount: 5,
        //   allowHalfRating: true,
        //   spacing: 2.0,
        //   onRated: (value) {
        //     print("rating value -> $value");
        //     // print("rating value dd -> ${value.truncate()}");
        //   },
        // )
                    ],
                )),
            ),
          )],
                    ),
                    onTap: (){
             
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  RestaurantPage(restaurant: restaurants[i])),
  );
                     
                    },
                  ),
                  ),
                
              );
            },
          )));
        
        }
    }
  });

      
  }

  Widget _HomeScreen(BuildContext context){

final user = Provider.of<User>(context);
final database = DatabaseService(uid:user.uid);
    

   Widget _buildExploreCity(BuildContext context) {

     
    //  if(city != ""){
    //    return Center(child: new Text("Explore " + city,style: TextStyle(fontFamily: "Montserrat",fontSize: 38,color: Colors.teal,fontWeight: FontWeight.bold),));
    //  }
    return new FutureBuilder<String>(
  future: _city, // a Future<String> or null
  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none: return new Text('Press button to start');
      case ConnectionState.waiting: return new Text('Awaiting result...');
      default:
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else{
         String city = snapshot.data;
         
        
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Text("Explore " + city,style: TextStyle(fontFamily: "Montserrat",fontSize: 38,color: Colors.teal,fontWeight: FontWeight.bold),),
              Text("Top rated restaurants in " + city, style: TextStyle(),),
              _generateRestaurants(context,"Aarhus"),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
                child: Text("Top rated reviews " + city, style: TextStyle(),),
              ),
            ],
          );
        }
    }
  },
);
  }
  


    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
        SizedBox(height: 30,),
_buildExploreCity(context),
_generateCard(""),


      ],),
    );




    
  }

  Widget _reviewScreen(BuildContext context){

final user = Provider.of<User>(context);
final database = DatabaseService(uid:user.uid);
    

   Widget _buildCheckInList(BuildContext context) {

//      StreamBuilder<QuerySnapshot>(
//   stream: Firestore.instance.collection('books').snapshots().where((e) => false),
//   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     if (!snapshot.hasData) return new Text('Loading...');
//     return new ListView(
//       children: snapshot.data.documents.map((DocumentSnapshot document) {
//         return new ListTile(
//           title: new Text(document['title']),
//           subtitle: new Text(document['author']),
//         );
//       }).toList(),
//     );
//   },
// );

    return new FutureBuilder<List<CheckIn>>(
  future: _checkins, // a Future<String> or null
  builder: (BuildContext context, AsyncSnapshot<List<CheckIn>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none: return new Text('Press button to start');
      case ConnectionState.waiting: return new Text('Awaiting result...');
      default:
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else{
        List<CheckIn> checkIns = new List<CheckIn>.from(snapshot.data);
      
        
          return 
            Column(
              children: [
                Padding(padding:EdgeInsets.all(12)),
                Text("Your Check-ins", style: TextStyle(fontSize: 22),),
                Expanded(
                                  child: ListView.builder(
  padding: const EdgeInsets.all(8),
  itemCount: checkIns.length,
  itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50,
       
        child: ListTile(
          
          title: Column(
            children: [
              Center(child: Text(checkIns[index].restaurant.name)),
              Center(child: Text(checkIns[index].time.toString()),),
            ],
          ),
          
          onTap: (){
                    Navigator
                    .push(
                  context,
                  new MaterialPageRoute(builder: (context) => new ReviewScreen(checkIn:checkIns[index],restaurant: checkIns[index].restaurant,)),
                );

          },
          ),
      ),
    );
  }
),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
        onPressed: ()async {
          await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScanPage()),
                            );
                            setState(() {
                              //Updates the Review screen UI showing the newly added checkin
                              _checkins = _database.getUserCheckIn();
                            });
        },
        label: Text("Check-in"),
        icon: Icon(Icons.add_location),
        backgroundColor: Colors.teal[300],
      ),
                    ],
                  ),
                ),
              ],
              
            );
          
        }
    }
  },
);
  }


  


    return Scaffold(
      body: 
      // Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        // children: [
        // SizedBox(height: 30,),
        // Text("data"),
//          RaisedButton(
//             onPressed: () async{
// Restaurant res = await database.getRestaurantsByCity("Aarhus").then((value) => value[1]);
// User user = await database.getUserFromId(database.uid);

// CheckIn checkin = new CheckIn(foodie:user, restaurant: res,time:DateTime.now());
//              await database.AddCheckin(checkin);
//             },
//             child: const Text('Enabled Button', style: TextStyle(fontSize: 20)),
//           ),
          _buildCheckInList(context),
//_buildExploreCity(context),
//_generateCard(""),


      // ],)
    );




    
  }




}