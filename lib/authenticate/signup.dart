import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/chat_screen.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SignUpScreen extends StatefulWidget {
  final Function toggleView;

  SignUpScreen({this.toggleView});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  bool isLoading = false;

  AuthClass authClass = new AuthClass();
  final DatabaseClass databaseClass = new DatabaseClass();

  final _key = GlobalKey<FormState>();
  bool _obscureText = true;

  String error = '';
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  register() async {
    if (_key.currentState.validate()) {
      Map<String, String> userMap = {
        "name": usernameController.text,
        "email": emailController.text,
      };
      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameController.text);

      setState(() {
        isLoading = true;
      });

      try {
        auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: emailController.text, password: usernameController.text);
        auth.User firebaseUser = result.user;

        AuthClass().userFromFirebaseUser(firebaseUser);
        await databaseClass.uploadUserInfo(userMap);

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
            case "ERROR_TOO_MANY_REQUESTS":
              error = "Too many requests, try again later.";
              break;
            case "ERROR_OPERATION_NOT_ALLOWED":
            case "operation-not-allowed":
              error = "Server error, please try again later.";
              break;
            default:
              error = "Signup failed. Please try again.";
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
                        'Create new account.',
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
                              decoration: InputDecoration(hintText: 'Username'),
                              controller: usernameController,
                              validator: (value) => value == ''
                                  ? 'Username can\'t be empty'
                                  : null,
                            ),
                            SizedBox(height: 5),
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
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscureText,
                              controller: passwordController,
                              validator: (value) => value.length < 6
                                  ? 'Password should be 6+ chars long'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          register();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Register',
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
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.toggleView,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
