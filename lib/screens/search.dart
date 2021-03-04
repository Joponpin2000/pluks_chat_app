import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/conversation_screen.dart';
import 'package:pluks_chat_app/services/database.dart';
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
    super.initState();
  }

  initiateSearch() {
    databaseClass.getUserByUsername(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].data()['name'],
              );
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search..',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

openChatRoomAndStartConversation({BuildContext context, String userName}) {
  if (userName != Constants.myName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    DatabaseClass().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId: chatRoomId, recipientName: userName),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;

  SearchTile({this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Text("${userName.substring(0, 1).toUpperCase()}"),
          ),
          title: Text(userName),
          trailing: GestureDetector(
            onTap: () {
              openChatRoomAndStartConversation(
                  context: context, userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Message',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
