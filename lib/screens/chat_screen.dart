import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:pluks_chat_app/screens/conversation_screen.dart';
import 'package:pluks_chat_app/screens/Search.dart';
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
                    userData: snapshot.data.docs[index].data(),
                    chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                  );
                },
              )
            : Container(
                child: Center(
                  child: Text("Your recent chats show up here"),
                ),
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

    databaseClass.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
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

class ChatRoomTile extends StatefulWidget {
  final userData;
  final String chatRoomId;

  ChatRoomTile({this.userData, this.chatRoomId});

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DatabaseClass databaseClass = new DatabaseClass();
  dynamic snapshotUserInfo;
  String imageUrl;
  bool isLoading;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    setState(() {
      isLoading = true;
    });
    databaseClass
        .getUserByUsername(
      widget.userData["chatRoomId"]
          .toString()
          .replaceAll("_", "")
          .replaceAll(Constants.myName, ""),
    )
        .then((val) {
      setState(() {
        isLoading = false;
        imageUrl = val.docs[0].data()['imageUrl'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List<String> users = [
          widget.userData["chatRoomId"]
              .toString()
              .replaceAll("_", "")
              .replaceAll(Constants.myName, ""),
          Constants.myName
        ];
        Map<String, dynamic> chatRoomMap = {
          "users": users,
          "chatRoomId": widget.chatRoomId,
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              chatRoomId: widget.chatRoomId,
              isFirstChat: false,
              recipientImageUrl: widget.userData['imageUrl'],
              recipientName: widget.userData["chatRoomId"]
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
              chatRoomMap: chatRoomMap,
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
                  context: context,
                  recipientImageUrl: widget.userData['imageUrl'],
                  recipientName: widget.userData["chatRoomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 25,
                  child: ClipOval(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            )
                          : (imageUrl == null || imageUrl.isEmpty)
                              ? Icon(Icons.person)
                              : FullScreenWidget(
                                  child: Hero(
                                    tag: imageUrl.toString(),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
                title: Text(widget.userData["chatRoomId"]
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, "")),
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
