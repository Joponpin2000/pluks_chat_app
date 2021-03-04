import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/chat_screen.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;

  LoginScreen({this.toggleView});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  bool isLoading = false;
  final _key = GlobalKey<FormState>();
  AuthClass authClass = new AuthClass();
  final DatabaseClass databaseClass = new DatabaseClass();
  bool _obscureText = true;

  QuerySnapshot snapshotUserInfo;

  String error = '';
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  login() async {
    if (_key.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);

      databaseClass.getUserByEmail(emailController.text).then(
        (val) {
          snapshotUserInfo = val;
          HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo.docs[0].data()['name']);
        },
      );

      setState(() {
        isLoading = true;
      });

      try {
        auth.UserCredential result = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        auth.User firebaseUser = result.user;

        AuthClass().userFromFirebaseUser(firebaseUser);
        // Save user info to shared preference
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatsScreen(),
          ),
        );
      } catch (e) {
        setState(() {
          switch (e.code) {
            case "ERROR_INVALID_EMAIL":
            case "invalid-email":
              error = "Email address is invalid.";
              break;
            case "ERROR_WRONG_PASSWORD":
            case "wrong-password":
              error = "Wrong email/password combination.";
              break;
            case "ERROR_USER_NOT_FOUND":
            case "user-not-found":
              error = "No user found with this email.";
              break;
            case "ERROR_USER_DISABLED":
            case "user-disabled":
              error = "User account disabled.";
              break;
            case "ERROR_TOO_MANY_REQUESTS":
              error = "Too many requests, try again later.";
              break;
            case "ERROR_OPERATION_NOT_ALLOWED":
            case "operation-not-allowed":
              error = "Server error, please try again later.";
              break;
            default:
              error = "Login failed. Please try again.";
              break;
          }
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Hello.',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      error.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.orangeAccent,
                              child: Center(
                                child: Text(
                                  error,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 12),
                      Form(
                        key: _key,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              controller: emailController,
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please provide a valid Email";
                              },
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),color: Theme.of(context).primaryColor,onPressed: () {
                                      setState(() {
                                        _obscureText  =  !_obscureText;
                                      });
                                    },
                                  ),),
                              obscureText: _obscureText,
                              controller: passwordController,
                              validator: (value) => value.length < 6
                                  ? 'Password should be 6+ chars long'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          login();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
