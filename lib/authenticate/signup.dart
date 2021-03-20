import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/Layout.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pluks_chat_app/shared/shared.dart';

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
      setState(() {
        isLoading = true;
      });
      try {
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: usernameController.text.trim())
            .then((value) async {
          auth.User firebaseUser = value.user;

          Map<String, String> userMap = {
            "id": firebaseUser.uid,
            "name": usernameController.text.capitalize(),
            "email": emailController.text,
            "city": "Lagos",
            "country": "Nigeria",
          };
          HelperFunctions.saveUserIdSharedPreference(firebaseUser.uid);
          HelperFunctions.saveUserEmailSharedPreference(emailController.text.trim());
          HelperFunctions.saveUserNameSharedPreference(usernameController.text.capitalize());
          HelperFunctions.saveUserCountrySharedPreference("Nigeria");
          HelperFunctions.saveUserCitySharedPreference("Lagos");

          print(firebaseUser.uid);
          AuthClass().userFromFirebaseUser(firebaseUser);
          await databaseClass.uploadUserInfo(firebaseUser.uid, userMap);

          // Save user info to shared preference
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Layout(),
            ),
          );
        });
      } catch (e) {
        setState(() {
          switch (e.code) {
            case "ERROR_INVALID_EMAIL":
            case "weak-password":
              error = "Password is too weak.";
              break;

            case "invalid-email":
              error = "Email address is invalid.";
              break;
            case "EMAIL_ALREADY_IN_USE":
            case "email-already-in-use":
              error = "Email already exist.";
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
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Error",
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
              content: Text(error.toString()),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
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
                              decoration: InputDecoration(hintText: 'Username'),
                              controller: usernameController,
                              validator: (value) => value == ''
                                  ? 'Username can\'t be empty'
                                  : null,
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
                              SizedBox(width: 5),
                              RaisedButton(
                                
                                onPressed: widget.toggleView,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
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
