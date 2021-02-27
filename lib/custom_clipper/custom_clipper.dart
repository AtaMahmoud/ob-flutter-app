import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTopShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, size.height * .9);

    var firstEndPoint = Offset(size.width / 2, size.height - (size.height / 3));
    var firstControlPoint =
        Offset(size.width / 4, size.height - (size.height / 3));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint =
        Offset(size.width, size.height - (size.height * 2 / 3));
    var secondControlPoint =
        Offset((size.width * 3) / 4, size.height - (size.height / 3));

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomTopShapeClipperHome extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, size.height * .95);

    var firstEndPoint = Offset(size.width / 2, size.height - (size.height / 3));
    var firstControlPoint =
        Offset(size.width / 4, size.height - (size.height / 3));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint =
        Offset(size.width, size.height - (size.height * 2 / 3));
    var secondControlPoint =
        Offset((size.width * 3) / 4, size.height - (size.height / 3));

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class DrawerTopShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, size.height * .98);

    var firstEndPoint =
        Offset(size.width * 1 / 2, size.height - (size.height / 5));
    var firstControlPoint = Offset(size.width / 4, size.height);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint =
        Offset(size.width, size.height - (size.height * 9 / 20));
    var secondControlPoint =
        Offset(size.width * 3 / 4, size.height - (size.height / 2.5));

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class WeatherTopShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, size.height * .95);

    var firstEndPoint = Offset(size.width / 2, size.height - (size.height / 8));
    var firstControlPoint =
        Offset(size.width / 6, size.height - (size.height / 8));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint =
        Offset(size.width, size.height - (size.height * 1 / 4));
    var secondControlPoint =
        Offset(size.width * 5 / 6, size.height - (size.height / 8));

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomBottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, 40);

    var firstEndPoint = Offset(size.width / 2, 20);
    var firstControlPoint = Offset(size.width / 4, 10);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, 0);
    var secondControlPoint = Offset((size.width * 3) / 4, 30);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TitleBottomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height / 2);

    var firstEndPoint = Offset(size.width, size.height / 2);
    var firstControlPoint = Offset(size.width / 2, 0);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomBottomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, 60);

    var firstEndPoint = Offset(size.width / 1.75, 25);
    var firstControlPoint = Offset(size.width / 4, 25.0);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, 0);
    var secondControlPoint = Offset((size.width) / 1.25, 30);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomProfileDropdownClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // final Path path = Path();
    // path.lineTo(0, 60);

    // var firstEndPoint = Offset(size.width / 1.75, 35);
    // var firstControlPoint = Offset(size.width / 4, 35);

    // path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
    //     firstEndPoint.dx, firstEndPoint.dy);

    // var secondEndPoint = Offset(size.width, 0);
    // var secondControlPoint = Offset((size.width) / 1.25, 30);

    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondEndPoint.dx, secondEndPoint.dy);

    // path.lineTo(size.width, size.height - 58);

    // var thirdEndPoint = Offset(size.width / 2, size.height - 20);
    // var thirdControlPoint = Offset(size.width * 3 / 4, size.height - 20);

    // path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
    //     thirdEndPoint.dx, thirdEndPoint.dy);

    // var fourthEndPoint = Offset(0, size.height);
    // var fourthControlPoint = Offset(size.width / 4, size.height - 20);

    // path.quadraticBezierTo(fourthControlPoint.dx, fourthControlPoint.dy,
    //     fourthEndPoint.dx, fourthEndPoint.dy);

    // path.close();
    ScreenUtil _util = ScreenUtil();
    final Path path = Path();
    path.lineTo(0, _util.setHeight(175));

    var firstEndPoint = Offset(size.width / 1.75, _util.setHeight(110));
    var firstControlPoint = Offset(size.width / 4, _util.setHeight(115));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, 0);
    var secondControlPoint = Offset(size.width / 1.25, _util.setHeight(110));

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - _util.setHeight(170));

    // path.lineTo(0.0, size.height);

    var thirdEndPoint =
        Offset(size.width / 1.75, size.height - _util.setHeight(55));
    var thirdControlPoint =
        Offset(size.width * 3 / 4, size.height - _util.setHeight(57.5));

    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    var fourthEndPoint = Offset(0, size.height);
    var fourthControlPoint =
        Offset(size.width / 4, size.height - _util.setHeight(55));

    path.quadraticBezierTo(fourthControlPoint.dx, fourthControlPoint.dy,
        fourthEndPoint.dx, fourthEndPoint.dy);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomBottomProfileShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    ScreenUtil _util = ScreenUtil();

    final Path path = Path();
    path.lineTo(0, _util.setHeight(175));

    var firstEndPoint = Offset(size.width / 1.75, _util.setHeight(110));
    var firstControlPoint = Offset(size.width / 4, _util.setHeight(115));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, 0);
    var secondControlPoint = Offset(size.width / 1.25, _util.setHeight(110));

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
