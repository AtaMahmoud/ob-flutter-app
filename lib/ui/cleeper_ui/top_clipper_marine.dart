import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/shared_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class TopClipperMarine extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final Future<StormGlassData> futureWOWWeatherData;

  const TopClipperMarine(this.title,
      {this.scaffoldKey, this.innerDrawerKey, this.futureWOWWeatherData});

  @override
  _TopClipperMarineState createState() => _TopClipperMarineState();
}

enum DayState { YESTERDAY, TODAY, TOMORROW }

class _TopClipperMarineState extends State<TopClipperMarine> {
  UserProvider _userProvider;
  ScreenUtil _util;
  DayState _whichDay = DayState.TODAY;
  DateTime _whichDate = DateTime.now();
  var useMobileLayout;
  SourceListBloc _bloc = SourceListBloc();

  @override
  void initState() {
    super.initState();
    _bloc.weatherSourceController.listen((onData) {});
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _util = ScreenUtil();
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
          ? MediaQuery.of(context).size.height * 0.5
          : MediaQuery.of(context).size.height *
              0.65, //ScreenUtil().setHeight(990),
      decoration: BoxDecoration(gradient: topGradientDark),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            0.0, //_util.setWidth(32),
            0.0, //_util.setHeight(32),
            0.0, //_util.setWidth(32),
            _util.setHeight(32)),
        child: widget.scaffoldKey != null
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        _util.setWidth(16),
                        0.0, //_util.setHeight(32),
                        0.0, //_util.setWidth(32),
                        _util.setHeight(32)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            widget.scaffoldKey.currentState.openDrawer();
                            // widget.innerDrawerKey.currentState.toggle();
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                _util.setWidth(32),
                                _util.setHeight(32),
                                _util.setWidth(32),
                                _util.setHeight(32)),
                            child: ImageIcon(
                              AssetImage(ImagePaths.icHamburger),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              _util.setWidth(32),
                              _util.setHeight(32),
                              0.0, //_util.setWidth(32),
                              _util.setHeight(32)),
                          child: Text(
                            widget.title.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(48),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _whichDay = DayState.TODAY;
                                  _whichDate = DateTime.now();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 32.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(48.w),
                                    color: _whichDay == DayState.TODAY
                                        ? ColorConstants.WEATHER_HUMIY_CIRCLE
                                        : ColorConstants.WEATHER_BKG_CIRCLE),
                                child: Text(
                                  'TODAY'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(48),
                                      fontWeight: _whichDay == DayState.TODAY
                                          ? FontWeight.w900
                                          : FontWeight.w400),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _whichDay = DayState.TOMORROW;
                                  _whichDate =
                                      DateTime.now().add(Duration(days: 1));
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 32.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(48.w),
                                    color: _whichDay == DayState.TOMORROW
                                        ? ColorConstants.WEATHER_HUMIY_CIRCLE
                                        : ColorConstants.WEATHER_BKG_CIRCLE),
                                child: Text(
                                  'TOMORROW'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(48),
                                      fontWeight: _whichDay == DayState.TOMORROW
                                          ? FontWeight.w900
                                          : FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(0.0),
                            ScreenUtil().setHeight(32.0),
                            ScreenUtil().setWidth(32.0),
                            ScreenUtil().setHeight(32.0),
                          ),
                          child: _marineSummeryContainer()),
                    ],
                  ),
                ],
              )
            : Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(48),
                    fontWeight: FontWeight.w400),
              ),
      ),
    );
  }

