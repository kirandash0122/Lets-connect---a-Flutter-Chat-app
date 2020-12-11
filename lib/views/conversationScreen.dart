import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat_app/helper/constants.dart';
import 'package:flutterchat_app/services/database.dart';
import 'package:flutterchat_app/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen({this.chatRoomId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatStream;
  ScrollController listController=ScrollController();
  TextEditingController messageController = TextEditingController();
  Widget chatMessageList() {
    return  StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          //controller: listController,
          //shrinkWrap: true,

          //physics: BouncingScrollPhysics(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            if (snapshot.hasData) {
              return MessageTile(
                message: snapshot.data.docs[index].get("message"),
                isMe:
                snapshot.data.docs[index].get("sendBy") == Constants.myName,
              );
            }
            else{
              return Container();
            }
          },
        );
      },
    );
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      await databaseMethods.addConversation(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    Stream value=databaseMethods.getConversation(widget.chatRoomId);
    setState(() {
      chatStream =value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Flexible(child: chatMessageList()),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                //color: Colors.grey[600],
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Message..",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // initiateSearch();
                        await sendMessage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final isMe;

  MessageTile({this.message, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isMe==false?EdgeInsets.only(left: 16.0,):EdgeInsets.only(right: 16.0,),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.red[600] : Colors.red[300],
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0,),
          child: Text(
            message,
            style: simpleTextStyle(),
          ),
        ),
    );
  }
}
