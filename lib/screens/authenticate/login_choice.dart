import 'package:flutter/material.dart';
import 'package:foodies/screens/authenticate/sign_in.dart';
import 'package:foodies/screens/authenticate/sign_up.dart';

class LoginChoice extends StatefulWidget {
  @override
  _LoginChoiceState createState() => _LoginChoiceState();
}

class _LoginChoiceState extends State<LoginChoice>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;


  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(67.5)),
              Image.asset('assets/images/loginScreenFinished.PNG'),
              Padding(padding: EdgeInsets.all(15)),
              FadeTransition(
                opacity: animation,
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: 200,
                      child: RaisedButton(
                        highlightElevation: 0.0,
                        highlightColor: Colors.teal[300],
                        elevation: 0.0,
                        color: Color.fromRGBO(46, 98, 94, 1),
                        child: Text("LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            )),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    ButtonTheme(
                      minWidth: 200,
                      child: RaisedButton(
                        highlightElevation: 0.0,
                        elevation: 0.0,
                        highlightColor: Colors.teal[300],
                        color: Colors.white,
                        child: Text("SIGN UP",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                              color: Color.fromRGBO(46, 98, 94, 1),
                            )),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(
                                color: Color.fromRGBO(46, 98, 94, 1))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
