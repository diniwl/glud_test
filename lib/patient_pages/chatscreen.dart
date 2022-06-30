import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glud_test/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {

 final String chatWithUsername, fullName;
 ChatScreen(this.chatWithUsername, this.fullName);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream<QuerySnapshot>? messageStream;
  
  static const String keyFullName = "prefKeyFullName";
  static const String keyEmail = "prefKeyEmail";
  static const String keyUsername = "prefKeyUsername";

  TextEditingController messageTextEditingController = TextEditingController();

  late String chatRoomId, messageId = "";
  late String myFullName, myUserName, myEmail;
  

  getMyInfoFromSharedPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    myFullName = pref.getString(keyFullName).toString();
    myUserName = pref.getString(keyUsername).toString();
    myEmail = pref.getString(keyEmail).toString();
    setState(() {
    });
    Fluttertoast.showToast(msg: "Shared pref data fecthed");
    print('$myUserName');
    print('$myEmail');

    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName).toString();
  }

  getChatRoomIdByUsernames(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    } else{
      return "$a\_$b";
    }
  }

  addMessages (bool sendClicked) {
    if(messageTextEditingController.text != ""){
      String message = messageTextEditingController.text;
      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message" : message,
        "sendBy" : myUserName, 
        "ts" : lastMessageTs,
      };

      if(messageId == "") {
        messageId = randomAlphaNumeric(12);
        
      }
      DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap)
      .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage" : message,
          "lastMessageSendTs" : lastMessageTs,
          "lastMessageSendBy" : myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if(sendClicked) {
          messageTextEditingController.text = "";
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment: 
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight: 
                sendByMe ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: 
                sendByMe ? Radius.circular(24) : Radius.circular(0),
              ),
              color: sendByMe ? Colors.blue : Colors.orange,
            ),
            padding: EdgeInsets.all(16),
            child: Text(message,
            style: TextStyle(color: Color(0xff273248)),)),
        ),
      ],
    );
  }

  Widget chatMessages(){
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData? ListView.builder(
          padding : EdgeInsets.only(bottom: 70, top: 16),
          itemCount: (snapshot.data! as QuerySnapshot).docs.length,
          reverse: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = (snapshot.data! as QuerySnapshot).docs[index];
            return chatMessageTile(
              ds["message"], myUserName == ds["sendBy"]);
          }) : Center(child: CircularProgressIndicator());
      }
      );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {

    });

  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreferences();
    getAndSetMessages();
  }
  @override
  void initState(){
    doThisOnLaunch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fullName),
      ),
      body: Container(
        color: Color(0xff273248),
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEditingController,
                      onChanged: (value) {
                        addMessages(false);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "type a message",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                    )),
                    GestureDetector(
                      onTap: () {
                        addMessages(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}