import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:pluks_chat_app/screens/Search.dart';

class SearchTile extends StatelessWidget {
  final userData;

  SearchTile({this.userData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: () {
              openChatRoomAndStartConversation(
                context: context,
                recipientImageUrl: userData['imageUrl'],
                recipientName: userData['name'],
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 25,
                child: (userData['imageUrl'] == null)
                    ? Icon(Icons.person)
                    : userData['imageUrl'].isNotEmpty
                        ? FullScreenWidget(
                            child: Center(
                              child: Hero(
                                tag: userData['imageUrl'].toString(),
                                child: CachedNetworkImage(
                                  imageUrl: userData['imageUrl'],
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, err) =>
                                      Icon(Icons.person),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
              ),
              title: Text(userData['name'].toString()),
              subtitle: Text("${userData['city']}, ${userData['country']}."),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          height: 0.2,
        ),
      ],
    );
  }
}
