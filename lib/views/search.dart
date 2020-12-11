import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat_app/helper/constants.dart';
import 'package:flutterchat_app/services/database.dart';
import 'package:flutterchat_app/widgets/widget.dart';

import 'conversationScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods=DatabaseMethods();
  TextEditingController searchUsernameController=TextEditingController();
  QuerySnapshot searchSnapShot;

  initiateSearch() async {
      QuerySnapshot value= await databaseMethods.getUserByUsername
        (searchUsernameController.text);
      setState(() {
        searchSnapShot=value;
      });
  }


  createChatRoomAndStartConversation(String username){
     List<String> users=[username,Constants.myName];
     String chatroomId=getChatRoomId(username, Constants.myName);
     Map<String,dynamic> chatRoomMap={
       "users":users,
        "chatroomId": chatroomId
     };
   databaseMethods.createChatRoom(chatroomId, chatRoomMap);
   Navigator.push(context, MaterialPageRoute(
     builder: (context)=>ConversationScreen(chatRoomId: chatroomId,),
   ));
  }
  Widget searchList(){
    return searchSnapShot!=null ? ListView.builder(
      itemCount: searchSnapShot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context,index){
        return searchTile(
          userName: searchSnapShot.docs[index].get("name"),
          userEmail: searchSnapShot.docs[index].get("email"),
        );
      },
    ):Container();
  }
 Widget searchTile({String userName,String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0,),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
            createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red[500],
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0,),
              child: Text(
                "Message",
                style: simpleTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.red[300],
              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0,),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchUsernameController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "search username",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                     initiateSearch();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.red[500],
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return"$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}