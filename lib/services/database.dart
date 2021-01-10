import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharechat/views/chatRoomScreen.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatroom(String chatroomId, chatroomMap) {
    FirebaseFirestore.instance
        .collection("Chatroom")
        .doc(chatroomId)
        .set(chatroomMap);
  }

  setConversationMessages(String chatroomId, messageMap) {
    FirebaseFirestore.instance
        .collection("Chatroom")
        .doc(chatroomId)
        .collection("chats")
        .add(messageMap);
  }

  getConversationMessages(String chatroomId) async {
    return await FirebaseFirestore.instance
        .collection("Chatroom")
        .doc(chatroomId)
        .collection("chats")
        .orderBy("time")
        .snapshots();
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("Chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
