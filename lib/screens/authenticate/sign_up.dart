import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:foodies/services/auth.dart';
import 'package:foodies/shared/constants.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

String name = "";
String email = "";
String password = "";
String error = "";
bool _passwordVisible = false;
bool tAndC = false;
bool newsLetter = false;

 final AuthService _auth = AuthService();
 final _formKey = GlobalKey<FormState>();

 //Function for google login
Function registerWithGoogle(){
_auth.signInWithGoogle();
}
 //Function for facebook login
Function registerWithFacebook(){
  try{
_auth.signUpWithFacebook();
  }
  catch(e){
    setState(() {
      error = e.toString();
    });
  }
}

Widget _signInButton(String picturePath, Function onPressedFunction,String buttonText) {
    return ButtonTheme(
      minWidth: 280,
          child: OutlineButton( 
        splashColor: Colors.teal[300],
        onPressed: () {
          onPressedFunction();
          Navigator.pop(context);
        },
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
        title: Text("Sign up to Foodie Club")
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              
_signInButton("assets/images/facebook_logo.png",registerWithFacebook,"Sign up with Facebook"),
SizedBox(height: 20.0,),
// Google sign in button
_signInButton("assets/images/google_logo.png",registerWithGoogle,"Sign up with Google"),
SizedBox(height: 30.0,),
Text("--- or ---",style: TextStyle(color: Colors.black54),),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Name", hintStyle: TextStyle(fontFamily: 'Montserrat')),
                validator: (val)=> val.isEmpty ? "Enter a valid name" : null,
                onChanged: (val){
          setState(() {
              name = val;
          });
              },),
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
                 obscureText: _passwordVisible,
                 onChanged: (val){
          setState(() {
            
              password = val;
          });
              },),
               SizedBox(height: 20.0,),
               ListTileTheme(
                 contentPadding: EdgeInsets.all(0),
                                child: CheckboxListTile(
                   
    title: Text("Agree to our Terms and Conditions",style: TextStyle(color: Color.fromRGBO(46, 98, 94, 1),fontFamily: 'Montserrat'),),
    activeColor: Color.fromRGBO(46, 98, 94, 1),
    
    value: tAndC,
    onChanged: (newValue) { 
                   setState(() {
                     tAndC = newValue; 
                   }); 
                 },
    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
  ),
               ),
               ButtonTheme(
                 minWidth: 200,
                                child: RaisedButton(
                   color: Color.fromRGBO(46, 98, 94, 1),
                   highlightColor: Colors.teal[300],
                   child: Text("REGISTER", style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),),shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
                   onPressed: () async {
                  if(_formKey.currentState.validate()){
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password, name);
                    if(result == null){
                        setState(() {
                          error = "Please supply a valid email";
                        });
                    }
                  }



                   }),
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