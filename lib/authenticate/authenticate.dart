import 'package:flutter/material.dart';
import 'package:pluks_chat_app/authenticate/login.dart';
import 'package:pluks_chat_app/authenticate/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(
        toggleView: toggleView,
      );
    } else {
      return SignUpScreen(
        toggleView: toggleView,
      );
    }
  }
}
