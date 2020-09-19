import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies/models/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:foodies/screens/authenticate/authExceptionHandler.dart';
import 'package:foodies/screens/authenticate/authResultStatus.dart';
import 'package:foodies/services/database.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus _status;


// Create user obj based on FirebaseUser
User _userFromFirebaseUser(FirebaseUser user){
  return user != null ? User(uid: user.uid, name: user.displayName, email: user.email, picturePath: user.photoUrl) : null;
}

// auth change user stream
Stream<User> get user {
  return _auth.onAuthStateChanged
 .map(_userFromFirebaseUser);
}

Future<FirebaseUser> get firebaseUser async{
  return await _auth.currentUser();
}


// sign in anon
Future signInAnon() async {
  try{
AuthResult result = await _auth.signInAnonymously();
FirebaseUser user = result.user;
return _userFromFirebaseUser(user);
  } catch(e){
print(e.toString());
return null;
  }
}

// sign in with email and password

Future<AuthResultStatus> signInWithEmailAndPassword(String email, String password) async {
  try{
  AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user = result.user;
  if(user != null)
  _status = AuthResultStatus.successful;
  else
  _status = AuthResultStatus.undefined;

  return _status;

  }
  catch(e){
print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
return null;
  }
}

//register with email and password
Future<AuthResultStatus> registerWithEmailAndPassword(String email, String password, String name) async {
  try{
  AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  FirebaseUser user = result.user;
  DatabaseService ds = new DatabaseService(uid: user.uid);
  await ds.updateUserData(email, name, "");
 if(user != null){
 UserUpdateInfo updateinfo = UserUpdateInfo();
 updateinfo.displayName = name;
 _status = AuthResultStatus.successful;
 await user.updateProfile(updateinfo);
 
 }
else
  _status = AuthResultStatus.undefined;

  return _status;
  }
  catch(e){
print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
return null;
  }
}


// sign out
Future signOut() async {
  try{
return await _auth.signOut();
  } catch(e){
print(e.toString());
return null;
  }
}

// Sign up with Facebook
Future<AuthResultStatus> signUpWithFacebook() async{
  
final facebookLogin = FacebookLogin();
final result = await facebookLogin.logIn(['email']);
if(result.accessToken != null){
final token = result.accessToken.token;

final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name&access_token=${token}');
    print(graphResponse.body);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(accessToken: token);
      try{
      _auth.signInWithCredential(credential);
      FirebaseUser user = await _auth.currentUser();
       DatabaseService ds = new DatabaseService(uid: user.uid);
      await ds.updateUserData(user.email, user.displayName,user.photoUrl);
      _status = AuthResultStatus.successful;
      }
      catch(e){
        _status = AuthResultStatus.undefined;
        print(e);
      }
      
    }
      else if(result.status == FacebookLoginStatus.cancelledByUser){
      print(result);
      _status = AuthResultStatus.undefined;
      }
      else if(result.status == FacebookLoginStatus.error){
        _status = AuthResultStatus.undefined;
      }
      else {

        print(result.errorMessage);
        
      }
      return _status;
// switch (result.status) {
//   case FacebookLoginStatus.loggedIn:
//     _sendTokenToServer(result.accessToken.token);
//     _showLoggedInUI();
//     break;
//   case FacebookLoginStatus.cancelledByUser:
//     _showCancelledMessage();
//     break;
//   case FacebookLoginStatus.error:
//     _showErrorOnUI(result.errorMessage);
//     break;
    }
    }

    // Sign in with Google
    Future signInWithGoogle() async{
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

      try{
    _googleSignIn.signIn();
    final googleUser = await _googleSignIn.signIn(); //Crashing here
final googleAuth = await googleUser.authentication;
final AuthCredential credential = GoogleAuthProvider.getCredential(
	accessToken: googleAuth.accessToken,
	idToken: googleAuth.idToken,
);

await _auth.signInWithCredential(credential);
FirebaseUser user = await _auth.currentUser();
       DatabaseService ds = new DatabaseService(uid: user.uid);
      await ds.updateUserData(user.email, user.displayName, user.photoUrl);
    print(await _auth.currentUser());
      }
      catch(e){
        print(e);
      }
    }

}