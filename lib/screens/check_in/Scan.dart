import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodies/models/CheckIn.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/models/user.dart';
import 'package:foodies/services/database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult;
  String errorLbl = "";
  DatabaseService database = new DatabaseService();
  bool backCamera = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        appBar: AppBar(
          title:
              Text("Scan using:" + (backCamera ? " Front Cam" : " Back Cam")),
          backgroundColor: Colors.teal[300],
          actions: <Widget>[
            IconButton(
              icon: backCamera
                  ? Icon(Ionicons.ios_reverse_camera)
                  : Icon(Icons.camera),
              onPressed: () {
                setState(() {
                  backCamera = !backCamera;
                  camera = backCamera ? 1 : -1;
                });
              },
            ),
            IconButton(
              icon: Icon(MaterialCommunityIcons.qrcode_scan),
              onPressed: () async {
                ScanResult result = await BarcodeScanner.scan(
                  options: ScanOptions(
                    useCamera: camera,
                  ),
                );
                setState(() {
                  qrCodeResult = result.rawContent;
                });
              },
            )
          ],
        ),
        body: (qrCodeResult == null) || (qrCodeResult == "")
            ? Center(
                child: Text("Scan QR-code by clicking in the right corner"),
              )
            : new FutureBuilder<Restaurant>(
                future: database.getRestaurantFromCheckinCode(
                    qrCodeResult), // a Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Press button to start');
                    case ConnectionState.waiting:
                      return new Text('Awaiting result...');
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else {
                        Restaurant restaurant = snapshot.data;

                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                  height: 200,
                                  child: Image.network(restaurant.photos[0])),
                              Text(restaurant.name),
                              Text(restaurant.city),
                              Text(restaurant.street +
                                  " " +
                                  restaurant.streetNumber),
                              Text(
                                errorLbl,
                                style: TextStyle(color: Colors.red),
                              ),
                              RaisedButton.icon(
                                  onPressed: () async {
                                    bool checkInLocation =
                                        await checkinLocation(restaurant);
                                    if (checkInLocation) {
                                      CheckIn newCheckIn = CheckIn(
                                          foodie: user,
                                          restaurant: restaurant,
                                          time: DateTime.now());
                                      await database.addCheckin(newCheckIn);

                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        SystemNavigator.pop();
                                      }
                                    } else {
                                      setState(() {
                                        errorLbl =
                                            "Please move closer to the restaurant";
                                      });
                                    }


                                  },
                                  icon: Icon(Icons.add_location),
                                  label: Text("Check-in"))
                            ],
                          ),
                        );
                      }
                  }
                },
              ));
  }

  Future<Coordinates> _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    return coordinates;
  }
  Future<bool> checkinLocation(Restaurant restaurant) async {
    Coordinates userCoordinates = await _getCurrentLocation();

    double metersFromRestaurant = await Geolocator().distanceBetween(
        userCoordinates.latitude,
        userCoordinates.longitude,
        restaurant.coordinates[0],
        restaurant.coordinates[1]);

//Checks whether the device is within 70 meters of the restaurant
    return (metersFromRestaurant < 70);
  }
}

int camera = 1;
