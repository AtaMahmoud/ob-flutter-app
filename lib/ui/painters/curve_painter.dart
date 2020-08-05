import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:ocean_builder/constants/constants.dart';

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;
  final List<Color> bkgColors;
  final bool showBkgARc;
  final double strokeWidth;
  final bool drawHandler;
  final double startAngle;
  final double endAngle;
  final bool slicedCurve;
  final bool showShadow;

  CurvePainter({this.colors,this.showBkgARc,this.bkgColors,this.strokeWidth = 14,this.drawHandler = true, this.angle = 140,this.startAngle=120,this.endAngle=360,this.slicedCurve=false,this.showShadow=false});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    List<Color> bkgColorList = List<Color>();
        if (colors != null) {
      bkgColorList = bkgColors;
    } else {
      bkgColorList.addAll([ColorConstants.CONTROL_ARC_BKG_START, ColorConstants.CONTROL_ARC_BKG_END]);
    }


    double startAngle = this.startAngle;
    double endAngle = this.endAngle;
    double endAngleOffset = this.endAngle + 5;
    double dotAngle = 278.0-120.0;
    if(showShadow){
    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);
        
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(startAngle),
        degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = strokeWidth *1.1 ;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(startAngle),
        degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = strokeWidth*1.2;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(startAngle),
        degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = strokeWidth*1.4;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(startAngle),
        degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        shdowPaint);
    }




    if(showBkgARc){

    final rectBkg = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradientBkg = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + endAngle),
      tileMode: TileMode.repeated,
      colors: bkgColorList,
    );
    final paintBkg = new Paint()
      ..shader = gradientBkg.createShader(rectBkg)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final centerBkg = new Offset(size.width / 2, size.height / 2);
    final radiusBkg = math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    if(slicedCurve){
      double angleSliceGap = 5;
      double angleSlice = 20;
      double sliceCount = (endAngle - startAngle)/(angleSlice);
      double fromAngle = startAngle;
      double toAngle = startAngle + angleSlice;
      for (var i = 1; i <= sliceCount; i++) {
            canvas.drawArc(
        new Rect.fromCircle(center: centerBkg, radius: radiusBkg),
        degreeToRadians(fromAngle),
        degreeToRadians(angleSlice), 
        // degreeToRadians(endAngle - (fromAngle+angleSlice)),
        false,
        paintBkg);
        
        fromAngle = toAngle + angleSliceGap;
        toAngle = fromAngle + angleSlice;
      }

    }else{
    canvas.drawArc(
        new Rect.fromCircle(center: centerBkg, radius: radiusBkg),
        degreeToRadians(startAngle),
        degreeToRadians(endAngle ), 
        // degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        paintBkg);
    }


  
  }


    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + endAngle),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    if(slicedCurve){
      double calcualteAngle = angle%360;
      double angleSliceGap = 5;
      double angleSlice = 20;
      double sliceCount = (calcualteAngle - startAngle)/(angleSlice);
      //// debugPrint('slice count '+ sliceCount.toString());
      double fromAngle = startAngle;
      double toAngle = startAngle + angleSlice;
      double partialSlice = (calcualteAngle - startAngle) - (sliceCount.floor()*angleSlice);
      for (var i = 1; i <= sliceCount; i++) {
            canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(fromAngle),
        degreeToRadians(angleSlice), 
        // degreeToRadians(endAngle - (fromAngle+angleSlice)),
        false,
        paint);
        
        fromAngle = toAngle + angleSliceGap;
        toAngle = fromAngle + angleSlice;
      }

            canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(fromAngle),
        degreeToRadians(partialSlice), 
        // degreeToRadians(endAngle - (fromAngle+angleSlice)),
        false,
        paint);


    }else{
    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(startAngle),
        degreeToRadians(angle),
        // degreeToRadians(endAngle - (endAngleOffset - angle)),
        false,
        paint);

    }

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = strokeWidth / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle - dotAngle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + strokeWidth / 2);
    
    if(drawHandler)
    canvas.drawCircle(new Offset(0, 0), strokeWidth / 2, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
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

class IndicatorPainter extends CustomPainter{
  final double angle;

  IndicatorPainter({this.angle});
  

  @override
  Future paint(Canvas canvas, Size size) {
    // TODO: implement paint
    double strokeWidth = 14;
        var cPaint = new Paint();
    cPaint..color = Colors.green;
    cPaint..strokeWidth = strokeWidth / 2;
    canvas.save();

    final centerToCircle = size.width / 2 + 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + strokeWidth / 2);
    
    // canvas.drawCircle(new Offset(0, 0), strokeWidth / 2, cPaint);

    var path1 = Path()
    ..moveTo(0, 0)
    ..lineTo(16, 0)
    ..lineTo(8, 16)
    ..lineTo(0, 0);
  canvas.drawPath(path1, cPaint);
    


  canvas.restore();
  canvas.restore();
  canvas.restore();
  
  }

    Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

    double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }

}