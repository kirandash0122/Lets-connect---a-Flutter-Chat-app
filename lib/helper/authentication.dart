import 'package:flutter/material.dart';
import 'package:flutterchat_app/views/signIn.dart';
import 'package:flutterchat_app/views/signup.dart';
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool goSignIn=true;
  void togglePage(){
    setState(() {
      goSignIn=!goSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(goSignIn){
      return SignIn(toggle:togglePage);
    }
    else{
      return SignUp(toggle: togglePage);
    }
  }
}
