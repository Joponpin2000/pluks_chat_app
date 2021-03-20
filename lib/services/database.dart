import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseClass {
  getUsers() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .orderBy("name", descending: false)
        .get();
  }

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .get();
  }

  Future getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userId, userMap) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  addConversationMessages(String chatRoomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .then((value) => print("true"))
        .catchError(
      (e) {
        print(e.toString());
      },
    );
  }

  getConversationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
