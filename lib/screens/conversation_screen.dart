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
  DatabaseClass databaseClass = new DatabaseClass();
  TextEditingController messageController = new TextEditingController();
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
          messageController.text = item;
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
            return GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: HelperFunctions().emojis.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context, index) => emojiItem(
                item: HelperFunctions().emojis[index],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: Theme.of(context).primaryColor,
            //                 child: (widget.recipientImageUrl == null)
            //                     ? Image.asset(
            //                         "assets/d-p.png",
            //                         fit: BoxFit.fill,
            //                       )
            //                     : widget.recipientImageUrl.isNotEmpty
            //                         ? Image.network(
            //                             widget.recipientImageUrl,
            //                             fit: BoxFit.fill,
            //                           )
            //                         : Center(
            //                             child: CircularProgressIndicator(
            //                               backgroundColor:
            //                                   Theme.of(context).primaryColor,
            //                             ),
            //                           ),
            //   // child: (widget.recipientImageUrl != null)
            //   //     ? Image.network(widget.recipientImageUrl) ??
            //   //         Image.network(
            //   //           widget.recipientImageUrl,
            //   //           fit: BoxFit.fill,
            //   //         )
            //   //     : Image.asset(
            //   //         "assets/d-p.png",
            //   //         fit: BoxFit.fill,
            //   //       ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(widget.recipientName.substring(0, 10)),
            ),
          ],
        ),
        elevation: 0.0,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(Icons.search),
        //   ),
        //   GestureDetector(
        //     onTap: () {},
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 15.0),
        //       child: Icon(Icons.more_vert),
        //     ),
        //   ),
        // ],
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
          // mainAxisAlignment: MainAxisAlignment.end,
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
                    // SizedBox(width: 2),
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
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 20, right: isSendByMe ? 20 : 0),
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
