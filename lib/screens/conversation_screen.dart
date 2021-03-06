import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/constants.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';

class ConversationScreen extends StatefulWidget {
  final bool isFirstChat;
  final String chatRoomId;
  final String recipientImageUrl;
  final String recipientName;
  final chatRoomMap;
  ConversationScreen(
      {this.chatRoomId,
      this.chatRoomMap,
      this.recipientImageUrl,
      this.recipientName,
      this.isFirstChat});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _scrollController = ScrollController();
  DatabaseClass databaseClass = new DatabaseClass();
  TextEditingController messageController = new TextEditingController();
  TextEditingController emojiMessageController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                margin: EdgeInsets.only(
                  bottom: 70,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index].data()["message"],
                        isSendByMe:
                            snapshot.data.docs[index].data()["sendBy"] ==
                                Constants.myName);
                  },
                ),
              )
            : Container();
      },
    );
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text.trim(),
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      messageController.text = "";
      if (widget.isFirstChat) {
        await databaseClass.createChatRoom(
            widget.chatRoomId, widget.chatRoomMap);
      }
      await databaseClass.addConversationMessages(
          widget.chatRoomId, messageMap);
    }
  }

  sendEmojiMessage() async {
    if (emojiMessageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": emojiMessageController.text.trim(),
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      emojiMessageController.text = "";
      if (widget.isFirstChat) {
        await databaseClass.createChatRoom(
            widget.chatRoomId, widget.chatRoomMap);
      }
      await databaseClass.addConversationMessages(
          widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    databaseClass.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  Widget emojiItem({item}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          emojiMessageController.text = emojiMessageController.text + item;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          item,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _showPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          margin: EdgeInsets.only(
                            left: 5,
                            top: 5,
                            bottom: 5,
                          ),
                          padding: EdgeInsets.only(
                            left: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: emojiMessageController,
                                  readOnly: true,
                                  onChanged: (value) {
                                    setState(() {
                                      emojiMessageController.text = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    emojiMessageController.text = "";
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "x",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(width: 2),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        margin: EdgeInsets.only(
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            sendEmojiMessage();
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.send,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: HelperFunctions().emojis.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8),
                    itemBuilder: (context, index) => emojiItem(
                      item: HelperFunctions().emojis[index],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    Timer(
      Duration(seconds: 1),
      () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(widget.recipientName.length > 10
                  ? widget.recipientName.substring(0, 10)
                  : widget.recipientName),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(
                left: 5,
                right: 5,
                bottom: 5,
                // top: 5,
              ),
              margin: EdgeInsets.only(
                top: 50,
              ),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.only(
                          left: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showPanel();
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "😊",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.send,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile({this.message, this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.symmetric(vertical: 3),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
          color: isSendByMe ? Colors.grey : Theme.of(context).primaryColor,
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 17,
            color: isSendByMe ? Theme.of(context).primaryColor : Colors.white,
          ),
        ),
      ),
    );
  }
}
