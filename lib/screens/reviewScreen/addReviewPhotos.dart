import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddReviewPhotos extends StatefulWidget {
  @override
  _AddReviewPhotosState createState() => _AddReviewPhotosState();
}

class _AddReviewPhotosState extends State<AddReviewPhotos> {
  List<Asset> _images = new List<Asset>();
  List<String> _descriptions = new List<String>();
  List<TextEditingController> _controllers = new List();

  StorageUploadTask sut;

  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (TextEditingController _tec in _controllers) {
      _tec.dispose();
    }
    super.dispose();
  }

  Widget _afterPictureAdded() {
    return Column(children: [
      buildPictureList(),
      RaisedButton.icon(
          onPressed: () async {
            for (TextEditingController tec in _controllers) {
              _descriptions.add(tec.text);
            }
            await _submitPictures();
          },
          icon: Icon(Icons.restaurant),
          label: Text("Add Photos")),
    ]);
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

//Collects the pictures in a list of files
  _submitPictures() async {
    List<File> imageFiles = new List<File>();
    for (Asset image in _images) {
      var imagePath =
          await FlutterAbsolutePath.getAbsolutePath(image.identifier);
      var file = await getImageFileFromAsset(imagePath);
      imageFiles.add(file);
    }
    ReviewPhotoData rpd = ReviewPhotoData(imageFiles, _descriptions);
    Navigator.pop(context, rpd);
  }

  Widget buildPictureList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          _controllers.add(new TextEditingController());
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text(
                  "Picture number " + (index + 1).toString(),
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(30)),
                  ),
                  child: AssetThumb(
                    asset: _images[index],
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  minLines: 3,
                  maxLines: 6,
                  autocorrect: true,
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    hintText: 'Write a picture description (optional)',
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
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Foodies Club",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      _images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_images.length > 0)
          ? _afterPictureAdded()
          : Container(
              child: Column(
                children: <Widget>[
                  Center(child: Text('Error: $_error')),
                  RaisedButton(
                    child: Text("Pick images"),
                    onPressed: loadAssets,
                  ),
                  Expanded(
                    child: buildPictureList(),
                  )
                ],
              ),
            ),
    );
  }
}

// Class for transferring data between windows
class ReviewPhotoData {
  List<File> images;
  List<String> descriptions;

  ReviewPhotoData(this.images, this.descriptions);
}
