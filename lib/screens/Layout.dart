import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:pluks_chat_app/screens/chat_screen.dart';
import 'package:pluks_chat_app/screens/search.dart';
import 'package:pluks_chat_app/shared/custom_drawer.dart';
import 'package:swipedetector/swipedetector.dart';

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  String dropDownValue = "Chats";
  int navIndex = 1;
  FSBStatus drawerStatus;

  var navPages = [
    new ChatsScreen(),
    new ChatsScreen(),
    new SearchScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navIndex == 0
            ? "Status"
            : navIndex == 1
                ? "Chats"
                : navIndex == 2
                    ? "Search"
                    : ""),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                  ? FSBStatus.FSB_CLOSE
                  : FSBStatus.FSB_OPEN;
            });
          },
          child: Icon(Icons.menu),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SwipeDetector(
        child: FoldableSidebarBuilder(
          drawerBackgroundColor: Theme.of(context).primaryColor,
          drawer: CustomDrawer(closeDrawer: () {
            setState(() {
              drawerStatus = FSBStatus.FSB_OPEN;
            });
          }),
          status: drawerStatus,
          screenContents: navPages[navIndex],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        height: 50,
        animationDuration: Duration(milliseconds: 500),
        index: navIndex,
        items: <Widget>[
          Icon(Icons.add, size: 20, color: Colors.white),
          Icon(Icons.compare_arrows, size: 20, color: Colors.white),
          Icon(Icons.search, size: 20, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            navIndex = index;
          });
        },
      ),
    );
  }
}
