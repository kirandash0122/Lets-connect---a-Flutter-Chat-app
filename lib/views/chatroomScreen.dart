import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat_app/helper/authentication.dart';
import 'package:flutterchat_app/helper/constants.dart';
import 'package:flutterchat_app/helper/helperfunctions.dart';
import 'package:flutterchat_app/services/auth.dart';
import 'package:flutterchat_app/services/database.dart';
import 'package:flutterchat_app/views/conversationScreen.dart';
import 'package:flutterchat_app/views/search.dart';
import 'package:flutterchat_app/widgets/widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            if (snapshot.hasData) {
              return ChatRoomTile(
                useName: snapshot.data.docs[index]
                    .get("chatroomId")
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.docs[index].get("chatroomId"),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Stream value = databaseMethods.getChatRooms(Constants.myName);
    setState(() {
      chatRoomStream = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Icon(
                Icons.close,
              ),
            ),
          )
        ],
        //backgroundColor: Color(0xff007ef4),
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
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        backgroundColor: Colors.red[900],
        child: Icon(
          Icons.search,
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String useName;
  final String chatRoomId;

  ChatRoomTile({this.useName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40.0,
              width: 40.0,
              child: Text(
                "${useName.substring(0, 1)}",
                style: simpleTextStyle(),
              ),
              decoration: BoxDecoration(
                //color: Color(0xff007ef4),
                gradient: LinearGradient(
                  colors: [
                    /*const Color(0xff007ef4),
                                  const Color(0xff2a758c),*/
                    Colors.red[400],
                    Colors.red[600],
                    Colors.red[900],

                  ],
                ),
                borderRadius: BorderRadius.circular(
                  40.0,
                ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              useName,
              style: simpleTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
