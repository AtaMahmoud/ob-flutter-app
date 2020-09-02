import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/custom_clipper/custom_clipper.dart';
import 'package:ocean_builder/helper/url_launcher_helper.dart';
import 'package:ocean_builder/map/darksky_map.dart';
import 'package:ocean_builder/ui/screens/weather/weather_formulas.dart';
import 'package:ocean_builder/ui/screens/weather/weather_more_widget.dart';
import 'package:ocean_builder/ui/shared/app_colors.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/shared_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class TopClipperWeather extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final Future<StormGlassData> futureWOWWeatherData;

  const TopClipperWeather(this.title,
      {this.scaffoldKey, this.innerDrawerKey, this.futureWOWWeatherData});

  @override
  _TopClipperWeatherState createState() => _TopClipperWeatherState();
}

enum DayState { YESTERDAY, TODAY, TOMORROW }

class _TopClipperWeatherState extends State<TopClipperWeather> {
  UserProvider _userProvider;
  ScreenUtil _util;
  DayState _whichDay = DayState.TODAY;
  DateTime _whichDate = DateTime.now();
  var useMobileLayout;

  OverlayEntry sticky;
  GlobalKey stickyKey = GlobalKey();

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
          Positioned(
            left: ScreenUtil().setWidth(32),
            bottom: constraints.maxHeight / 2 * 1 / 8,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(WeatherMoreWidget.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                        _util.setWidth(8),
                      ),
                      child: Text(
                        'MORE',
                        style: TextStyle(
                          color: ColorConstants.SCALE_COLOR_LIGHT,
                          fontSize: ScreenUtil().setSp(36),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      ImagePaths.svgMoreIcon,
                      fit: BoxFit.cover,
                      width: ScreenUtil().setSp(36),
                      height: ScreenUtil().setSp(24),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  _customContainer() {
    return Container(
      height: useMobileLayout
          ? MediaQuery.of(context).size.height * 0.55
          : MediaQuery.of(context).size.height *
              0.7, //ScreenUtil().setHeight(990),
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
                          child: _weatherSummeryContainer()),
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
  Widget _weatherSummeryContainer() {
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
                            child:
                                _chanceOfRainDataWidgetFuture() //_chanceOfRainColumn(),
                            ),
                      ],
                    ),
                    SizedBox(
                      width: constraint.maxWidth / 2.75,
                    ),
                    CircleAvatar(
                      maxRadius: constraint.maxWidth / 6.5,
                      backgroundColor: ColorConstants.WEATHER_HUMIY_CIRCLE,
                      child:
                          _humidityDataWidgetFuture(), //_humidityDataColumn(),
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
                    child: _tempDataWidgetFuture(), //_temDataColumn(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // key: stickyKey,
                        height: constraint.maxWidth / 10,
                        width: constraint.maxWidth / 2.25,
                        decoration: new BoxDecoration(boxShadow: [
                          new BoxShadow(
                            color: Colors.black54,
                            blurRadius: 50.0,
                          ),
                        ]),
                      ),
                      // _mapIconWidget(),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * .18,
            bottom: 0.0,
            child: _mapIconWidget(),
          )
        ],
      ),
    );
  }

  Widget _tempDataWidgetFuture() {
    return FutureBuilder<StormGlassData>(
        future: widget.futureWOWWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _temDataColumn(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

// int degree = 0x00B0;
  _temDataColumn(StormGlassData data) {
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
    String _temperature,
        _feelsLikeTemperature,
        _weatherCondition,
        _weatherIconUrl;

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(_whichDate);

      if (dDate.compareTo(currentDate) == 0) {
        _weatherIconUrl = WeatherDescMap.weatherCodeMap['116'].last;
        _weatherCondition = WeatherDescMap.weatherCodeMap['116'].first;
        _temperature =
            f.airTemperatureList.attributeDataList[0].value.toString();
        // _feelsLikeTemperature = data
        //     .hours[0].airTemperatureList.attributeDataList[0].value
        //     .round()
        //     .toString();
        _feelsLikeTemperature = getFeelsLikeTemperature(
                f.airTemperatureList.attributeDataList[0].value,
                f.humidityList.attributeDataList[0].value,
                f.windSpeedList.attributeDataList[0].value)
            .round()
            .toString();
      }
    }

    if (_temperature == null && _whichDay == DayState.TODAY) {
      _weatherIconUrl = WeatherDescMap.weatherCodeMap[116].last;
      _weatherCondition = WeatherDescMap.weatherCodeMap[116].first;
      _temperature = data.hours[0].airTemperatureList.attributeDataList[0].value
          .toString();
      // _feelsLikeTemperature = data
      //     .hours[0].airTemperatureList.attributeDataList[0].value
      //     .round()
      //     .toString();
      _feelsLikeTemperature = getFeelsLikeTemperature(
              data.hours[0].airTemperatureList.attributeDataList[0].value,
              data.hours[0].humidityList.attributeDataList[0].value,
              data.hours[0].windSpeedList.attributeDataList[0].value)
          .round()
          .toString();
    }

    return InkWell(
      onTap: () {
        debugPrint('show temperature graph');
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
                        title: AppStrings.temperature,
                        iconPath: ImagePaths.svgInsideTemp,
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
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: SvgPicture.asset(
              _weatherIconUrl,
              color: Colors.white,
              fit: BoxFit.scaleDown,
            ),
          ),
          Text(
            '$_weatherCondition',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: ScreenUtil().setSp(36)),
          ),
          Text(
            '$_temperature\u{00B0}C',
            style: TextStyle(fontSize: ScreenUtil().setSp(108)),
          ),
          Text(
            'Feels Like: $_feelsLikeTemperature\u{00B0}C',
            style: TextStyle(fontSize: ScreenUtil().setSp(32)),
          ),
        ],
      ),
    );
  }

  Widget _humidityDataWidgetFuture() {
    return FutureBuilder<StormGlassData>(
        future: widget.futureWOWWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _humidityDataColumn(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  _humidityDataColumn(StormGlassData data) {
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

    String _humidity = '';

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(_whichDate);

      if (dDate.compareTo(currentDate) == 0) {
        _humidity = f.humidityList.attributeDataList[0].value.toString();
      }
    }

    if (_humidity == null && _whichDay == DayState.TODAY) {
      _humidity =
          data.hours[0].humidityList.attributeDataList[0].value.toString() ??
              '0';
    }

    return InkWell(
      onTap: () {
        debugPrint('show humidity graph');

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
                        title: AppStrings.humidity,
                        iconPath: ImagePaths.svgHumidity,
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
              ImagePaths.svgHumidity,
              fit: BoxFit.scaleDown,
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setWidth(100),
            ),
          ),
          Text(
            '$_humidity%',
            style: TextStyle(fontSize: ScreenUtil().setSp(48)),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
            child: Text(
              'HUMIDITY',
              style: TextStyle(fontSize: ScreenUtil().setSp(24)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chanceOfRainDataWidgetFuture() {
    return FutureBuilder<StormGlassData>(
        future: widget.futureWOWWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _chanceOfRainColumn(snapshot.data) //movieGrid(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  _chanceOfRainColumn(StormGlassData data) {
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

    String _chanceOfRain = '';

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      var dDate = DateFormat('yMd').format(date1);
      var currentDate = DateFormat('yMd').format(_whichDate);

      if (dDate.compareTo(currentDate) == 0) {
        _chanceOfRain =
            f.precipitationList.attributeDataList[0].value.toString() ?? '0';
      }
    }

    if (_chanceOfRain == null && _whichDay == DayState.TODAY) {
      _chanceOfRain = data.hours[0].precipitationList.attributeDataList[0].value
              .toString() ??
          '0';
    }

    return InkWell(
      onTap: () {
        debugPrint('open precipitation graph');

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
                        title: AppStrings.chanceOfRain,
                        iconPath: ImagePaths.svgUmbrella,
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
                  ImagePaths.svgUmbrella,
                  fit: BoxFit.contain,
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setWidth(100),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_util.setWidth(8)),
                child: Text(
                  '  $_chanceOfRain%  ',
                  style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                ),
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
                    text: Text("CHANCE OF RAIN",
                        style: TextStyle(
                          fontSize: _util.setSp(96),
                        )),
                    startAngle: 155,
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

  Widget _mapIconWidget() {
    return InkWell(
        onTap: () async {
          // Navigator.of(context).pushNamed(WebViewDarksky.routeName);

          // open url launcher to launch openweathermap

          await launchInWebViewWithJavaScript(Config.OPEN_WEATHER_MAP_URL);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(
                16.h,
              ),
              child: SvgPicture.asset(
                ImagePaths.svgMap,
                fit: BoxFit.cover,
                width: 108.h,
                height: 108.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                _util.setWidth(8),
              ),
              child: Text(
                'MAP',
                style: TextStyle(
                  color: ColorConstants.SCALE_COLOR_LIGHT,
                  fontSize: 32.sp,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
