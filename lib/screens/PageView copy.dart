import 'package:flutter/material.dart';
import 'package:pluks_chat_app/screens/Layout.dart';
import 'package:pluks_chat_app/services/auth.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pluks_chat_app/shared/helper_functions.dart';
import 'package:pluks_chat_app/shared/shared.dart';

class OnBoardingPageView extends StatefulWidget {
  @override
  _OnBoardingPageViewState createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView> {
  final _key = GlobalKey<FormState>();
  PageController _pageController;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final DatabaseClass databaseClass = new DatabaseClass();
  int currentIndex = 0;
  String userImageUrl;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          HelperFunctions.saveUserEmailSharedPreference(
              emailController.text.trim());
          HelperFunctions.saveUserNameSharedPreference(
              usernameController.text.capitalize());
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

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : Stack(
                children: [
                  PageView(
                    onPageChanged: onChangedFunction,
                    controller: _pageController,
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Icon(
                                Icons.face,
                                size: 120,
                                color: Colors.white,
                              ),
                              SizedBox(height: 40),
                              Text(
                                "Choose your username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  hintText: "Enter username",
                                  hintStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.face,
                                  size: 120,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 40),
                                Text(
                                  "Enter your email",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Enter email",
                                    hintStyle: TextStyle(color: Colors.white),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.face,
                                  size: 120,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 40),
                                Text(
                                  "Signin securely with your password",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: "Enter password",
                                    hintStyle: TextStyle(color: Colors.white),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 60,
                    left: 150,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Indicator(
                          positionIndex: 0,
                          currentIndex: currentIndex,
                        ),
                        SizedBox(width: 10),
                        Indicator(
                          positionIndex: 1,
                          currentIndex: currentIndex,
                        ),
                        SizedBox(width: 10),
                        Indicator(
                          positionIndex: 2,
                          currentIndex: currentIndex,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;

  const Indicator({Key key, this.positionIndex, this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
        color: positionIndex == currentIndex
            ? Theme.of(context).accentColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
