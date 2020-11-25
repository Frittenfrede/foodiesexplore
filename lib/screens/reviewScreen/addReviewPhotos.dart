import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';

class AddReviewPhotos extends StatefulWidget {
  @override
  _AddReviewPhotosState createState() => _AddReviewPhotosState();
}

class _AddReviewPhotosState extends State<AddReviewPhotos> {
// _getImageList() async {
//     var resultList = await MultiImagePicker.pickImages(
//       maxImages :  10 ,
//       enableCamera: true,
//     );

//     Future<dynamic> postImage(Asset imageFile) async {
//     await imageFile.requestOriginal();
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//     StorageUploadTask uploadTask = reference.putData(imageFile.imageData.buffer.asUint8List());
//     StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//     return storageTaskSnapshot.ref.getDownloadURL();
//   }
    
//     // The data selected here comes back in the list
//     print(resultList);
//     for ( var imageFile in resultList) {
//          postImage(imageFile).then((downloadUrl) {
//             // Get the download URL
//             print(downloadUrl.toString());
//          }).catchError((err) {
//            print(err);
//          });
//     }
// }
   @override
   Widget build(BuildContext context) {
    return Container(
// child: RaisedButton.icon(onPressed: ()async{

//   return await _getImageList();

// }, icon: Icon(Icons.add_a_photo_outlined), label: Text("null"))
      
      
    );

  }
 }