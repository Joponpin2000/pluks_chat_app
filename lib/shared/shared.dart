import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height);
    var controlPoint = Offset(0, size.height);
    var endPoint = Offset(0, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height);
    var controlPoint = Offset(0, size.height);
    var endPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MiddleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // path.lineTo(0, size.height);
    // path.quadraticBezierTo(
    //     size.width - (size.width / 3), size.height, size.width, size.height);
    // path.lineTo(size.width, size.height);
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 3, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

getChatRoomId(List<String> names) {
  names.sort();

  String a = names[0];
  String b = names[1];
  return "$a\_$b";
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
