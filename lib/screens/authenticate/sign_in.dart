import 'package:flutter/material.dart';
import 'package:foodies/services/auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:foodies/shared/constants.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();

  //text field state
  String email = "";
  String password = "";
  String error = "";

  bool _passwordVisible = false;

  Function loginWithGoogle(){

}
 //Function for facebook login
Function loginWithFacebook(){

}

Widget _signInButton(String picturePath, Function onPressedFunction,String buttonText) {
    return ButtonTheme(
      minWidth: 260,
          child: OutlineButton( 
        splashColor: Colors.teal[300],
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(picturePath), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false ,
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Text("Sign in to Foodie Club")
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
                  child: Column(
            children: <Widget>[
              SizedBox(height: 50.0,),
              _signInButton("assets/images/facebook_logo.png",loginWithFacebook(),"Login with Facebook"),
SizedBox(height: 20.0,),
// Google sign in button
_signInButton("assets/images/google_logo.png",loginWithGoogle(),"Login with Google"),
SizedBox(height: 30.0,),
SizedBox(height: 20.0,),
Text("--- or ---",style: TextStyle(color: Colors.black54),),
              SizedBox(height: 20.0,),
              
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email", hintStyle: TextStyle(fontFamily: 'Montserrat')),
                 validator: (val)=> val.isEmpty ? "Enter a valid email" : null,
                onChanged: (val){
          setState(() {
              email = val;
          });
              },),
               SizedBox(height: 20.0,),
               TextFormField(
                 decoration: textInputDecoration.copyWith(
                   hintText: "Password",
                    hintStyle: TextStyle(fontFamily: 'Montserrat'),
                   suffixIcon: IconButton(
                                 icon: Icon(
              // Based on passwordVisible state choose the icon
               _passwordVisible
               ? Icons.visibility
               : Icons.visibility_off,
               
               ),onPressed: (){

                 setState(() {
                   _passwordVisible = !_passwordVisible;
               });
               },
                   )),
                  validator: (val)=> val.length < 6 ? "Enter a password 6+ chars long" : null,
                 obscureText: true,
                 onChanged: (val){
          setState(() {
              password = val;
          });
              },),
               SizedBox(height: 20.0,),
               ButtonTheme(
                 minWidth: 200,
                                child: RaisedButton(
                   color: Color.fromRGBO(46, 98, 94, 1),
                   highlightColor: Colors.teal[300],
                   child: Text("LOGIN", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),),shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
                   onPressed: () async {
                  if(_formKey.currentState.validate()){
                   
                   dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                    if(result == null){
                        setState(() {
                          error = "could not sign in with those credentials";
                        });
                    }
                  }}

                   ),
               ),
                  SizedBox(height: 12,),
                 Text(error, style: TextStyle(color: Colors.red, fontSize: 14),),

              
            ]
          ),
        )
        
        
        ),
       
      );
    
  }
}