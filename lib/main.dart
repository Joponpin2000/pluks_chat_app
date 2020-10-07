import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';
import 'package:pluks_chat_app/authenticate/authenticate.dart';
import 'package:pluks_chat_app/screens/chat_screen.dart';

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
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference()
        .then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pluks',
      theme: ThemeData(
        primarySwatch: Colors.grey[300],
        primaryColor: Colors.grey[700],
        accentColor: Colors.black87,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? ChatScreen() : Authenticate(),
    );
  }
}
