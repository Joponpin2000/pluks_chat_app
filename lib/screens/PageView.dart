import 'package:flutter/material.dart';
import 'package:pluks_chat_app/authenticate/authenticate.dart';
import 'package:pluks_chat_app/services/database.dart';
import 'package:pluks_chat_app/shared/helper_functions.dart';

class OnBoardingPageView extends StatefulWidget {
  @override
  _OnBoardingPageViewState createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView> {
  PageController _pageController;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final DatabaseClass databaseClass = new DatabaseClass();
  int currentIndex = 0;
  String userImageUrl;
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

  toAuth() async {
    await HelperFunctions.saveAppFreshInstallSharedPreference(false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Authenticate(),
      ),
    );
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
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Icon(
                                Icons.message,
                                size: 120,
                                color: Colors.white,
                              ),
                              SizedBox(height: 40),
                              Text(
                                "Chatter",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Fast messaging",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 60),
                              GestureDetector(
                                onTap: () {
                                  toAuth();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   color: Colors.purple,
                      //   padding: EdgeInsets.only(left: 20, right: 20),
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children: [
                      //         SizedBox(height: 40),
                      //         Icon(
                      //           Icons.face,
                      //           size: 120,
                      //           color: Colors.white,
                      //         ),
                      //         SizedBox(height: 40),
                      //         Text(
                      //           "Perfect Chat Solution",
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 30,
                      //           ),
                      //         ),
                      //         SizedBox(height: 20),
                      //         Text(
                      //           "Powerful than any other application",
                      //           style: TextStyle(
                      //             color: Colors.white70,
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //         SizedBox(height: 60),
                      //         GestureDetector(
                      //           onTap: () {
                      //             toAuth();
                      //           },
                      //           child: Container(
                      //             alignment: Alignment.center,
                      //             width: MediaQuery.of(context).size.width,
                      //             padding: EdgeInsets.symmetric(vertical: 15),
                      //             decoration: BoxDecoration(
                      //               color: Theme.of(context).accentColor,
                      //               borderRadius: BorderRadius.circular(30),
                      //             ),
                      //             child: Text(
                      //               'Skip',
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Theme.of(context).primaryColor,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   color: Colors.blue,
                      //   padding: EdgeInsets.only(left: 20, right: 20),
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children: [
                      //         SizedBox(height: 40),
                      //         Icon(
                      //           Icons.messenger,
                      //           size: 120,
                      //           color: Colors.white,
                      //         ),
                      //         SizedBox(height: 40),
                      //         Text(
                      //           "Chatter",
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 30,
                      //           ),
                      //         ),
                      //         SizedBox(height: 20),
                      //         Text(
                      //           "Fast messaging and fast delivery",
                      //           style: TextStyle(
                      //             color: Colors.white70,
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //         SizedBox(height: 60),
                      //         GestureDetector(
                      //           onTap: () {
                      //             toAuth();
                      //           },
                      //           child: Container(
                      //             alignment: Alignment.center,
                      //             width: MediaQuery.of(context).size.width,
                      //             padding: EdgeInsets.symmetric(vertical: 15),
                      //             decoration: BoxDecoration(
                      //               color: Theme.of(context).accentColor,
                      //               borderRadius: BorderRadius.circular(30),
                      //             ),
                      //             child: Text(
                      //               'Skip',
                      //               style: TextStyle(
                      //                 color: Theme.of(context).primaryColor,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
                        // SizedBox(width: 10),
                        // Indicator(
                        //   positionIndex: 1,
                        //   currentIndex: currentIndex,
                        // ),
                        // SizedBox(width: 10),
                        // Indicator(
                        //   positionIndex: 2,
                        //   currentIndex: currentIndex,
                        // ),
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
