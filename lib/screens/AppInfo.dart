import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Container(
                  child: Image(
                    image: AssetImage(
                      "assets/icon.png",
                    ),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Chat-a-long",
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(height: 10),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Text("Copyright 2021 Dev-Jo Inc."),
          ],
        ),
      ),
    );
  }
}
