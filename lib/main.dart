import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pluks_chat_app/authenticate/authenticate.dart';
import 'package:pluks_chat_app/screens/Layout.dart';
import 'package:pluks_chat_app/screens/PageView.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFreshInstall = true;
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getAppFreshInstallSharedPreference().then(
      (value) async => {
        if (value != null && value == false)
          {
            setState(() {
              isFreshInstall = false;
            })
          },
        await HelperFunctions.getUserLoggedInSharedPreference().then(
          (value) => {
            if (value != null && value == true)
              {
                setState(() {
                  userIsLoggedIn = true;
                })
              }
          },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat-a-long',
      theme: ThemeData(
        primaryColor: Color(0xff123456),
        accentColor: Colors.white70,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isFreshInstall
          ? OnBoardingPageView()
          : userIsLoggedIn
              ? Layout()
              : Authenticate(),
    );
  }
}
