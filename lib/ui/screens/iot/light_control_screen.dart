import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/colorpicker/flutter_hsvcolor_picker.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/iot/light_control_data_provider.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class LightControllerScreen extends StatefulWidget {
  static const String routeName = '/light_screen';

  @override
  _LightControllerScreenState createState() => _LightControllerScreenState();
}

class _LightControllerScreenState extends State<LightControllerScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Appbar(
                  ScreenTitle.LIGHTS,
                  isDesignScreen: true,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: [
                        SliverToBoxAdapter(
                          child: SpaceH32(),
                        ),
                        FutureBuilder<List<Light>>(
                            future: Provider.of<LightControlDataProvider>(
                                    context,
                                    listen: false)
                                .getAllLigts(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child: _progressIndicitaorView(),
                                );
                              }

                              if (snapshot.hasData &&
                                  snapshot.data.length > 0) {
                                return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: (orientation ==
                                                  Orientation.portrait)
                                              ? 2
                                              : 3),
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return LightIItem(snapshot.data[index]);
                                  }, childCount: snapshot.data.length),
                                );
                              }

                              return SliverToBoxAdapter(
                                child: Container(),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                BottomClipper(ButtonText.BACK, '', goBack, () {},
                    isNextEnabled: false)
              ],
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Center _progressIndicitaorView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConstants.TOP_CLIPPER_START_DARK.withOpacity(.9)),
        child: CircularProgressIndicator(),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }
}

class LightIItem extends StatefulWidget {
  final Light light;
  const LightIItem(
    this.light, {
    Key key,
  }) : super(key: key);

  @override
  _LightIItemState createState() => _LightIItemState();
}

class _LightIItemState extends State<LightIItem> {
  Light light;
  @override
  void initState() {
    super.initState();
    this.light = widget.light;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: ColorConstants.BCKG_COLOR_END,
      child: new GridTile(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SpaceH32(),
            Expanded(
              flex: 4,
              child: Container(
                  child: SvgPicture.asset(
                ImagePaths.svgBulbLarge,
                color: light.status ? Color(light.color) : Colors.grey,
                fit: BoxFit.fitHeight,
                cacheColorFilter: true,
                allowDrawingOutsideViewBox: true,
                alignment: Alignment.center,
                matchTextDirection: true,
              )),
            ),
            Container(
              child: Listener(
                onPointerUp: (event) {
                  this.light.status = !this.light.status;
                  Provider.of<LightControlDataProvider>(context, listen: false)
                      .updateLight(this.light)
                      .then((value) {
                    setState(() {});
                  });
                },
                child: CustomPaint(
                  size: Size.square(32),
                  painter: new SwitchPainter(isSwitchOn: this.light.status),
                ),
              ),
            ),
            SpaceH32()
            // Container(
            //     child: Center(
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 32.0),
            //     child: new Text(light.ata),
            //   ),
            // )),
          ],
        ),
        footer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(light.id.toString()),
        ),
      ),
    );
  }
}

class SwitchPainter extends CustomPainter {
  bool isSwitchOn = true;
  SwitchPainter({this.isSwitchOn});
  @override
  void paint(Canvas canvas, Size size) {
    var arcPaint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var controllBarPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Path path = new Path();
    path.moveTo(size.width * .4, 0);
    path.lineTo(size.width * .6, 0);
    path.lineTo(size.width * .6, size.height);
    path.lineTo(size.width * .4, size.height);
    path.close();

    Path swithcOffPath = new Path();
    swithcOffPath.moveTo(size.width * .4, size.height * .7);
    swithcOffPath.lineTo(size.width * .6, size.height * .7);
    swithcOffPath.lineTo(size.width * .6, size.height);
    swithcOffPath.lineTo(size.width * .4, size.height);
    swithcOffPath.close();

    Path swithcOnPath = new Path();

    swithcOnPath.moveTo(size.width * .4, size.height * .3);
    swithcOnPath.lineTo(size.width * .6, size.height * .3);
    swithcOnPath.lineTo(size.width * .6, 0);
    swithcOnPath.lineTo(size.width * .4, 0);

    swithcOnPath.close();

    if (isSwitchOn) {
      // canvas.save();
      // canvas.rotate(math.pi * 2);
      canvas.drawPath(swithcOnPath, controllBarPaint);
      canvas.drawShadow(swithcOnPath, Colors.black.withAlpha(255), 2.0, true);
      // canvas.restore();
    } else {
      canvas.drawPath(swithcOffPath, controllBarPaint);
      canvas.drawShadow(swithcOffPath, Colors.black.withAlpha(255), 2.0, true);
    }

    canvas.drawPath(path, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
