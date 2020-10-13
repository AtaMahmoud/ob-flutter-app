import 'package:flutter/material.dart';

class BatteryLevelPainter extends CustomPainter {
  final int _batteryLevel;

  BatteryLevelPainter(this._batteryLevel);

  @override
  void paint(Canvas canvas, Size size) {
    Paint getPaint(
        {Color color = Colors.black,
        PaintingStyle style = PaintingStyle.stroke}) {
      return Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = style;
    }

    final double batteryRight = size.width - size.width / 10;
    final double radius = size.height / 12;

    final RRect batteryOutline = RRect.fromLTRBR(
        0.0, 0.0, batteryRight, size.height, Radius.circular(radius));

    // Battery body
    canvas.drawRRect(
      batteryOutline,
      getPaint(),
    );

    // Battery nub
    canvas.drawRect(
      Rect.fromLTWH(batteryRight, (size.height / 2.0) - size.height / 4,
          size.width / 10, size.height / 2),
      getPaint(style: PaintingStyle.stroke),
    );

    // Fill rect
    canvas.clipRect(Rect.fromLTWH(
        0.0, 0.0, batteryRight * _batteryLevel / 100.0, size.height));

    Color indicatorColor;
    if (_batteryLevel < 15) {
      indicatorColor = Colors.red;
    } else if (_batteryLevel < 30) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.green;
    }

    canvas.drawRRect(
        RRect.fromLTRBR(0.5, 0.5, batteryRight - 0.5, size.height - 0.5,
            Radius.circular(radius)),
        getPaint(style: PaintingStyle.fill, color: indicatorColor));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final BatteryLevelPainter old = oldDelegate as BatteryLevelPainter;
    return old._batteryLevel != _batteryLevel;
  }
}
