import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';

class MeterBarPainter extends CustomPainter {
  List<Color> colorList = [
    Colors.green.withOpacity(1.0),
    Colors.blue.withOpacity(.250),
    Colors.blue.withOpacity(.750),
    Colors.blue.withOpacity(1.0),
    Colors.green.withOpacity(.50),
    Colors.green.withOpacity(.750),
    Colors.green.withOpacity(1.0),
    Colors.red.withOpacity(.250),
    Colors.red.withOpacity(.750),
    Colors.red.withOpacity(1.0),
  ];

  List<Color> bkgColorList = [
    ColorConstants.CONTROL_END,
    ColorConstants.CONTROL_END,
  ];

  double startAngle = 270.0;
  double endAngle = 275.0;
  double strokeWidth = ScreenUtil().setWidth(16);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);

    final gradient = new SweepGradient(
      startAngle: degreeToRadians(70),
      endAngle: degreeToRadians(255),
      tileMode: TileMode.repeated,
      colors: colorList,
    );

    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.square // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final gradientBkg = new SweepGradient(
      startAngle: degreeToRadians(70),
      endAngle: degreeToRadians(255),
      tileMode: TileMode.repeated,
      colors: bkgColorList,
    );

    final paintBkg = new Paint()
      ..shader = gradientBkg.createShader(rect)
      ..strokeCap = StrokeCap.square // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final centerBkg = new Offset(size.width / 2, size.height / 2);
    final radiusBkg =
        math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    final center = new Offset(size.width / 2, size.height / 2);
    final radius =
        math.min(size.width / 2, size.height / 2); //- (strokeWidth / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(270),
        degreeToRadians(157),
        // degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        paint);

    double angleSliceGap = 4.5;
    double sliceCount = 40;
    double angleSlice = (endAngle - startAngle) / (sliceCount);
    // // debugPrint('angleSlice '+ angleSlice.toString());
    double fromAngle = startAngle;
    double toAngle = startAngle + angleSlice;
    for (var i = 1; i <= sliceCount; i++) {
      canvas.drawArc(
          new Rect.fromCircle(center: center, radius: radius),
          degreeToRadians(fromAngle),
          degreeToRadians(angleSlice),
          // degreeToRadians(endAngle - (fromAngle+angleSlice)),
          false,
          paintBkg);

      fromAngle = toAngle + angleSliceGap;
      toAngle = fromAngle + angleSlice;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
