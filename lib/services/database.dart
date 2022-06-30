import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String keyUsername = "prefKeyUsername";
late String myUserName;


class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByUserName (String username) async {
    return FirebaseFirestore.instance
    .collection("users")
    .where("username", isEqualTo: username)
    .snapshots();
  }

  Future addMessage(String chatRoomId, String messageId, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .collection("chats")
    .doc(messageId)
    .set(messageInfoMap);
  }
  updateLastMessageSend (String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId
    ).update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .get();

    if(snapShot.exists){
      return true;
    }
    else {
      return FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatRoomId)
      .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .collection("chats")
    .orderBy("ts", descending: true)
    .snapshots();
  }
  Future<Stream<QuerySnapshot>> getChatRooms() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    myUserName = pref.getString(keyUsername).toString();
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .orderBy("lastMessageSendTs", descending: true)
    .where("users", arrayContains: myUserName)
    .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
    .collection("users")
    .where("username", isEqualTo: username)
    .get();
  }
}
