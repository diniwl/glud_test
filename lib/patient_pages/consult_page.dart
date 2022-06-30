
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glud_test/patient_pages/chatscreen.dart';
import 'package:glud_test/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultPage extends StatefulWidget {
  const ConsultPage({ Key? key }) : super(key: key);

  @override
  State<ConsultPage> createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  bool isSearching = false;
  Stream? usersStream, chatRoomsStream;
  late String myFullName, myUserName, myEmail;
  static const String keyFullName = "prefKeyFullName";
  static const String keyEmail = "prefKeyEmail";
  static const String keyUsername = "prefKeyUsername";

  TextEditingController searchUsernameEditingController = TextEditingController();

  getMyInfoFromSharedPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    myFullName = pref.getString(keyFullName).toString();
    myUserName = pref.getString(keyUsername).toString();
    myEmail = pref.getString(keyEmail).toString();
    setState(() {
    });
  }

    getChatRoomIdByUsernames(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    } else{
      return "$a\_$b";
    }
  }

  onSearchClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
    .getUserByUserName(searchUsernameEditingController.text);
    setState(() {
    });
  }


  Widget searchListUserTile({required String name, email, username}){
    return GestureDetector(
      onTap: (){
        var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users" : [myUserName, username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(username, name)));
      },
      child: Row(
        children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(name),
          Text(email),
        ],)
    
      ],),
    );
  }

  Widget searchUsersList(){
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData?
        ListView.builder(
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = (snapshot.data! as QuerySnapshot).docs[index];
              return searchListUserTile(
                name: ds["fullName"], 
                email: ds["email"],
                username : ds['username']);
            },
          ):
          Center(
            child: CircularProgressIndicator(),
          );
          },
    );
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot ) {
        return snapshot.hasData? ListView.builder(
          itemCount: (snapshot.data! as QuerySnapshot).docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = (snapshot.data! as QuerySnapshot).docs[index];
            return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName);
          }
          ) : Center(child: CircularProgressIndicator());
      }
    );
  }
  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async{
    await getMyInfoFromSharedPreferences();
    getChatRooms();
  }

  @override
  void initState(){
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff273248),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching? GestureDetector(
                  onTap: () {
                    isSearching = false;
                    searchUsernameEditingController.text = "";
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_back)),  
                )
                : Container(),
              Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white, 
                    width: 1,
                    style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Row(
                  children: [
                    Expanded(
                    child: TextField(
                    controller: searchUsernameEditingController,
                    decoration: 
                  InputDecoration(border: InputBorder.none,
                  hintText: "username"),
                  )), 
                  GestureDetector(
                    onTap: () {
                      if(searchUsernameEditingController.text != ""){
                        onSearchClick();
                      }
                    },
                    child: Icon(Icons.search)),
                  ],
                ),
              ),
            ),
              ],
            ),
            isSearching ? Container(
              color: Colors.white,
              child: searchUsersList()): 
                chatRoomList()
          ],
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUserName;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUserName);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String  name = "", username = "";
  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print("something bla bla ${querySnapshot.docs[0].id}");
    print("something bla bla ${querySnapshot.docs[0]["username"]}");
    name = "${querySnapshot.docs[0]["username"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}