import 'package:flutter/material.dart';
import 'package:pluks_chat_app/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  bool isLoading = false;

  passwordReset() async {
    if (_key.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await AuthClass().resetPassword(emailController.text).then((value) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Password recovery",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              content: Text(
                  "An email has just been sent to you. Click the link provided to complete regisration"),
            );
          },
        );
      });
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
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Column(
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 15),
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
                          RaisedButton(
                            onPressed: () {
                              passwordReset();
                            },
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
    );
  }
}
