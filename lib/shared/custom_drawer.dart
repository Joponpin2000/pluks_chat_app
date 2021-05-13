import 'package:flutter/material.dart';
import 'package:pluks_chat_app/authenticate/authenticate.dart';
import 'package:pluks_chat_app/screens/AppInfo.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';

class CustomDrawer extends StatelessWidget {
  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width * 1,
      height: mediaQuery.size.height,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            height: 0.1,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppInfoScreen(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).accentColor,
                ),
                title: Text('App info'),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 0.1,
          ),
          SizedBox(height: 20),
          Container(
            width: mediaQuery.size.width * .8,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  AuthClass().signOut();
                  HelperFunctions.saveUserLoggedInSharedPreference(false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Authenticate(),
                    ),
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
