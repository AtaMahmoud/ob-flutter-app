import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/colorpicker/flutter_hsvcolor_picker.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/iot/light_control_data_provider.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/custom_switch.dart';
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
                    child: FutureBuilder<List<Light>>(
                        future: Provider.of<LightControlDataProvider>(context,
                                listen: false)
                            .getAllLigts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _progressIndicitaorView();
                          }

                          if (snapshot.hasData && snapshot.data.length > 0) {
                            return LightIItem(snapshot.data);
/*                                 return SliverGrid(
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
                                ); */
                          }

                          return Container();
                        }),
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
  final List<Light> lights;
  const LightIItem(
    this.lights, {
    Key key,
  }) : super(key: key);

  @override
  _LightIItemState createState() => _LightIItemState();
}

class _LightIItemState extends State<LightIItem> {
  List<Light> lights;
  @override
  void initState() {
    super.initState();
    this.lights = widget.lights;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(4.0),
      //this is what you actually need
      child: new StaggeredGridView.count(
        shrinkWrap: true,
        crossAxisCount: 4, // I only need two card horizontally
        padding: const EdgeInsets.all(2.0),
        children: lights.map<Widget>((item) {
          //Do you need to go somewhere when you tap on this card, wrap using InkWell and add your route
          return /* Text('vbb'); // */ _itemCard(item);
        }).toList(),

        //Here is the place that we are getting flexible/ dynamic card for various images
        staggeredTiles:
            lights.map<StaggeredTile>((_) => StaggeredTile.fit(2)).toList(),
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 4.0, // add some space
      ),
    );
  }

  _itemCard(Light light) {
    var textColor = Color(0xff8B96A9);
    var sliderActiveColor = Color(0xffCBD1DC);
    double brightness = light.brightnessLevel * 100;

    return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpaceH32(),
                      Text(
                        '${light.name}',
                        style: TextStyle(color: textColor, fontSize: 48.sp),
                      ),
                      SpaceH32(),
                      Text(
                        '${brightness.round().toString()}%',
                        style: TextStyle(color: textColor, fontSize: 96.sp),
                      )
                    ],
                  ),
                ),
                Container(
                    child: SvgPicture.asset(
                  ImagePaths.svgBulbLarge,
                  color: light.status
                      ? Color(light.color).withOpacity(light.brightnessLevel)
                      : Colors.grey,
                  height: 58,
                  fit: BoxFit.contain,
                  cacheColorFilter: true,
                  allowDrawingOutsideViewBox: true,
                  alignment: Alignment.center,
                  matchTextDirection: true,
                )),
              ],
            ),
            SpaceH32(),
            Container(
              child: SliderTheme(
                data: SliderThemeData(
                    trackShape: CustomTrackShape(),
                    inactiveTrackColor: textColor,
                    activeTrackColor: sliderActiveColor,
                    thumbColor: textColor),
                child: Slider(
                  value: light.brightnessLevel,
                  onChanged: (value) {
                    setState(() {
                      light.brightnessLevel = value;
                    });
                  },
                  // activeColor: textColor,
                  // inactiveColor: textColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: SvgPicture.asset(
                    ImagePaths.svgIcMore,
                    color: textColor,
                  ),
                ),
                CustomSwitch(
                  activeColor: Colors.green,
                  value: light.status,
                  onChanged: (value) {
                    setState(() {
                      light.status = value;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
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
