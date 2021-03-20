import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/conversation_screen.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/SearchTile.dart';
import 'package:pluks_chat_app/shared/constants.dart';
import 'package:pluks_chat_app/shared/shared.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseClass databaseClass = new DatabaseClass();
  TextEditingController searchController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  initiateSearch() {
    databaseClass.getUsers().then((val) {
      if (mounted) {
        setState(() {
          searchSnapshot = val;
        });
      }
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchSnapshot.docs[index].data()['name'] !=
                      Constants.myName
                  ? SearchTile(
                      userData: searchSnapshot.docs[index].data(),
                    )
                  : Container();
            },
          )
        : Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
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
        child: searchList(),
      ),
    );
  }
}

openChatRoomAndStartConversation({BuildContext context, String recipientName, String recipientImageUrl}) {
  if (recipientName != Constants.myName) {
    String chatRoomId = getChatRoomId([recipientName, Constants.myName]);

    List<String> users = [recipientName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          chatRoomId: chatRoomId,
          isFirstChat: true,
          chatRoomMap: chatRoomMap,
          recipientImageUrl: recipientImageUrl,
          recipientName: recipientName,
        ),
      ),
    );
  }
}
