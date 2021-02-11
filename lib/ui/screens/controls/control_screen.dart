import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/fake_data_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'dart:math' as math;
import 'package:ocean_builder/ui/shared/grid_menu_helper.dart';
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
  // ScreenUtil _util = ScreenUtil();
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
              _topEmptyContainer(),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: 256.h,
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

  _topEmptyContainer() {
    return UIHelper.getTopEmptyContainer(
        useMobileLayout
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.65,
        true);
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
                      width: 96.w,
                      height: 48.h,
                      fontSize: 32.sp),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    'Water Leak',
                    style: TextStyle(fontSize: 32.sp),
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
                      width: 96.w,
                      height: 48.h,
                      fontSize: 32.sp),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    'Fire Detectors',
                    style: TextStyle(fontSize: 32.sp),
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
                      width: 96.w,
                      height: 48.h,
                      fontSize: 32.sp),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    'CO2 Level',
                    style: TextStyle(fontSize: 32.sp),
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
                      fontSize: 24.sp,
                      color: ColorConstants.CONTROL_WHEEL_TEXT),
                ),
              ],
            ),
            _sliderNativeInsideTemperature(),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'FROST WINDOWS',
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: ColorConstants.CONTROL_WHEEL_TEXT),
                ),
              ],
            ),
            _sliderNativeFrostWindows(),
            SizedBox(height: 32.h),
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
                            fontSize: 32.sp,
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
              lineHeight: 48.h,
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
                      width: 350.w,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey, width: 4.sp)),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 16.h,
                          bottom: 16.h,
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
                                  fontSize: 32.sp, color: Colors.black),
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
                    width: 48.w,
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
            trackShape: RoundSliderTrackShape(radius: 32.h),
            trackHeight: 48.h,
            thumbColor: ColorConstants.SPLASH_BKG,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 32.h),
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
            padding: EdgeInsets.only(top: 16.h, left: 32.w),
            child: Text(
              '${_sliderValue.toStringAsPrecision(2)}\u{00B0}C',
              style: TextStyle(
                  color: Colors.blueGrey[300],
                  fontSize: 32.h,
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
    print(
        'Slider value in _sliderNativeFrostWindows ---------------------- $_sliderValue');
    return Stack(
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ColorConstants.SPLASH_BKG,
            inactiveTrackColor: ColorConstants.CONTROL_END,
            trackShape: RoundSliderTrackShape(radius: 32.h),
            trackHeight: 48.h,
            thumbColor: ColorConstants.SPLASH_BKG,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 32.h),
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
            padding: EdgeInsets.only(top: 16.h, left: 32.w),
            child: Text(
              '${_sliderValue.toStringAsPrecision(2)}%',
              style: TextStyle(
                  color: Colors.blueGrey[300],
                  fontSize: 32.h,
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
