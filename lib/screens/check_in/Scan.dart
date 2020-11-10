import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/services/database.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult;
 DatabaseService database = new DatabaseService();
  bool backCamera = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan using:" + (backCamera ? "Front Cam" : "Back Cam")),
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
        body: (qrCodeResult == null)||(qrCodeResult == "")
                ? Center(child: Text("Scan QR-code by clicking in the right corner"),)
                :  new FutureBuilder<Restaurant>(
  future: database.getRestaurantFromCheckinCode(qrCodeResult), // a Future<String> or null
  builder: (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none: return new Text('Press button to start');
      case ConnectionState.waiting: return new Text('Awaiting result...');
      default:
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else{
         Restaurant restaurant = snapshot.data;
         
        
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           Text(restaurant.name)
            ],
          );
        }
    }
  },
));
        
      
  }
}

int camera = 1;