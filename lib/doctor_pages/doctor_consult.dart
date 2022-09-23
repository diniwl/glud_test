
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glud_test/patient_pages/chatscreen.dart';
import 'package:glud_test/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorConsult extends StatefulWidget {
  const DoctorConsult({ Key? key }) : super(key: key);

  @override
  State<DoctorConsult> createState() => _DoctorConsultState();
}

class _DoctorConsultState extends State<DoctorConsult> {
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
      child: Container(
        child: Row(
          children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: ClipPath(
              clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                height: 55,
                width: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                        Color(0xff6A7DA1),
                        Color(0xff556D9D),
                        Color(0xff334974)                    
                  ])
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: 5),
                  Text(name, style: TextStyle(
                    color: Colors.white,
                  ),),
                  Text(email, style: TextStyle(
                    color: Colors.white,
                  )),
                  SizedBox(height: 5,)
                ],),
              ),
            ),
          )
    
        ],),
      ),
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
                    child: Icon(Icons.arrow_back, 
                    color: Colors.white,)),  
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                        Color(0xff6A7DA1),
                        Color(0xff556D9D),
                        Color(0xff334974)
              ])
            ),
            child: Row(
              children: [
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      name,
                      style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                    ),
                    SizedBox(height: 10),
                    Text(widget.lastMessage, style: TextStyle(
                      color: Colors.white,
                    ),),
                    SizedBox(height: 10),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}