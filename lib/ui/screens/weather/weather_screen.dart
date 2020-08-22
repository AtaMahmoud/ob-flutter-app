import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/bloc/source_priority_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/weather_flow_data.dart';
import 'package:ocean_builder/core/models/weather_flow_device_observation.dart';
import 'package:ocean_builder/core/providers/local_weather_flow_data_provider.dart';
import 'package:ocean_builder/core/providers/storm_glass_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/shared/grid_menu_helper.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/shared_chart.dart';
import 'package:ocean_builder/ui/widgets/source_priority_changer_modal.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:ocean_builder/ui/widgets/weather_appbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  static const routeName = '/weather';

  final GlobalKey<ScaffoldState> scaffoldKey;

  const WeatherScreen({this.scaffoldKey});
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  UserProvider _userProvider;
  User _user;
  ScreenUtil _util = ScreenUtil();
  Future<StormGlassData> _futureWeatherData;
  // Future<WorldWeatherOnlineData> _futureWOWWeatherData;
  Future<WeatherFlowData> _futureWeatherStationData;
  Future<WeatherFlowDeviceObservationData>
      _futureWeatherFlowDeviceObservationData;
  Future<StormGlassData> _futureWOWWeatherDataSummary;
  Future<UvIndexData> _futureUvIndexData;

  SourceListBloc _bloc = SourceListBloc();

  String currentlySelectedSource;

  bool useMobileLayout;

  SourcePriorityBloc _sourcePriorityBloc = SourcePriorityBloc();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      _futureWOWWeatherDataSummary =
          Provider.of<StormGlassDataProvider>(context).fetchWeatherData();

      // _futureWOWWeatherData = Provider.of<WOWDataProvider>(context).fetchWeatherData();

      // _futureWeatherStationData = Provider.of<LocalWeatherDataProvider>(context).fetchStationObservationData();

      _futureWeatherData =
          Provider.of<StormGlassDataProvider>(context).fetchWeatherData();

      // _futureUvIndexData =
      //     Provider.of<StormGlassDataProvider>(context).fetchUvIndexData();

      currentlySelectedSource = ListHelper.getSourceList()[0];
      // _bloc.weatherSourceController.listen((onData) {
      //   debugPrint('------------- selected source ------ $onData');
      // });
      _sourcePriorityBloc.topProprity.listen((event) {
        if (event.compareTo('local') == 0) {
          debugPrint('------------- selected source ------ $event');
          _futureWeatherData = Provider.of<LocalWeatherDataProvider>(context)
              .fetchDeviceObservationData();
        } else if (event.compareTo('external') == 0) {
          debugPrint('------------- selected source ------ $event');
          _futureWeatherData =
              Provider.of<StormGlassDataProvider>(context).fetchWeatherData();
        }
      });
    });
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;

    // UIHelper.setStatusBarColor(color:ColorConstants.CONTROL_BKG);

    return _mainContent(); //_stackWithDrawerandBottomBar(); //customDrawer(_innerDrawerKey, _mainContent());
  }

  _mainContent() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: ColorConstants.BCKG_COLOR_START),
          child: CustomScrollView(
            slivers: <Widget>[
              UIHelper.getTopEmptyContainer(
                  useMobileLayout
                      ? MediaQuery.of(context).size.height * 0.55
                      : MediaQuery.of(context).size.height * 0.75,
                  true),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: _util.setHeight(256),
                ), //EdgeInsets.symmetric(vertical: util.setHeight(48)),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // _weatherItemContainer(),
                      _weatherItemsWidgetFuture(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppbarWeather(
          ScreenTitle.WEATHER,
          scaffoldKey: widget.scaffoldKey,
          futureWOWWeatherData: _futureWOWWeatherDataSummary,
        ),
        _sourceSelectionPositioned()
      ],
    );
  }

  _sourceSelectionPositioned() {
    return Positioned(
        top: ScreenUtil.statusBarHeight + 8.h,
        right: 32.h,
        child:
            UIHelper.sourceSelectorButtons(_sourcePriorityBloc.topProprity, () {
          PopUpHelpers.showPopup(
              context,
              SourcePrioritySelectorModal(_sourcePriorityBloc),
              'WEATHER SOURCE');
        }));
  }

  Widget _weatherItemsWidgetFuture() {
    return FutureBuilder<StormGlassData>(
        future: _futureWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _weatherItemContainer(snapshot.data) //movieGrid(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  _weatherItemContainer(StormGlassData data) {
    if (data == null) {
      return Container(
        child: Center(
          child: Text(
            AppStrings.noData,
            style: TextStyle(
                fontSize: ScreenUtil().setWidth(48),
                color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
          ),
        ),
      );
    }

    double _solarPower = 900,
        _uvIndex = 0.5,
        _windSpeed,
        _windGusts,
        _windDirection,
        _biometricPressure;

    // for (var f in data.data.weathers) {
    //   var date1 = DateTime.parse(f.date);

    //   var dDate = DateFormat('yMd').format(date1);
    //   var currentDate = DateFormat('yMd').format(DateTime.now());
    //   int currentHour = DateTime.now().hour;

    //   if (dDate.compareTo(currentDate) == 0) {
    //     _uvIndex = f.hours[currentHour].uvIndex;
    //     _windSpeed = f.hours[currentHour].windspeedKmph;
    //     _windGusts = f.hours[currentHour].windGustKmph;
    //     _windDirection = f.hours[currentHour].winddirection;
    //     _biometricPressure = f.hours[currentHour].pressureInches;
    //   }

    // }

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      if (date1.difference(DateTime.now()) < Duration(minutes: 59)) {
        _windSpeed = f.windSpeedList.attributeDataList[0].value;
        _windGusts = f.windGustList.attributeDataList[0].value;
        _windDirection = f.windDirectionList.attributeDataList[0].value;
        _biometricPressure =
            f.barometricPressureList.attributeDataList[0].value;
      }
    }

    return Container(
      // decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),

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
                      iconImagePath: ImagePaths.svgSolarRadiation,
                      itemName: AppStrings.solarRadiation,
                      value: '$_solarPower W/M2',
                      onTap: () {}),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svguvRadiation,
                      itemName: AppStrings.uvRadiation,
                      value: '$_uvIndex Nm',
                      onTap: () {
                        // PopUpHelpers.showChartPopup(
                        //     context,
                        //     _weatherDataWidgetFuture(
                        //         title: AppStrings.uvRadiation,
                        //         iconPath: ImagePaths.svguvRadiation));
                        // PopUpHelpers.showChartPopup(
                        //     context,
                        //     _uvRadiationDataWidgetFuture(
                        //         title: AppStrings.tides,
                        //         iconPath: ImagePaths.icTides));
                      }),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgWindSpeed,
                      itemName: AppStrings.windSpeed,
                      value: '$_windSpeed Km/H',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _weatherDataWidgetFuture(
                                title: AppStrings.windSpeed,
                                iconPath: ImagePaths.svgWindSpeed));
                      }),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgWindGusts,
                      itemName: AppStrings.windGusts,
                      value: '$_windGusts Mph',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _weatherDataWidgetFuture(
                                title: AppStrings.windGusts,
                                iconPath: ImagePaths.svgWindGusts));
                      }),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgWindDirection,
                      itemName: AppStrings.windDirection,
                      value: '$_windDirection ${SymbolConstant.DEGREE}',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _weatherDataWidgetFuture(
                                title: AppStrings.windDirection,
                                iconPath: ImagePaths.svgWindDirection));
                      }),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgBarometricPresure,
                      itemName: AppStrings.barometricPressure,
                      value: '$_biometricPressure Inch',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _weatherDataWidgetFuture(
                                title: AppStrings.barometricPressure,
                                iconPath: ImagePaths.svgBarometricPresure));
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _weatherDataWidgetFuture({String title, String iconPath}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        //  height: ScreenUtil().setHeight(512),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //_popUpTitle(title, iconPath),
            FutureBuilder<StormGlassData>(
                future: _futureWeatherData,
                // initialData: stormGlassDataProvider.weatherDataToday,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    debugPrint('------ ${snapshot.data.hours.length}');
                  else
                    debugPrint('------ no data for snapshot');
                  return snapshot.hasData
                      // ? SharedChart.beizerChartWeather(
                      //     context: context,
                      //     data: snapshot.data,
                      //     title: title,
                      //     iconPath: iconPath,
                      //     bloc: _bloc
                      //     ) //movieGrid(snapshot.data)
                      ? BeizerChartPopup(
                          data: snapshot.data,
                          title: title,
                          iconPath: iconPath,
                          bloc: _bloc)
                      : Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget _uvRadiationDataWidgetFuture({String title, String iconPath}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        //  height: ScreenUtil.getInstance().setHeight(512),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // _popUpTitle(title, iconPath),
            FutureBuilder<UvIndexData>(
                future: _futureUvIndexData,
                // initialData: stormGlassDataProvider.weatherDataToday,
                builder: (context, snapshot) {
                  debugPrint('----------------${snapshot.connectionState}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.hasData
                        ? _beizerChartUvIndex(
                            data: snapshot.data,
                            title: title,
                            iconPath: iconPath,
                          ) //movieGrid(snapshot.data)
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.all(48.h),
                              child: Text('No data available'),
                            ),
                          );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _beizerChartUvIndex(
      {UvIndexData data, String title, String iconPath}) {
    int length = data.uvIndexAttributes.length;
    final fromDate = DateTime.parse(data.uvIndexAttributes[0].time);
    final toDate = DateTime.parse(data.uvIndexAttributes[length - 1].time);
    final selectedDate = DateTime.now();
    double selectedValue = 0.0;

    String indicatorValueUnit = ''; // = '${SymbolConstant.DEGREE}C';

    List<DataPoint<DateTime>> dataPointList = data.uvIndexAttributes.map((f) {
      // 2019-09-16T00:00:00+00:00
      var date1 = DateTime.parse(f.time);
      // double xAxisValue = date1.hour.toDouble();
      DateTime xAxisValue = date1;
      double pointValue = num.parse(f.uvIndexValue.value
          .toStringAsFixed(2)); //f.height;//double.parse(f.height);

      if (date1.difference(DateTime.now()) < Duration(hours: 3)) {
        selectedValue = pointValue;
      }

      return DataPoint<DateTime>(value: pointValue, xAxis: xAxisValue);
    }).toList();

    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        // color: Colors.white,
        // height: ScreenUtil.getInstance().setHeight(512),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PopUpHelpers.popUpTitle(
                context, title, iconPath, '$selectedValue Meters'),
            Container(
              height: ScreenUtil().setHeight(380),
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                bezierChartScale: BezierChartScale.HOURLY,
                fromDate: fromDate,
                toDate: toDate,
                selectedDate: selectedDate,
                series: [
                  BezierLine(
                    label: indicatorValueUnit,
                    lineColor:
                        ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                    lineStrokeWidth: 8.h,
                    data: dataPointList,
                  ),
                ],
                config: BezierChartConfig(
                  footerHeight: 128.h,
                  verticalIndicatorColor:
                      ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                  showVerticalIndicator: true,
                  contentWidth: MediaQuery.of(context).size.width * 2,
                  showDataPoints: false,
                  displayLinesXAxis: true,
                  bubbleIndicatorValueStyle: TextStyle(
                      color:
                          ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                      fontSize: ScreenUtil().setSp(72)),
                  xAxisTextStyle: TextStyle(
                    color:
                        ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                  ),
                  xLinesColor:
                      ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                  belowBarData: BelowCurveData(
                      show: false,
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
                          color: ColorConstants
                              .WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                          strokeWidth: 1,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
