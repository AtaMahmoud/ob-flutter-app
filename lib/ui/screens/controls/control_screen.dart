import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/fake_data_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/painters/curve_painter.dart';
import 'package:ocean_builder/ui/painters/meterbar_painter.dart';
import 'package:ocean_builder/ui/screens/controls/camera_screen.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_pop_up_widget.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_screen.dart';
import 'dart:math' as math;
import 'package:ocean_builder/ui/shared/grid_menu_helper.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/battery_level_painter.dart';
import 'package:ocean_builder/ui/widgets/control_appbar.dart';
import 'package:ocean_builder/ui/widgets/round_slider_trackbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ControlScreen extends StatefulWidget {
  static const routeName = '/control';

  final GlobalKey<ScaffoldState> scaffoldKey;

  const ControlScreen({this.scaffoldKey});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with TickerProviderStateMixin {
  UserProvider _userProvider;
  FakeDataProvider _fakeDataProvider;
  User _user;
  ScreenUtil _util = ScreenUtil();
  GlobalKey _keyViewCameracircle = GlobalKey();
  GlobalKey _keyViewLightcircle = GlobalKey();

  AnimationController _controller;
  Animation<double> _animation;
  int stairPercent = 0;
  String buttonText = 'LOWER STAIRS';

  SelectedOBIdProvider _selectedOBIdProvider;
  OceanBuilderProvider _oceanBuilderProvider;

  Future<SeaPod> _selectedSeaPodFuture;
  SeaPod _selectedSeaPod;

  bool useMobileLayout;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000 * 10),
    );
    _animation = _controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _fakeDataProvider = Provider.of<FakeDataProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;

    _selectedSeaPod = _userProvider.authenticatedUser != null
        ? _userProvider.authenticatedUser.seaPods[0]
        : null;

    _selectedSeaPodFuture = _oceanBuilderProvider.getSeaPod(
        _selectedOBIdProvider.selectedObId, _userProvider);

    return FutureBuilder(
        future: _selectedSeaPodFuture,
        initialData: _selectedSeaPod,
        builder: (context, snapshot) {
          if (snapshot.hasData) _selectedSeaPod = snapshot.data;
          return _mainContent();
        });
  }

  _mainContent() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
          child: CustomScrollView(
            slivers: <Widget>[
              UIHelper.getTopEmptyContainer(
                  useMobileLayout
                      ? MediaQuery.of(context).size.height * 0.5
                      : MediaQuery.of(context).size.height * 0.65,
                  true),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: _util.setHeight(256),
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // _controlWheelContainer(),
                      _sldiersContainer(),
                      _sensorBatteryLevelContainer(),
                      _controlListContainer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppbarControl(
          ScreenTitle.CONTROLS,
          scaffoldKey: widget.scaffoldKey,
          controlData: _selectedSeaPod.controlData,
        ),
      ],
    );
  }

  void _updateLabels(int init, int end, int laps) {
    setState(() {
      // _fakeDataProvider.fakeData.insideTemperature = end;
      _selectedSeaPod.controlData.insideTemperature = end;
    });
  }

  _controlWheelContainer() {
    double bkgRad =
        MediaQuery.of(context).size.width / 1.75; // util.setWidth(690);
    double movementRad = bkgRad * 0.70;

    var initTime = Random().nextInt(288);
    var endTime = Random().nextInt(288);
    bool viewCameratouchDown = false;
    bool lightingTouchDown = false;
    return Listener(
      onPointerDown: (PointerEvent details) {
        final RenderBox box =
            _keyViewCameracircle.currentContext.findRenderObject();
        final result = BoxHitTestResult();
        Offset localRed = box.globalToLocal(details.position);

        final RenderBox boxLight =
            _keyViewLightcircle.currentContext.findRenderObject();
        Offset localRedLight = boxLight.globalToLocal(details.position);

        if (box.hitTest(result, position: localRed)) {
          viewCameratouchDown = true;
        } else if (boxLight.hitTest(result, position: localRedLight)) {
          lightingTouchDown = true;
        }
      },
      onPointerUp: (PointerEvent details) async {
        final RenderBox box =
            _keyViewCameracircle.currentContext.findRenderObject();
        final result = BoxHitTestResult();
        Offset localRed = box.globalToLocal(details.position);

        final RenderBox boxLight =
            _keyViewLightcircle.currentContext.findRenderObject();
        Offset localRedLight = boxLight.globalToLocal(details.position);

        if (box.hitTest(result, position: localRed)) {
          if (viewCameratouchDown) {
            Navigator.of(context).pushNamed(CameraScreen.routeName);
          }
        } else if (boxLight.hitTest(result, position: localRedLight)) {
          if (lightingTouchDown) {
            if (_user.lightiningScenes.length > 0) {
              PopUpHelpers.showPopup(
                  context, LightingPopupContent(), 'Lighting Screen');
            } else {
              SeaPod seaPod = await _oceanBuilderProvider.getSeaPod(
                  _selectedOBIdProvider.selectedObId, _userProvider);
              OceanBuilderUser _oceanBuilderUser = seaPod.users[0];
              Navigator.of(context).pushNamed(LightingScreen.routeName,
                  arguments: LightingScreenParams(
                      _oceanBuilderUser,
                      _userProvider,
                      _selectedOBIdProvider,
                      null) //_oceanBuilderUser
                  );
            }
          }
        }
        lightingTouchDown = false;
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        // height: util.setHeight(200),
        child: Stack(
          children: <Widget>[
            Positioned(
              key: _keyViewLightcircle,
              left: bkgRad / 5, //util.setWidth(-bkgRad / 2.25),
              bottom: 0, //util.setHeight(bkgRad / 3),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      ColorConstants.LIGHT_GRAD_START,
                      ColorConstants.LIGHT_GRAD_MIDDLE,
                      ColorConstants.LIGHT_GRAD_END,
                    ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                    shape: BoxShape.circle),
                child: CircleAvatar(
                  backgroundColor:
                      Colors.transparent, // ColorConstants.CONTROL_END,
                  radius: bkgRad / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: _util.setHeight(32),
                      ),
                      SvgPicture.asset(
                        ImagePaths.svgBulb,
                        fit: BoxFit.scaleDown,
                      ),
                      Text(
                        'LIGHTING',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontSize: _util.setSp(32)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: bkgRad,
                height: bkgRad,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      ColorConstants.CONTROL_END,
                      ColorConstants.CONTROL_START
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    shape: BoxShape.circle),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    // camera icon
                    Positioned(
                      key: _keyViewCameracircle,
                      left: -bkgRad / 4, //util.setWidth(-bkgRad / 2.25),
                      bottom: bkgRad / 6, //util.setHeight(bkgRad / 3),
                      child: CircleAvatar(
                        backgroundColor: ColorConstants.CONTROL_END,
                        radius: bkgRad / 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePaths.svgCamera,
                              fit: BoxFit.scaleDown,
                            ),
                            Text(
                              'View Camera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstants.MARINE_ITEM_TEXT_COLOR,
                                  fontSize: _util.setSp(32)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // movement text
                    Positioned(
                      right: 0, //util.setWidth(-bkgRad / 2),
                      bottom: 4.0,
                      top: 0.0,
                      child: Transform.rotate(
                        angle: math.pi / 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Transform.rotate(
                              angle: math.pi / 2 - math.pi / 45,
                              child: CircularText(
                                children: [
                                  TextItem(
                                      text: Text(
                                        "MOVEMENT",
                                        style: TextStyle(
                                            fontSize: _util.setSp(36),
                                            fontWeight: FontWeight.w400,
                                            color: ColorConstants
                                                .CONTROL_WHEEL_TEXT),
                                      ),
                                      space: _util.setSp(12),
                                      startAngle: 72,
                                      direction:
                                          CircularTextDirection.clockwise)
                                ],

                                radius: bkgRad, //util.setWidth(bkgRad),
                                position: CircularTextPosition.inside,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // soalr batery text

                    // movement text
                    Positioned(
                      left: 0.0,
                      right: 0, //util.setWidth(-bkgRad / 2),
                      bottom: 0.0,
                      top: 0.0,
                      child: Transform.rotate(
                        angle: math.pi / 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Transform.rotate(
                              angle: math.pi / 2 - math.pi / 45,
                              child: Padding(
                                  padding: EdgeInsets.all(bkgRad / 5.5),
                                  child: CircularText(
                                    children: [
                                      TextItem(
                                        text: Text("SOLAR BATTERY",
                                            style: TextStyle(
                                                fontSize: _util.setSp(36),
                                                fontWeight: FontWeight.w400,
                                                color: ColorConstants
                                                    .CONTROL_WHEEL_TEXT)),
                                        space: _util.setSp(12),
                                        startAngle: 272,
                                        direction:
                                            CircularTextDirection.clockwise,
                                      )
                                    ],

                                    radius: bkgRad / 2, //util.setWidth(bkgRad),

                                    position: CircularTextPosition.inside,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),

                    _batteryLevel(bkgRad, movementRad),
                    _movementIndicatorLevel(bkgRad, movementRad),
                    _movementIndicator(),

                    // inside temperature ---------------------- and temperature slider -------
                    Positioned(
                      top: 8.0,
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                      child: Transform.rotate(
                        angle: math.pi,
                        child: Container(
                          child: SingleCircularSlider(
                            50,
                            _selectedSeaPod.controlData.insideTemperature >= 50
                                ? 24
                                : _selectedSeaPod.controlData.insideTemperature,
                            // height: //movementRad,
                            // width: //movementRad,
                            primarySectors: 0,
                            secondarySectors: 0,
                            baseColor: ColorConstants.CONTROL_ARC_BKG_END,
                            selectionColor: ColorConstants.CONTROL_ARC,
                            handlerColor: Colors.white,
                            handlerRadius: _util.setWidth(26),
                            handlerOutterRadius: _util.setWidth(36),
                            onSelectionChange: _updateLabels,
                            showRoundedCapInSelection: true,
                            showHandlerOutter: false,
                            sliderStrokeWidth: _util.setWidth(42),
                            child: Transform.rotate(
                              angle: math.pi,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${_selectedSeaPod.controlData.insideTemperature} ${SymbolConstant.DEGREE}C',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: _util.setSp(60),
                                          letterSpacing: 0.0,
                                          color: ColorConstants
                                              .CONTROL_WHEEL_TEXT),
                                    ),
                                    Text(
                                      'Temperature Inside',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: _util.setSp(24),
                                          letterSpacing: 0.0,
                                          color: ColorConstants
                                              .CONTROL_WHEEL_TEXT),
                                    ),
                                    _waterAndCoLevel(movementRad),
                                  ],
                                ),
                              ),
                            ),
                            shouldCountLaps: true,
                          ),
                        ),
                      ),
                    ),
                    _acButtons(bkgRad, movementRad),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterAndCoLevel(double movementRad) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomPaint(
            painter: CurvePainter(
                colors: [
                  Color(0xFFA7BEDC).withOpacity(.9),
                  Color(0xFFA7BEDC).withOpacity(.9),
                ],
                showBkgARc: false,
                strokeWidth: 4,
                drawHandler: false,
                angle: 300 *
                    (_selectedSeaPod.controlData.drinkingWaterPercentage /
                        100) //90 + (360 - 90) * (.5) //360*.5//
                ),
            child: SizedBox(
              width: movementRad / 3,
              height: movementRad / 3,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFA7BEDC).withOpacity(.25),
                    borderRadius: BorderRadius.all(
                      Radius.circular(movementRad / 4),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'DRINKING WATER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: _util.setSp(20), //7,
                          letterSpacing: 0.0,
                          color: ColorConstants.CONTROL_WHEEL_TEXT,
                        ),
                      ),
                      Text(
                        '${_selectedSeaPod.controlData.drinkingWaterPercentage}%', //'68%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _util.setSp(42),
                          letterSpacing: 0.0,
                          color: ColorConstants.CONTROL_WHEEL_TEXT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomPaint(
            painter: CurvePainter(
                colors: [
                  Color(0xFFA7BEDC).withOpacity(.9),
                  Color(0xFFA7BEDC).withOpacity(.9),
                ],
                showBkgARc: false,
                strokeWidth: 4,
                drawHandler: false,
                angle: 300 *
                    (_selectedSeaPod.controlData.co2Percentage /
                        100) //90 + (360 - 90) * (.5) //360*.5//
                ),
            child: SizedBox(
              width: movementRad / 3,
              height: movementRad / 3,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFA7BEDC).withOpacity(.25),
                    borderRadius: BorderRadius.all(
                      Radius.circular(movementRad / 4),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'CO2 LEVEL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: _util.setSp(20),
                          letterSpacing: 0.0,
                          color: ColorConstants.CONTROL_WHEEL_TEXT,
                        ),
                      ),
                      Text(
                        '${_selectedSeaPod.controlData.co2Percentage}%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _util.setSp(42),
                          letterSpacing: 0.0,
                          color: ColorConstants.CONTROL_WHEEL_TEXT,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _acButtons(double bkgRad, double movementRad) {
    return Positioned(
      left: movementRad / 2 - bkgRad / 16, //util.setWidth(movementRad),
      bottom: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.remove,
            color: Colors.white,
            size: bkgRad / 12,
          ),
          CircleAvatar(
            radius: bkgRad / 8,
            backgroundColor: ColorConstants.CONTROL_START,
            child: CircleAvatar(
              backgroundColor: Color(0xFF0589CC),
              radius: bkgRad / 12,
              child: SvgPicture.asset(
                ImagePaths.svgAc,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Icon(
            Icons.add,
            color: Colors.white,
            size: bkgRad / 12,
          )
        ],
      ),
    );
  }

  Widget _movementIndicatorLevel(double bkgRad, double movementRad) {
    return Positioned(
      right: bkgRad * .05, //0.0,
      bottom: 0.0,
      top: 0.0,

      child: CustomPaint(
        painter: MeterBarPainter(),
        child: SizedBox(
          width: bkgRad * .9,
          height: bkgRad * .9,
        ),
      ),
    );
  }

  Widget _batteryLevel(double bkgRad, double movementRad) {
    return Positioned(
      right: bkgRad / 7,
      bottom: 0.0,
      top: 0.0,
      child: CustomPaint(
        painter: CurvePainter(
          colors: [
            Color(0xFF4CCB2E).withOpacity(1),
            Color(0xFF4CCB2E).withOpacity(1),
          ],
          bkgColors: [
            Color(0xFF9CB8DA).withOpacity(1),
            Color(0xFF9CB8DA).withOpacity(1),
          ],
          showBkgARc: true,
          drawHandler: false,
          slicedCurve: true,
          strokeWidth: _util.setWidth(8),
          startAngle: 120,
          endAngle: 220,
          angle: 120 +
              _selectedSeaPod.controlData.solarBatteryPercentage
                  .toDouble(), //100.0 * .55
          //90 + (360 - 90) * (.5) //360*.5//
        ),
        child: SizedBox(
          width: movementRad,
          height: movementRad,
        ),
      ),
    );
  }

  Widget _movementIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
      child: CustomPaint(
        painter: IndicatorPainter(
            angle: _selectedSeaPod != null
                ? _selectedSeaPod.controlData.movementAngle.toDouble()
                : 0.0), // min 0 , max 150
      ),
    );
  }

  _controlListContainer() {
    return Container(
      decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgSoalrBattery,
                      itemName: AppStrings.solarBattery,
                      value: _selectedSeaPod != null
                          ? '${_selectedSeaPod.controlData.solarBatteryPercentage} %'
                          : '',
                      onTap: () {}),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgCamera,
                      itemName: AppStrings.cameras,
                      value: '3 Cameras',
                      onTap: () {}),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgWaterLeakDetectors,
                      itemName: AppStrings.waterLeakDetectors,
                      value: 'Normal',
                      onTap: () {}),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgDrikingWaterLevel,
                      itemName: AppStrings.drinkingWaterLevels,
                      value:
                          '${_selectedSeaPod.controlData.drinkingWaterPercentage} %',
                      onTap: () {}),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgCo2Level,
                      itemName: AppStrings.co2Level,
                      value: '${_selectedSeaPod.controlData.co2Percentage} %',
                      onTap: () {}),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgFireDetector,
                      itemName: AppStrings.fireDetector,
                      value:
                          '${_selectedSeaPod.controlData.drinkingWaterPercentage} %',
                      onTap: () {}),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgInsideTemp,
                      itemName: AppStrings.insideTemperature,
                      value:
                          '${_selectedSeaPod.controlData.insideTemperature}${SymbolConstant.DEGREE}C',
                      onTap: () {}),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgFrostWindows,
                      itemName: AppStrings.frostWindows,
                      value:
                          '${_selectedSeaPod.controlData.frostWindowsPercentage} %',
                      onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sensorBatteryLevelContainer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          ColorConstants.CONTROL_START,
          ColorConstants.CONTROL_START
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('SENSOR BATTERY LEVELS'),
          SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _showBatteryLevel(
                      batteryLevel: _selectedSeaPod != null
                          ? _selectedSeaPod
                              .controlData.batteryPercentageWaterLeak
                          : 0,
                      width: _util.setWidth(96),
                      height: _util.setHeight(48),
                      fontSize: _util.setSp(32)),
                  SizedBox(
                    width: _util.setWidth(16.0),
                  ),
                  Text(
                    'Water Leak',
                    style: TextStyle(fontSize: _util.setSp(32)),
                  )
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _showBatteryLevel(
                      batteryLevel: _selectedSeaPod != null
                          ? _selectedSeaPod
                              .controlData.batteryPercentageFireDetectors
                          : 0,
                      width: _util.setWidth(96),
                      height: _util.setHeight(48),
                      fontSize: _util.setSp(32)),
                  SizedBox(
                    width: _util.setWidth(16.0),
                  ),
                  Text(
                    'Fire Detectors',
                    style: TextStyle(fontSize: _util.setSp(32)),
                  )
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _showBatteryLevel(
                      batteryLevel: _selectedSeaPod != null
                          ? _selectedSeaPod.controlData.batteryPercentageC02
                          : 0, //51,
                      width: _util.setWidth(96),
                      height: _util.setHeight(48),
                      fontSize: _util.setSp(32)),
                  SizedBox(
                    width: _util.setWidth(16.0),
                  ),
                  Text(
                    'CO2 Level',
                    style: TextStyle(fontSize: _util.setSp(32)),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _sldiersContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          ColorConstants.BCKG_COLOR_START,
          ColorConstants.BCKG_COLOR_END
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Container(
        // padding: EdgeInsets.all(8),
        // height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'INSIDE TEMPERATURE',
                  style: TextStyle(
                      fontSize: _util.setSp(24),
                      color: ColorConstants.CONTROL_WHEEL_TEXT),
                ),
              ],
            ),
            _sliderNativeInsideTemperature(),
            SizedBox(height: _util.setHeight(32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'FROST WINDOWS',
                  style: TextStyle(
                      fontSize: _util.setSp(24),
                      color: ColorConstants.CONTROL_WHEEL_TEXT),
                ),
              ],
            ),
            _sliderNativeFrostWindows(),
            SizedBox(height: _util.setHeight(32)),
            LinearPercentIndicator(
              percent: stairPercent / 100, //0.75,
              backgroundColor: ColorConstants.CONTROL_END,
              progressColor: ColorConstants.SPLASH_BKG,
              animation: true,
              animateFromLastPercent: true,

              animationDuration: 1000 * 10,
              center: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget child) {
                      String valueText =
                          '${_animation.value.toStringAsFixed(0)}%';
                      if (_animation.value == 0)
                        valueText = AppStrings.stairsFullyLowered;
                      else if (_animation.value == 100)
                        valueText = AppStrings.stairsFullyRaised;
                      return new Text(
                        valueText,
                        style: TextStyle(
                            fontSize: _util.setHeight(32),
                            color: Colors.blueGrey[300],
                            fontWeight: FontWeight.w700),
                      );
                    },
                  ),
                  // Text(
                  //   stairPercent == 100 ? 'STAIR FULLY RAISED': '',//'${stairPercent}%',
                  //   style: TextStyle(fontSize: util.setSp(32), color: Colors.white),
                  // ),
                ],
              ),
              lineHeight: _util.setHeight(48),
              leading: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (buttonText.compareTo(AppStrings.raisingStairs) == 0 ||
                          buttonText.compareTo(AppStrings.loweringStairs) ==
                              0) {
                        return;
                      }
                      setState(() {
                        if (stairPercent == 100)
                          stairPercent = 0;
                        else if (stairPercent == 0)
                          stairPercent = 100;
                        else {
                          return;
                        }
                        _animation = new Tween<double>(
                          begin: _animation.value,
                          end: stairPercent * 1.0,
                        ).animate(new CurvedAnimation(
                          curve: Curves.linear,
                          parent: _controller,
                        ));
                      });
                      _controller.forward(from: 0.0);
                    },
                    child: Container(
                      width: _util.setWidth(350),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(
                              color: Colors.grey, width: _util.setSp(4))),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _util.setHeight(16),
                          bottom: _util.setHeight(16),
                        ),
                        child: new AnimatedBuilder(
                          animation: _animation,
                          builder: (BuildContext context, Widget child) {
                            if (_animation.value == 0)
                              buttonText = AppStrings.raiseStairs;
                            else if (_animation.value == 100)
                              buttonText =
                                  AppStrings.lowerStairs; //'LOWER STAIRS';

                            if (buttonText.compareTo(AppStrings.raiseStairs) ==
                                    0 &&
                                _animation.value != 0)
                              buttonText = AppStrings.raisingStairs;
                            else if (buttonText
                                        .compareTo(AppStrings.lowerStairs) ==
                                    0 &&
                                _animation.value != 100)
                              buttonText = AppStrings.loweringStairs;
                            return new Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: _util.setSp(32),
                                  color: Colors.black),
                            );
                          },
                        ),

                        //      Text(
                        //   'LOWER STAIRS',
                        //   style: TextStyle(fontSize: util.setSp(32), color: Colors.black),
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _util.setWidth(48),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _sliderNativeInsideTemperature() {
    double _sliderValue = _selectedSeaPod != null
        ? _selectedSeaPod.controlData.insideTemperature.toDouble()
        : 0.0;
    return Stack(
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ColorConstants.SPLASH_BKG,
            inactiveTrackColor: ColorConstants.CONTROL_END,
            trackShape: RoundSliderTrackShape(radius: _util.setHeight(32)),
            trackHeight: _util.setHeight(48),
            thumbColor: ColorConstants.SPLASH_BKG,
            thumbShape:
                RoundSliderThumbShape(enabledThumbRadius: _util.setHeight(32)),
            overlayColor: Colors.purple.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
          ),
          child: Slider(
              min: 0.0,
              max: 50.0,
              divisions: 100,
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  debugPrint('inside temperature slider value  $value');
                  _sliderValue = value;
                  _selectedSeaPod.controlData.insideTemperature = value.toInt();
                });
              }),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(16), left: _util.setWidth(32)),
            child: Text(
              '${_sliderValue.toStringAsPrecision(2)}\u{00B0}C',
              style: TextStyle(
                  color: Colors.blueGrey[300],
                  fontSize: _util.setHeight(32),
                  fontWeight: FontWeight.w700),
            ),
          ),
        )
      ],
    );
  }

  _sliderNativeFrostWindows() {
    double _sliderValue = _selectedSeaPod != null
        ? _selectedSeaPod.controlData.frostWindowsPercentage.toDouble()
        : 0.0;
    return Stack(
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ColorConstants.SPLASH_BKG,
            inactiveTrackColor: ColorConstants.CONTROL_END,
            trackShape: RoundSliderTrackShape(radius: _util.setHeight(32)),
            trackHeight: _util.setHeight(48),
            thumbColor: ColorConstants.SPLASH_BKG,
            thumbShape:
                RoundSliderThumbShape(enabledThumbRadius: _util.setHeight(32)),
            overlayColor: Colors.purple.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
          ),
          child: Slider(
              min: 0.0,
              max: 100.0,
              divisions: 100,
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  debugPrint('frost slider value  $value');
                  _sliderValue = value;
                  _selectedSeaPod.controlData.frostWindowsPercentage =
                      value.toInt();
                });
              }),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(16), left: _util.setWidth(32)),
            child: Text(
              '${_sliderValue.toStringAsPrecision(2)}%',
              style: TextStyle(
                  color: Colors.blueGrey[300],
                  fontSize: _util.setHeight(32),
                  fontWeight: FontWeight.w700),
            ),
          ),
        )
      ],
    );
  }

  _showBatteryLevel(
      {double height, double width, double fontSize, int batteryLevel}) {
    var _height = height != null ? height : 24.0;
    var _width = width != null ? width : 48.0;
    var _fontSize = fontSize != null ? fontSize : 16.0;
    var _batteryLevel = batteryLevel != null ? batteryLevel : 50;
    return SizedBox(
        height: _height,
        width: _width,
        child: CustomPaint(
          painter: BatteryLevelPainter(_batteryLevel),
          child: Center(
              child: Text(
            '$_batteryLevel%',
            style: TextStyle(fontSize: _fontSize),
          )), // : Container(),
        ));
  }

  List<UserOceanBuilder> getList() {
    return _user.userOceanBuilder;
  }
}
