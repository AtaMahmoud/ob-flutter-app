import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/models/weather_data_day.dart';
import 'package:ocean_builder/core/providers/storm_glass_data_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/custom_drawer/homeDrawer.dart';
import 'package:ocean_builder/ui/cleeper_ui/weather_by_day_info_list.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:intl/intl.dart';

class WeatherMoreWidget extends StatefulWidget {
  static const String routeName = '/weatherMoreWidget';

  @override
  _WeatherMoreWidgetState createState() => _WeatherMoreWidgetState();
}

class _WeatherMoreWidgetState extends State<WeatherMoreWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Future<StormGlassData> _futureWeatherData;
  Future<StormGlassData> _futureWOWWeatherData;

  bool tempInCelsius = true;

  bool isShortTerm = true;

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: Colors.white);
    Future.delayed(Duration.zero).then((_) {
      _futureWOWWeatherData =
          Provider.of<StormGlassDataProvider>(context, listen: false)
              .fetchNext7DaysWeatherData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    // if (mounted)
    _futureWOWWeatherData =
        Provider.of<StormGlassDataProvider>(context, listen: false)
            .fetchNext7DaysWeatherData();
    return _mainContent(); //customDrawer(_innerDrawerKey, _mainContent());
  }

  _mainContent() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(
          isSecondLevel: true,
          screenIndex: DrawerIndex.WEATHER,
        ),
        drawerScrimColor: AppTheme.drawerScrimColor.withOpacity(.65),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(8)
          ),
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  _startSpace(),
                  SliverToBoxAdapter(
                    child: Container(
                      // height: util.setHeight(960),
                      child: _weatherDataFuture(),
                    ),
                  ),
                  _next7DaysweatherDataFuture(),
                ],
              ),
              // Appbar(ScreenTitle.OB_SELECTION),
              _topBar()
            ],
          ),
        ),
      ),
    );
  }

  Positioned _topBar() {
    return Positioned(
      top: ScreenUtil.statusBarHeight,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        // padding: EdgeInsets.only(top: 8.0, right: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 32.w, right: 32.w, top: 32.h, bottom: 32.h),
                        child: ImageIcon(
                          AssetImage(ImagePaths.icHamburger),
                          color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          32.w,
                          32.h,
                          0.0, //_util.setWidth(32),
                          32.h),
                      child: Text(
                        ScreenTitle.WEATHER,
                        style: TextStyle(
                            color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                            fontSize: 70.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    goBack();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 32.w,
                      right: 32.w,
                      top: 32.h,
                      bottom: 32.h,
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: 15,
                      height: 15,
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8),
                  child: Text(
                    'Next 24 Hours',
                    style: TextStyle(
                        color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _startSpace() {
    return UIHelper.getTopEmptyContainerWithColor(
        ScreenUtil.statusBarHeight * 4, Colors.white);
  }

  Widget _shortTermLongTerm() {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Container(
        height: 54.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  setState(() {
                    isShortTerm = true;
                  });
                },
                padding:
                    EdgeInsets.only(left: 32.w, right: 32.w, top: 0, bottom: 0),
                child: Text(
                  'SHORT TERM',
                  style: TextStyle(fontSize: 28.sp),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(48.w),
                    side: BorderSide(
                      color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                    )),
                textColor: isShortTerm
                    ? Colors.white
                    : ColorConstants.ACCESS_MANAGEMENT_TITLE,
                color: isShortTerm
                    ? ColorConstants.LIGHT_POPUP_TEXT
                    : Colors.white),
            SizedBox(
              width: 32.w,
            ),
            RaisedButton(
                onPressed: () {
                  setState(() {
                    isShortTerm = false;
                  });
                },
                padding:
                    EdgeInsets.only(left: 32.w, right: 32.w, top: 0, bottom: 0),
                child: Text(
                  'LONG TERM',
                  style: TextStyle(fontSize: 28.sp),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(48.w),
                  side: BorderSide(
                    color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                  ),
                ),
                textColor: !isShortTerm
                    ? Colors.white
                    : ColorConstants.ACCESS_MANAGEMENT_TITLE,
                color: !isShortTerm
                    ? ColorConstants.LIGHT_POPUP_TEXT
                    : Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _horizontalLine() {
    return SvgPicture.asset(
      ImagePaths.svgWeatherInfoDividerLine,
      fit: BoxFit.fitWidth,
      color: ColorConstants.WEATHER_BKG_CIRCLE,
      // width: MediaQuery.of(context).size.width*.95,
    );
  }

  Widget _next7DaysweatherDataFuture() {
    return FutureBuilder<StormGlassData>(
        future: _futureWOWWeatherData,
        //initialData: StormGlassData(hours: [HourData(), HourData()]),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _daysData(snapshot.data) //movieGrid(snapshot.data)
              : SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  )),
                ); //Center(child: CircularProgressIndicator());
        });
  }

  Widget _daysData(StormGlassData data) {
/*     if (data.data.weathers.length < 24)
      return SliverToBoxAdapter(
        child: Container(),
      ); */

    if (data.hours == null) {
      return SliverToBoxAdapter(
        child: Container(
          child: Center(
            child: Text(
              AppStrings.noData,
              style: TextStyle(
                  fontSize: 48.w,
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
            ),
          ),
        ),
      );
    }
    WeatherDataDay sunday = WeatherDataDay();
    sunday.init();

    WeatherDataDay monday = WeatherDataDay();
    monday.init();

    WeatherDataDay tuesday = WeatherDataDay();
    tuesday.init();

    WeatherDataDay wednessday = WeatherDataDay();
    wednessday.init();

    WeatherDataDay thrusday = WeatherDataDay();
    thrusday.init();

    WeatherDataDay friday = WeatherDataDay();
    friday.init();

    WeatherDataDay saturday = WeatherDataDay();
    saturday.init();

    // int hourCount = 0;

    List<WeatherDataDay> dataPointList = data.hours.map((f) {
      // 2019-09-16T00:00:00+00:00
      var date1 = DateTime.parse(f.time);
      // DateTime xAxisValue = date1; //date1.hour.toDouble();
      // double pointValue = f.airTemperatureList.attributeDataList[0].value;
      int weekDay = date1.weekday;
      // String nameOfDay = DateFormat('EEEE').format(date1);
      // debugPrint('name of day - ${date1.weekday}- $nameOfDay');
      // if (hourCount != 0)

      switch (weekDay) {
        case 1:
          // temperature

          monday.temperatureMax = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      monday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : monday.temperatureMax;
          // : _degreeToFernehite(
          //             f.airTemperatureList.attributeDataList[0].value) >
          //         monday.temperatureMax
          //     ? _degreeToFernehite(
          //         f.airTemperatureList.attributeDataList[0].value)
          //     : monday.temperatureMax;

          monday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      monday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : monday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             monday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : monday.temperatureMin);

          // humidity
          monday.humidityMax =
              f.humidityList.attributeDataList[0].value > monday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : monday.humidityMax;
          monday.humidityMin =
              f.humidityList.attributeDataList[0].value < monday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : monday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          monday.windSpeedMax =
              f.windSpeedList.attributeDataList[0].value > monday.windSpeedMax
                  ? f.windSpeedList.attributeDataList[0].value
                  : monday.windSpeedMax;
          monday.windSpeedMin =
              f.windSpeedList.attributeDataList[0].value < monday.windSpeedMin
                  ? f.windSpeedList.attributeDataList[0].value
                  : monday.windSpeedMin;

          // wind gusts
          monday.windGustsMax =
              f.windGustList.attributeDataList[0].value > monday.windGustsMax
                  ? f.windGustList.attributeDataList[0].value
                  : monday.windGustsMax;
          monday.windGustsMin =
              f.windGustList.attributeDataList[0].value < monday.windGustsMin
                  ? f.windGustList.attributeDataList[0].value
                  : monday.windGustsMin;

          // windDirection
          monday.windDirMax =
              f.windDirectionList.attributeDataList[0].value > monday.windDirMax
                  ? f.windDirectionList.attributeDataList[0].value
                  : monday.windDirMax;
          monday.windDirMin =
              f.windDirectionList.attributeDataList[0].value < monday.windDirMin
                  ? f.windDirectionList.attributeDataList[0].value
                  : monday.windDirMin;

          // BPU
          monday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      monday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : monday.baromatricPressureMax;
          monday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      monday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : monday.baromatricPressureMin;

          // Precipitation
          monday.precipMMMax = f.precipitationList.attributeDataList[0].value >
                  monday.precipMMMax
              ? f.precipitationList.attributeDataList[0].value
              : monday.precipMMMax;
          monday.precipMMMin = f.precipitationList.attributeDataList[0].value <
                  monday.precipMMMin
              ? f.precipitationList.attributeDataList[0].value
              : monday.precipMMMin;

          monday.weatherType = '113';
          monday.name = 'Monday';
          break;
        case 2:
          // temperature
          tuesday.temperatureMax = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      tuesday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : tuesday.temperatureMax;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value >
          //             tuesday.temperatureMax
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : tuesday.temperatureMax);

          tuesday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      tuesday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : tuesday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             tuesday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : tuesday.temperatureMin);

          // humidity
          tuesday.humidityMax =
              f.humidityList.attributeDataList[0].value > tuesday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : tuesday.humidityMax;
          tuesday.humidityMin =
              f.humidityList.attributeDataList[0].value < tuesday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : tuesday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          tuesday.windSpeedMax =
              f.windSpeedList.attributeDataList[0].value > tuesday.windSpeedMax
                  ? f.windSpeedList.attributeDataList[0].value
                  : tuesday.windSpeedMax;
          tuesday.windSpeedMin =
              f.windSpeedList.attributeDataList[0].value < tuesday.windSpeedMin
                  ? f.windSpeedList.attributeDataList[0].value
                  : tuesday.windSpeedMin;

          // wind gusts
          tuesday.windGustsMax =
              f.windGustList.attributeDataList[0].value > tuesday.windGustsMax
                  ? f.windGustList.attributeDataList[0].value
                  : tuesday.windGustsMax;
          tuesday.windGustsMin =
              f.windGustList.attributeDataList[0].value < tuesday.windGustsMin
                  ? f.windGustList.attributeDataList[0].value
                  : tuesday.windGustsMin;

          // windDirection
          tuesday.windDirMax = f.windDirectionList.attributeDataList[0].value >
                  tuesday.windDirMax
              ? f.windDirectionList.attributeDataList[0].value
              : tuesday.windDirMax;
          tuesday.windDirMin = f.windDirectionList.attributeDataList[0].value <
                  tuesday.windDirMin
              ? f.windDirectionList.attributeDataList[0].value
              : tuesday.windDirMin;

          // BPU
          tuesday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      tuesday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : tuesday.baromatricPressureMax;
          tuesday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      tuesday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : tuesday.baromatricPressureMin;

          // Precipitation
          tuesday.precipMMMax = f.precipitationList.attributeDataList[0].value >
                  tuesday.precipMMMax
              ? f.precipitationList.attributeDataList[0].value
              : tuesday.precipMMMax;
          tuesday.precipMMMin = f.precipitationList.attributeDataList[0].value <
                  tuesday.precipMMMin
              ? f.precipitationList.attributeDataList[0].value
              : tuesday.precipMMMin;

          tuesday.weatherType = '113';
          tuesday.name = 'TUESDAY';
          break;
        case 3:
          // temperature
          wednessday.temperatureMax = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      wednessday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : wednessday.temperatureMax;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value >
          //             wednessday.temperatureMax
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : wednessday.temperatureMax);

          wednessday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      wednessday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : wednessday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             wednessday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : wednessday.temperatureMin);

          // humidity
          wednessday.humidityMax =
              f.humidityList.attributeDataList[0].value > wednessday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : wednessday.humidityMax;
          wednessday.humidityMin =
              f.humidityList.attributeDataList[0].value < wednessday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : wednessday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          wednessday.windSpeedMax = f.windSpeedList.attributeDataList[0].value >
                  wednessday.windSpeedMax
              ? f.windSpeedList.attributeDataList[0].value
              : wednessday.windSpeedMax;
          wednessday.windSpeedMin = f.windSpeedList.attributeDataList[0].value <
                  wednessday.windSpeedMin
              ? f.windSpeedList.attributeDataList[0].value
              : wednessday.windSpeedMin;

          // wind gusts
          wednessday.windGustsMax = f.windGustList.attributeDataList[0].value >
                  wednessday.windGustsMax
              ? f.windGustList.attributeDataList[0].value
              : wednessday.windGustsMax;
          wednessday.windGustsMin = f.windGustList.attributeDataList[0].value <
                  wednessday.windGustsMin
              ? f.windGustList.attributeDataList[0].value
              : wednessday.windGustsMin;

          // windDirection
          wednessday.windDirMax =
              f.windDirectionList.attributeDataList[0].value >
                      wednessday.windDirMax
                  ? f.windDirectionList.attributeDataList[0].value
                  : wednessday.windDirMax;
          wednessday.windDirMin =
              f.windDirectionList.attributeDataList[0].value <
                      wednessday.windDirMin
                  ? f.windDirectionList.attributeDataList[0].value
                  : wednessday.windDirMin;

          // BPU
          wednessday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      wednessday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : wednessday.baromatricPressureMax;
          wednessday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      wednessday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : wednessday.baromatricPressureMin;

          // Precipitation
          wednessday.precipMMMax =
              f.precipitationList.attributeDataList[0].value >
                      wednessday.precipMMMax
                  ? f.precipitationList.attributeDataList[0].value
                  : wednessday.precipMMMax;
          wednessday.precipMMMin =
              f.precipitationList.attributeDataList[0].value <
                      wednessday.precipMMMin
                  ? f.precipitationList.attributeDataList[0].value
                  : wednessday.precipMMMin;

          wednessday.weatherType = '113';
          wednessday.name = 'WEDNESSDAY';
          break;
        case 4:
          // temperature
          thrusday.temperatureMax = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      thrusday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : thrusday.temperatureMax;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value >
          //             thrusday.temperatureMax
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : thrusday.temperatureMax);

          thrusday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      thrusday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : thrusday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             thrusday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : thrusday.temperatureMin);

          // humidity
          thrusday.humidityMax =
              f.humidityList.attributeDataList[0].value > thrusday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : thrusday.humidityMax;
          thrusday.humidityMin =
              f.humidityList.attributeDataList[0].value < thrusday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : thrusday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          thrusday.windSpeedMax =
              f.windSpeedList.attributeDataList[0].value > thrusday.windSpeedMax
                  ? f.windSpeedList.attributeDataList[0].value
                  : thrusday.windSpeedMax;
          thrusday.windSpeedMin =
              f.windSpeedList.attributeDataList[0].value < thrusday.windSpeedMin
                  ? f.windSpeedList.attributeDataList[0].value
                  : thrusday.windSpeedMin;

          // wind gusts
          thrusday.windGustsMax =
              f.windGustList.attributeDataList[0].value > thrusday.windGustsMax
                  ? f.windGustList.attributeDataList[0].value
                  : thrusday.windGustsMax;
          thrusday.windGustsMin =
              f.windGustList.attributeDataList[0].value < thrusday.windGustsMin
                  ? f.windGustList.attributeDataList[0].value
                  : thrusday.windGustsMin;

          // windDirection
          thrusday.windDirMax = f.windDirectionList.attributeDataList[0].value >
                  thrusday.windDirMax
              ? f.windDirectionList.attributeDataList[0].value
              : thrusday.windDirMax;
          thrusday.windDirMin = f.windDirectionList.attributeDataList[0].value <
                  thrusday.windDirMin
              ? f.windDirectionList.attributeDataList[0].value
              : thrusday.windDirMin;

          // BPU
          thrusday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      thrusday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : thrusday.baromatricPressureMax;
          thrusday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      thrusday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : thrusday.baromatricPressureMin;

          // Precipitation
          thrusday.precipMMMax =
              f.precipitationList.attributeDataList[0].value >
                      thrusday.precipMMMax
                  ? f.precipitationList.attributeDataList[0].value
                  : thrusday.precipMMMax;
          thrusday.precipMMMin =
              f.precipitationList.attributeDataList[0].value <
                      thrusday.precipMMMin
                  ? f.precipitationList.attributeDataList[0].value
                  : thrusday.precipMMMin;

          thrusday.weatherType = '113';
          thrusday.name = 'THRUSDAY';
          break;
        case 5:
          // temperature
          friday.temperatureMax = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      friday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : friday.temperatureMax;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value >
          //             friday.temperatureMax
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : friday.temperatureMax);

          friday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      friday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : friday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             friday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : friday.temperatureMin);

          // humidity
          friday.humidityMax =
              f.humidityList.attributeDataList[0].value > friday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : friday.humidityMax;
          friday.humidityMin =
              f.humidityList.attributeDataList[0].value < friday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : friday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          friday.windSpeedMax =
              f.windSpeedList.attributeDataList[0].value > friday.windSpeedMax
                  ? f.windSpeedList.attributeDataList[0].value
                  : friday.windSpeedMax;
          friday.windSpeedMin =
              f.windSpeedList.attributeDataList[0].value < friday.windSpeedMin
                  ? f.windSpeedList.attributeDataList[0].value
                  : friday.windSpeedMin;

          // wind gusts
          friday.windGustsMax =
              f.windGustList.attributeDataList[0].value > friday.windGustsMax
                  ? f.windGustList.attributeDataList[0].value
                  : friday.windGustsMax;
          friday.windGustsMin =
              f.windGustList.attributeDataList[0].value < friday.windGustsMin
                  ? f.windGustList.attributeDataList[0].value
                  : friday.windGustsMin;

          // windDirection
          friday.windDirMax =
              f.windDirectionList.attributeDataList[0].value > friday.windDirMax
                  ? f.windDirectionList.attributeDataList[0].value
                  : friday.windDirMax;
          friday.windDirMin =
              f.windDirectionList.attributeDataList[0].value < friday.windDirMin
                  ? f.windDirectionList.attributeDataList[0].value
                  : friday.windDirMin;

          // BPU
          friday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      friday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : friday.baromatricPressureMax;
          friday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      friday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : friday.baromatricPressureMin;

          // Precipitation
          friday.precipMMMax = f.precipitationList.attributeDataList[0].value >
                  friday.precipMMMax
              ? f.precipitationList.attributeDataList[0].value
              : friday.precipMMMax;
          friday.precipMMMin = f.precipitationList.attributeDataList[0].value <
                  friday.precipMMMin
              ? f.precipitationList.attributeDataList[0].value
              : friday.precipMMMin;

          friday.weatherType = '113';
          friday.name = 'FRIDAY';
          break;
        case 6:
          // temperature
          saturday.temperatureMax = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      saturday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : saturday.temperatureMax;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value >
          //             saturday.temperatureMax
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : saturday.temperatureMax);

          saturday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      saturday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : saturday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             saturday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : saturday.temperatureMin);

          // humidity
          saturday.humidityMax =
              f.humidityList.attributeDataList[0].value > saturday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : saturday.humidityMax;
          saturday.humidityMin =
              f.humidityList.attributeDataList[0].value < saturday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : saturday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          saturday.windSpeedMax =
              f.windSpeedList.attributeDataList[0].value > saturday.windSpeedMax
                  ? f.windSpeedList.attributeDataList[0].value
                  : saturday.windSpeedMax;
          saturday.windSpeedMin =
              f.windSpeedList.attributeDataList[0].value < saturday.windSpeedMin
                  ? f.windSpeedList.attributeDataList[0].value
                  : saturday.windSpeedMin;

          // wind gusts
          saturday.windGustsMax =
              f.windGustList.attributeDataList[0].value > saturday.windGustsMax
                  ? f.windGustList.attributeDataList[0].value
                  : saturday.windGustsMax;
          saturday.windGustsMin =
              f.windGustList.attributeDataList[0].value < saturday.windGustsMin
                  ? f.windGustList.attributeDataList[0].value
                  : saturday.windGustsMin;

          // windDirection
          saturday.windDirMax = f.windDirectionList.attributeDataList[0].value >
                  saturday.windDirMax
              ? f.windDirectionList.attributeDataList[0].value
              : saturday.windDirMax;
          saturday.windDirMin = f.windDirectionList.attributeDataList[0].value <
                  saturday.windDirMin
              ? f.windDirectionList.attributeDataList[0].value
              : saturday.windDirMin;

          // BPU
          saturday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      saturday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : saturday.baromatricPressureMax;
          saturday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      saturday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : saturday.baromatricPressureMin;

          // Precipitation
          saturday.precipMMMax =
              f.precipitationList.attributeDataList[0].value >
                      saturday.precipMMMax
                  ? f.precipitationList.attributeDataList[0].value
                  : saturday.precipMMMax;
          saturday.precipMMMin =
              f.precipitationList.attributeDataList[0].value <
                      saturday.precipMMMin
                  ? f.precipitationList.attributeDataList[0].value
                  : saturday.precipMMMin;

          saturday.weatherType = '113';
          saturday.name = 'SATURDAY';
          break;
        case 7:
          // temperature
          sunday.temperatureMax = //tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value >
                      sunday.temperatureMax
                  ? f.airTemperatureList.attributeDataList[0].value
                  : sunday.temperatureMax;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value >
          //             sunday.temperatureMax
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : sunday.temperatureMax);

          sunday.temperatureMin = // tempInCelsius ?
              f.airTemperatureList.attributeDataList[0].value <
                      sunday.temperatureMin
                  ? f.airTemperatureList.attributeDataList[0].value
                  : sunday.temperatureMin;
          // : _degreeToFernehite(
          //     f.airTemperatureList.attributeDataList[0].value <
          //             sunday.temperatureMin
          //         ? f.airTemperatureList.attributeDataList[0].value
          //         : sunday.temperatureMin);

          // humidity
          sunday.humidityMax =
              f.humidityList.attributeDataList[0].value > sunday.humidityMax
                  ? f.humidityList.attributeDataList[0].value
                  : sunday.humidityMax;
          sunday.humidityMin =
              f.humidityList.attributeDataList[0].value < sunday.humidityMin
                  ? f.humidityList.attributeDataList[0].value
                  : sunday.humidityMin;

          // // solarRad
          // monday.solarRadMax = _findMaxSolarRad(f.hours);
          // monday.solarRadMin = _findMinSolarRad(f.hours);

          // // uvRad
          // monday.uvRadMax = _findMaxUvRad(f.hours);
          // monday.uvRadMin = _findMinUvRad(f.hours);

          // windspeed
          sunday.windSpeedMax =
              f.windSpeedList.attributeDataList[0].value > sunday.windSpeedMax
                  ? f.windSpeedList.attributeDataList[0].value
                  : sunday.windSpeedMax;
          sunday.windSpeedMin =
              f.windSpeedList.attributeDataList[0].value < sunday.windSpeedMin
                  ? f.windSpeedList.attributeDataList[0].value
                  : sunday.windSpeedMin;

          // wind gusts
          sunday.windGustsMax =
              f.windGustList.attributeDataList[0].value > sunday.windGustsMax
                  ? f.windGustList.attributeDataList[0].value
                  : sunday.windGustsMax;
          sunday.windGustsMin =
              f.windGustList.attributeDataList[0].value < sunday.windGustsMin
                  ? f.windGustList.attributeDataList[0].value
                  : sunday.windGustsMin;

          // windDirection
          sunday.windDirMax =
              f.windDirectionList.attributeDataList[0].value > sunday.windDirMax
                  ? f.windDirectionList.attributeDataList[0].value
                  : sunday.windDirMax;
          sunday.windDirMin =
              f.windDirectionList.attributeDataList[0].value < sunday.windDirMin
                  ? f.windDirectionList.attributeDataList[0].value
                  : sunday.windDirMin;

          // BPU
          sunday.baromatricPressureMax =
              f.barometricPressureList.attributeDataList[0].value >
                      sunday.baromatricPressureMax
                  ? f.barometricPressureList.attributeDataList[0].value
                  : sunday.baromatricPressureMax;
          sunday.baromatricPressureMin =
              f.barometricPressureList.attributeDataList[0].value <
                      sunday.baromatricPressureMin
                  ? f.barometricPressureList.attributeDataList[0].value
                  : sunday.baromatricPressureMin;

          // Precipitation
          sunday.precipMMMax = f.precipitationList.attributeDataList[0].value >
                  sunday.precipMMMax
              ? f.precipitationList.attributeDataList[0].value
              : sunday.precipMMMax;
          sunday.precipMMMin = f.precipitationList.attributeDataList[0].value <
                  sunday.precipMMMin
              ? f.precipitationList.attributeDataList[0].value
              : sunday.precipMMMin;

          sunday.weatherType = '113';
          sunday.name = 'SUNDAY';
          break;
        default:
          break;
      }

      if (date1.difference(DateTime.now()) < Duration(minutes: 30)) {}

      // hourCount++;
      return WeatherDataDay(); //DataPoint<DateTime>(value: pointValue, xAxis: xAxisValue);
    }).toList();

    if (tempInCelsius) {
      debugPrint('-------------------------temp in celcius-------------------');
    } else {
      saturday.temperatureMax = _degreeToFernehite(saturday.temperatureMax);
      saturday.temperatureMin = _degreeToFernehite(saturday.temperatureMin);

      sunday.temperatureMax = _degreeToFernehite(sunday.temperatureMax);
      sunday.temperatureMin = _degreeToFernehite(sunday.temperatureMin);

      monday.temperatureMax = _degreeToFernehite(monday.temperatureMax);
      monday.temperatureMin = _degreeToFernehite(monday.temperatureMin);

      tuesday.temperatureMax = _degreeToFernehite(tuesday.temperatureMax);
      tuesday.temperatureMin = _degreeToFernehite(tuesday.temperatureMin);

      wednessday.temperatureMax = _degreeToFernehite(wednessday.temperatureMax);
      wednessday.temperatureMin = _degreeToFernehite(wednessday.temperatureMin);

      thrusday.temperatureMax = _degreeToFernehite(thrusday.temperatureMax);
      thrusday.temperatureMin = _degreeToFernehite(thrusday.temperatureMin);

      friday.temperatureMax = _degreeToFernehite(friday.temperatureMax);
      friday.temperatureMin = _degreeToFernehite(friday.temperatureMin);
    }

    var util = ScreenUtil();

    return SliverPadding(
      padding:
          EdgeInsets.symmetric(vertical: util.setHeight(48), horizontal: 8.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Next 7 Days',
                  style: TextStyle(
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                      fontWeight: FontWeight.normal,
                      fontSize: 17)),
              CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(util.setWidth(3)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        tempInCelsius = !tempInCelsius;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                          tempInCelsius ? ' C${SymbolConstant.DEGREE}' : ' F ',
                          style: TextStyle(
                              color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                              fontWeight: FontWeight.normal,
                              fontSize: 17)),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: util.setHeight(24),
          ),
          WeatherByDayInfoList(sunday),
          _horizontalLine(),
          WeatherByDayInfoList(monday),
          _horizontalLine(),
          WeatherByDayInfoList(tuesday),
          _horizontalLine(),
          WeatherByDayInfoList(wednessday),
          _horizontalLine(),
          WeatherByDayInfoList(thrusday),
          _horizontalLine(),
          WeatherByDayInfoList(friday),
          _horizontalLine(),
          WeatherByDayInfoList(saturday),
        ]),
      ),
    );
  }

  Widget _weatherDataFuture({String title, String iconPath}) {
    return FutureBuilder<StormGlassData>(
        future: _futureWOWWeatherData,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _bezierChart(
                  snapshot.data, title, iconPath) //movieGrid(snapshot.data)
              : Container();
          //  Center(child: CircularProgressIndicator());
        });
  }

  Widget _bezierChart(StormGlassData data, String title, String iconPath) {
    if (data.hours == null) {
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: 48.w, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );
    }
    List<double> hourList = [];
    List<DataPoint<double>> dataPointList = [];
    double _selectedValue = 0.0;

    for (var i = 1; i < 25; i++) {
      HourData f = data.hours[i];
      var date1 = DateTime.parse(f.time);
      double xAxisValue = date1.hour.toDouble();
      double pointValue =
          f.airTemperatureList.attributeDataList[0].value.roundToDouble();
      hourList.add(xAxisValue);
      dataPointList
          .add(DataPoint<double>(value: pointValue, xAxis: xAxisValue));
      if (date1.difference(DateTime.now()) < Duration(minutes: 30)) {
        _selectedValue = pointValue;
      }
    }

    hourList.sort();

    // debugPrint('hours list ---- $hourList  ---data pint list   $dataPointList---  _selectedValue -- $_selectedValue');

    return Center(
      child: Container(
        height: ScreenUtil().setHeight(512),
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          bezierChartScale: BezierChartScale.CUSTOM,
          // fromDate: fromDate,
          // toDate: toDate,
          // selectedDate: selectedDate,
          selectedValue: _selectedValue,
          xAxisCustomValues: hourList,

          series: [
            BezierLine(
              label: '${SymbolConstant.DEGREE}C',
              lineColor: ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
              lineStrokeWidth: 0,
              data: dataPointList,
            ),
          ],
          config: BezierChartConfig(
            startYAxisFromNonZeroValue: true,
            verticalIndicatorColor:
                ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
            showVerticalIndicator: true,
            contentWidth: MediaQuery.of(context).size.width * 5,
            showDataPoints: true,
            displayLinesXAxis: true,
            bubbleIndicatorValueStyle: TextStyle(
                color: ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                fontSize: ScreenUtil().setSp(72)),
            xAxisTextStyle: TextStyle(
              color: ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
            ),
            xLinesColor: ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
            belowBarData: BelowCurveData(
                show: true,
                colors: [
                  ColorConstants.TEMP_BY_HOUR_START,
                  ColorConstants.TEMP_BY_HOUR_END,
                ],
                gradientColorStops: [0.0, 1.0],
                gradientFrom: Offset(0, 0),
                gradientTo: Offset(0, 1),
                belowSpotsLine: BelowPointLine(
                  show: true,
                  flLineStyle: const CustomLine(
                    color:
                        ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                    strokeWidth: 1,
                  ),
                )),
          ),
        ),
      ),
    );
  }

  goBack() {
    // Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Navigator.of(context).pop();
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     LandingScreen.routeName, (Route<dynamic> route) => false);
  }

  double _degreeToFernehite(double degree) {
    // (0°C × 9/5) + 32 = 32°F

    if (degree == 0.0) return 0.0;

    double fernehite = (degree * 9 / 5) + 32;
    // debugPrint(
    // '------------    -- $degree--------------- fernehite data ----------   $fernehite');
    return fernehite.roundToDouble();
  }
}
