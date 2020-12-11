import 'package:flutter/material.dart';
import 'package:flutterchat_app/helper/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterchat_app/helper/helperfunctions.dart';
import 'package:flutterchat_app/views/chatroomScreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLoggedIn=false;
  @override
  void initState() {
    // TODO: implement initState
    getLoggedInStatus();
    super.initState();
  }
  /*void dispose(){
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    super.dispose();
  }*/
  getLoggedInStatus() async{
    bool value=
    await HelperFunctions.getUserLoggedInSharedPreference();
    setState(() {
      userLoggedIn=value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black26,//Color(0xff1f1f1f),
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userLoggedIn==false || userLoggedIn==null ?  Authenticate():ChatRoom() ,
    );
  }
}