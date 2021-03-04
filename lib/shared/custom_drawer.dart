import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(),
          GestureDetector(
              child: Text("Go Away"),
              onTap: () {
                closeDrawer();
              }),
          Container(),
          Text("Close Your Eyes"),
        ],
      ),
    );
  }
}
