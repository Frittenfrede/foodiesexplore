import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodies/models/Restaurant.dart';
import 'package:foodies/models/RestaurantReview.dart';
import 'package:foodies/models/user.dart';
import 'package:foodies/services/auth.dart';
import 'package:foodies/services/database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}
//https://gist.github.com/Blasanka/3e53d2f22ecbac9f9e937dcaf3c1f563

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _auth = AuthService();
  String _fullName = "Nick Frost";

  String _status = "Software Developer";

  String _bio =
      "\"Hi, I am a Freelance developer. I have a great passion for food, especially food from the asian kitchen. Follow me to get restaurant reviews from all over the globe.\"";

  String _followers = "173";

  String _posts = "24";

  String _scores = "450";

  String _imagePath = "";

  // Keeping check with the imageupload
  StorageUploadTask _uploadTask;

// image picker
  final ImagePicker _picker = ImagePicker();
  File _imageFile;

  Widget _buildCoverImage(Size screenSize, User user) {
    return Container(
      height: screenSize.height / 2.6,
      child: Card(
          shadowColor: Colors.grey,
          color: Color.fromRGBO(46, 98, 94, 1),
          child: Center(child: Image.asset("assets/images/resturant.jpg"))),
    );
  }

  Future<void> _pickImage(ImageSource source, FirebaseUser user) async {
    PickedFile file = await _picker.getImage(source: source);

    setState(() {
      if (file != null) _imageFile = File(file.path);
    });
    await _cropImage(user);
  }

// uploads file to bucket
  void _startUpload(File file, FirebaseUser user) async {
    String filePath =
        'images/ ' + _fullName + "/" + DateTime.now().toString() + ".png";
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: "gs://foodies-club-7c753.appspot.com");
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(file);
    });
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    print(docUrl);
    await _updateuserProfilePicture(user, docUrl);
  }

//Updates the users profile picture
  Future _updateuserProfilePicture(FirebaseUser user, String filepath) async {
    UserUpdateInfo updateinfo = UserUpdateInfo();
    updateinfo.photoUrl = filepath;
    await user.updateProfile(updateinfo);
    setState(() {
      _imagePath = filepath;
    });
  }

  // cropimage and save image to firebase bucket
  Future<void> _cropImage(FirebaseUser user) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Adapt your profile picture',
            toolbarColor: Color.fromRGBO(46, 98, 94, 1),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _imageFile = croppedFile;
      setState(() {
        _imageFile = croppedFile ?? _imageFile;
        _startUpload(_imageFile, user);
      });
    }
  }

  // remove image
  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  // choose between camera or photolibrary
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Take a picture from camera"),
                  onTap: () async {
                    _pickImage(ImageSource.camera, await _auth.firebaseUser);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Choose from photo library"),
                  onTap: () async {
                    _pickImage(ImageSource.gallery, await _auth.firebaseUser);
                    Navigator.pop(context);
                  },
                )
              ]));
        });
  }

  Widget _buildProfileImage(User user) {
    _imagePath = user.picturePath;
    return Center(
      child: GestureDetector(
        child: Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(_imagePath), fit: BoxFit.fill)),
        ),
        onTap: () {
          _showOptions(context);
        },
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Reviews", _posts),
          _buildStatItem("Rating", _scores),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Get in Touch with ${_fullName.split(" ")[0]},",
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final user = Provider.of<User>(context);
    final database = DatabaseService(uid: user.uid);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async {
                List<Restaurant> rests =
                    await database.getRestaurantsByCity("aarhus");
                print(rests);
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "FOLLOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () async {
                final AuthService _auth = AuthService();
                List<Restaurant> rests =
                    await database.getRestaurantsByCity("aarhus");
                RestaurantReview temp = RestaurantReview(
                    foodie: user,
                    review:
                        "De dampede muslinger var superb, dog var bøffen lidt for gennemstegt",
                    rating: 4.3,
                    restaurant: rests[1],
                    city: "aarhus",
                    photos: [
                      'https://media-cdn.tripadvisor.com/media/photo-f/19/8f/8f/dc/carpaccio-a-la-ombord.jpg',
                      'https://media-cdn.tripadvisor.com/media/photo-f/19/8f/8f/6b/ceviche-af-hellefisk.jpg'
                    ]);

                RestaurantReview temp1 = RestaurantReview(
                    foodie: user,
                    review:
                        "Lækre små anretninger der passer til enhver smag og de er inspireret af de spanske køkken",
                    rating: 4.1,
                    city: "aarhus",
                    restaurant: rests[1],
                    photos: [
                      'https://media-cdn.tripadvisor.com/media/photo-s/1a/34/bb/c8/chiagrod.jpg',
                      'https://media-cdn.tripadvisor.com/media/photo-s/18/f7/af/38/desserter.jpg'
                    ]);
                await database.addRestaurantReview(temp);
                await database.addRestaurantReview(temp1);
                //await _auth.signOut();
                // await database.addRestaurant(Restaurant.getRestaurants()[0]);
                //  await database.addRestaurant(Restaurant.getRestaurants()[1]);
                //   await database.addRestaurant(Restaurant.getRestaurants()[2]);
                //    await database.addRestaurant(Restaurant.getRestaurants()[3]);
                //     await database.addRestaurant(Restaurant.getRestaurants()[4]);
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "MESSAGE",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _fullName = user.name;

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildCoverImage(screenSize, user),
                  // SizedBox(height: screenSize.height / 3),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 8.0, 8.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildProfileImage(user),
                        Expanded(
                          child: Column(
                            children: [
                              _buildFullName(),
                              _buildStatus(context),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: (screenSize.width / 6.0),
                        )
                      ],
                    ),
                  ),
                  _buildStatContainer(),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  _buildGetInTouch(context),
                  SizedBox(height: 8.0),
                  _buildButtons(context),
                  _buildButtons(context),
                  _buildButtons(context),
                  _buildButtons(context),
                  _buildButtons(context),
                  _buildButtons(context),
                  _buildButtons(context),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
