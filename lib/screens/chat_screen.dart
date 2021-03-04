import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/conversation_screen.dart';
import 'package:pluks_chat_app/screens/search.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/constants.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  AuthClass authClass = new AuthClass();
  DatabaseClass databaseClass = new DatabaseClass();
  Stream chatRoomsStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.docs[index]
                        .data()["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                  );
                },
              )
            : Container();
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
    databaseClass.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: chatRoomList(),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName, this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId: chatRoomId,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                openChatRoomAndStartConversation(
                    context: context, userName: userName);
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 25,
                  child: Text("${userName.substring(0, 1).toUpperCase()}"),
                ),
                title: Text(userName),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 0.2,
          ),
        ],
      ),
    );
  }
}
