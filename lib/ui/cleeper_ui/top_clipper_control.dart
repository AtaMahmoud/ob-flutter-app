import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/control_data.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/screens/controls/camera_screen.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_pop_up_widget.dart';
import 'package:ocean_builder/ui/screens/controls/lighting_screen.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:provider/provider.dart';

class TopClipperControl extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final ControlData controlData;

  const TopClipperControl(this.title,
      {this.scaffoldKey, this.innerDrawerKey, this.controlData});

  @override
  _TopClipperControlState createState() => _TopClipperControlState();
}

enum DayState { YESTERDAY, TODAY, TOMORROW }

class _TopClipperControlState extends State<TopClipperControl> {
  var useMobileLayout;
  User _user;
  SelectedOBIdProvider _selectedOBIdProvider;
  OceanBuilderProvider _oceanBuilderProvider;
  UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _selectedOBIdProvider = Provider.of<SelectedOBIdProvider>(context);
    _oceanBuilderProvider = Provider.of<OceanBuilderProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: <Widget>[
          ClipPath(
              clipper: WeatherTopShapeClipper(), child: _customContainer()),
        ],
      ),
    );
  }

  _customContainer() {
    return Container(
      height: useMobileLayout
          ? MediaQuery.of(context).size.height * 0.45
          : MediaQuery.of(context).size.height *
              0.6,
      decoration: BoxDecoration(gradient: topGradientDark),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.h),
        child: widget.scaffoldKey != null
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0.0, 0.0, 32.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            widget.scaffoldKey.currentState.openDrawer();
                            
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 32.h),
                            child: ImageIcon(
                              AssetImage(ImagePaths.icHamburger),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(32.w, 32.h, 0.0, 32.h),
                          child: Text(
                            widget.title.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 48.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            0,
                            32.w,
                            0,
                          ),
                          child: _controlSummaryContainer()),
                    ],
                  ),
                ],
              )
            : Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w400),
              ),
      ),
    );
  }

// 189,171, 111, 84  within 325 x 209 w = 375
  Widget _controlSummaryContainer() {
    return LayoutBuilder(
      builder: (context, constraint) => Stack(
        children: <Widget>[
          Container(
            width: constraint.maxWidth,
            child: CircleAvatar(
              maxRadius: constraint.maxWidth / 4,
              backgroundColor: ColorConstants.WEATHER_BKG_CIRCLE,
              child: Container(
                margin: EdgeInsets.only(left: 64.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CircleAvatar(
                            maxRadius: constraint.maxWidth / 8,
                            backgroundColor: ColorConstants.WEATHER_RAIN_CIRCLE,
                            child: _lightingColumn(
                                widget.controlData, constraint.maxWidth / 8)),
                      ],
                    ),
                    SizedBox(
                      width: constraint.maxWidth / 2.75,
                    ),
                    CircleAvatar(
                        maxRadius: constraint.maxWidth / 6.5,
                        backgroundColor: ColorConstants.WEATHER_HUMIY_CIRCLE,
                        child: _cameraDataColumn(
                            widget.controlData, constraint.maxWidth / 6.5)),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      maxRadius: constraint.maxWidth / 4.5,
                      backgroundColor: ColorConstants.WEATHER_TEMP_CIRCLE,
                      child: _solarBatteryDataColumn(
                          widget.controlData, constraint.maxWidth / 4.5)),
                  Container(
                    height: constraint.maxWidth / 10,
                    width: constraint.maxWidth / 2.25,
                    decoration: new BoxDecoration(boxShadow: [
                      new BoxShadow(
                        color: Colors.black54,
                        blurRadius: 50.0,
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// int degree = 0x00B0;
  _solarBatteryDataColumn(ControlData data, double d) {
    if (data.insideTemperature == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: 48.w, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );
    String _solarBatteryLevel;

    _solarBatteryLevel = data.solarBatteryPercentage.toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(32.w),
          child: SvgPicture.asset(
            ImagePaths.svgSoalrBattery,
            color: Colors.white,
            // fit: BoxFit.scaleDown,
            width: d / 2,
            height: d / 2,
          ),
        ),
        Text(
          AppStrings.solarBatteryTitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 36.sp),
        ),
        Padding(
          padding: EdgeInsets.all(32.w),
          child: Text(
            '$_solarBatteryLevel%',
            style: TextStyle(fontSize: 108.sp),
          ),
        ),
      ],
    );
  }

  _cameraDataColumn(ControlData data, double d) {
    if (data == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: 48.w, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(CameraScreen.routeName);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SvgPicture.asset(
              ImagePaths.svgCamera,
              // fit: BoxFit.scaleDown,
              color: Colors.white,
              width: d / 1.75,
              height: d / 1.75,
            ),
          ),
          Text(
            AppStrings.cameras,
            style: TextStyle(
              fontSize: 48.sp,
            ),
          ),
        ],
      ),
    );
  }

  _lightingColumn(ControlData data, double d) {
    if (data == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: 48.w, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );

    return InkWell(
      onTap: () async {
        SeaPod seaPod = await _oceanBuilderProvider.getSeaPod(
            _selectedOBIdProvider.selectedObId, _userProvider);
        if (seaPod == null) {
          showInfoBar('Select SeaPod', 'Select active seapod from drawer menu',
              context);
          return;
        }
        OceanBuilderUser _oceanBuilderUser = seaPod.activeUser;
        if ((_oceanBuilderUser.lighting.sceneList != null &&
                _oceanBuilderUser.lighting.sceneList.isNotEmpty) ||
            (seaPod.lightScenes != null && seaPod.lightScenes.isNotEmpty)) {
          PopUpHelpers.showPopup(
              context, LightingPopupContent(), 'Lighting Screen');
        } else {
          Navigator.of(context).pushNamed(LightingScreen.routeName,
              arguments: LightingScreenParams(_oceanBuilderUser, _userProvider,
                  _selectedOBIdProvider, null));
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
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
              radius: 296.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    ImagePaths.svgBulbLarge,
                    width: d / 1.25,
                    height: d / 1.25,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(48.w),
              child: CircularText(
                children: [
                  TextItem(
                      text: Text(
                        'L I G H T I N G', //AppStrings.lighting,
                        style: TextStyle(
                          fontSize: 96.sp,
                        ),
                      ),
                      startAngle: 160,
                      direction: CircularTextDirection.anticlockwise)
                ],
                radius: 256.w,
                position: CircularTextPosition.outside,
              ),
            ),
          )
        ],
      ),
    );
  }
}
