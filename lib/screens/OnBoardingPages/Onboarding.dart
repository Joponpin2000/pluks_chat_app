// import 'package:flutter/material.dart';
// import 'package:pluks_chat_app/screens/OnBoardingPages/Name.dart';

// class Onboarding extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.red,
//         padding: EdgeInsets.symmetric(horizontal: 30),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 40),
//                 Icon(
//                   Icons.face,
//                   size: 120,
//                   color: Colors.white,
//                 ),
//                 SizedBox(height: 40),
//                 Text(
//                   "Hello there, this",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                   ),
//                 ),
//                 Text(
//                   "is jhealing",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 30,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   "Here to be your true companion",
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 60),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Name(),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(40),
//                       color: Colors.white,
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Let's get started",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   "I have been here before",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