// 189,171, 111, 84  within 325 x 209 w = 375
  Widget _marineSummeryContainer() {
    return LayoutBuilder(
      builder: (context, constraint) => Stack(
        children: <Widget>[
          Container(
            width: constraint.maxWidth,
            child: CircleAvatar(
              maxRadius: constraint.maxWidth / 4,
              backgroundColor: ColorConstants.WEATHER_BKG_CIRCLE,
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(64.0)),
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
                            child: _waveHeightDataWidgetFuture(
                                constraint.maxWidth /
                                    8) //_chanceOfRainColumn(),
                            ),
                      ],
                    ),
                    SizedBox(
                      width: constraint.maxWidth / 2.75,
                    ),
                    CircleAvatar(
                      maxRadius: constraint.maxWidth / 6.5,
                      backgroundColor: ColorConstants.WEATHER_HUMIY_CIRCLE,
                      child: _visibilityDataWidgetFuture(
                          constraint.maxWidth / 2.75), //_humidityDataColumn(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
              // height: constraint.maxWidth / 1.5,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: constraint.maxWidth / 4.5,
                    backgroundColor: ColorConstants.WEATHER_TEMP_CIRCLE,
                    child: _waterTempDataWidgetFuture(
                        constraint.maxWidth / 4.5), //_temDataColumn(),
                  ),
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

  Widget _waterTempDataWidgetFuture(double d) {
    return FutureBuilder<StormGlassData>(
        future: widget.futureWOWWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _waterTemDataColumn(snapshot.data, d)
              : Center(child: CircularProgressIndicator());
        });
  }

// int degree = 0x00B0;
  _waterTemDataColumn(StormGlassData data, double d) {
    if (data.hours == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: _util.setWidth(48),
                color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );
    String _temperature;

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(_whichDate);

      if (dDate.compareTo(currentDate) == 0) {
        _temperature = f.waterTemperatureList.attributeDataList[0].value
            .toStringAsFixed(1);
      }
    }

    if (_temperature == null && _whichDay == DayState.TODAY) {
      _temperature = data
              .hours[0].waterTemperatureList.attributeDataList[0].value
              .toStringAsFixed(1) ??
          '0';
    }

    return InkWell(
      onTap: () {
        debugPrint('show water temp graph');

        PopUpHelpers.showChartPopup(
            context,
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
                //  height: ScreenUtil().setHeight(512),
                width: MediaQuery.of(context).size.width,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BeizerChartPopup(
                        data: data,
                        title: AppStrings.waterTemp,
                        iconPath: ImagePaths.svgWaterTemp,
                        bloc: _bloc),
                  ],
                ),
              ),
            ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            child: SvgPicture.asset(
              ImagePaths.svgWaterTemp,
              color: Colors.white,
              // fit: BoxFit.scaleDown,
              width: d / 1.75,
              height: d / 1.75,
            ),
          ),
          Text(
            AppStrings.waterTemp,
            style: TextStyle(fontSize: ScreenUtil().setSp(36)),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            child: Text(
              '$_temperature\u{00B0}C',
              style: TextStyle(fontSize: ScreenUtil().setSp(108)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _visibilityDataWidgetFuture(double d) {
    return FutureBuilder<StormGlassData>(
        future: widget.futureWOWWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _visibilityDataColumn(snapshot.data, d)
              : Center(child: CircularProgressIndicator());
        });
  }

  _visibilityDataColumn(StormGlassData data, double d) {
    if (data.hours == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: _util.setWidth(48),
                color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );

    String _visibility = '';

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(_whichDate);

      if (dDate.compareTo(currentDate) == 0) {
        _visibility =
            f.visiblityList.attributeDataList[0].value.toStringAsFixed(0);
      }
    }

    if (_visibility == null && _whichDay == DayState.TODAY) {
      _visibility = data.hours[0].visiblityList.attributeDataList[0].value
              .toStringAsFixed(0) ??
          '0';
    }

    return InkWell(
      onTap: () {
        debugPrint('show visibility graph');
        PopUpHelpers.showChartPopup(
            context,
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
                //  height: ScreenUtil().setHeight(512),
                width: MediaQuery.of(context).size.width,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BeizerChartPopup(
                        data: data,
                        title: AppStrings.visibility,
                        iconPath: ImagePaths.svgVisibility,
                        bloc: _bloc),
                  ],
                ),
              ),
            ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            child: SvgPicture.asset(
              ImagePaths.svgVisibility,
              // fit: BoxFit.scaleDown,
              color: Colors.white,
              width: d / 7,
              height: d / 7,
            ),
          ),
          Text(
            '$_visibility Meters',
            style: TextStyle(fontSize: ScreenUtil().setSp(48)),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
            child: Text(
              AppStrings.visibility,
              style: TextStyle(fontSize: ScreenUtil().setSp(24)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _waveHeightDataWidgetFuture(double d) {
    return FutureBuilder<StormGlassData>(
        future: widget.futureWOWWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _waveHeightColumn(snapshot.data, d) //movieGrid(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  _waveHeightColumn(StormGlassData data, double d) {
    if (data.hours == null)
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: _util.setWidth(48),
                color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );

    String _waveHeight = '';

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(_whichDate);

      if (dDate.compareTo(currentDate) == 0) {
        _waveHeight =
            f.significantWaveList.attributeDataList[0].value.toString() ?? '0';
      }
    }

    if (_waveHeight == null && _whichDay == DayState.TODAY) {
      _waveHeight = data.hours[0].significantWaveList.attributeDataList[0].value
              .toString() ??
          '0';
    }

    return InkWell(
      onTap: () {
        debugPrint('show wave height graph');
        PopUpHelpers.showChartPopup(
            context,
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
                //  height: ScreenUtil().setHeight(512),
                width: MediaQuery.of(context).size.width,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BeizerChartPopup(
                        data: data,
                        title: AppStrings.waveHeight,
                        iconPath: ImagePaths.svgWaveHeight,
                        bloc: _bloc),
                  ],
                ),
              ),
            ));
      },
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                child: SvgPicture.asset(
                  ImagePaths.svgWaveHeight,
                  // fit: BoxFit.scaleDown,
                  color: Colors.white,
                  width: d / 1.5,
                  height: d / 1.5,
                ),
              ),
              Text(
                '$_waveHeight Meters',
                style: TextStyle(fontSize: ScreenUtil().setSp(32)),
              ),
            ],
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: CircularText(
              children: [
                TextItem(
                    text: Text(
                      " WAVE HEIGHT",
                      style: TextStyle(
                        fontSize: _util.setSp(96),
                      ),
                    ),
                    startAngle: 145,
                    direction: CircularTextDirection.anticlockwise),
              ],

              radius: _util.setWidth(296),
              position: CircularTextPosition.outside,
              // spacing: _util.setSp(32),
            ),
          )
        ],
      ),
    );
  }
}
