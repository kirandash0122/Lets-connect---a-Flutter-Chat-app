import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    //backgroundColor: Color(0xff007ef4),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            /*const Color(0xff007ef4),
                                  const Color(0xff2a758c),*/
            Colors.red[400],
            Colors.red[600],
            Colors.red[900],

          ],
        ),
        //color: Colors.red[900],
      ),
    ),
    title: Text(
      'Let\'s Connect',
      style: GoogleFonts.pacifico(
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white,),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white,),
    ),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
      color: Colors.white,
    fontSize: 16.0,
  );
}