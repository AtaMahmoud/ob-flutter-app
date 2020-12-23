import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/bloc/source_priority_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/models/user.dart';
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
  Future<StormGlassData> _futureWeatherData;
  Future<StormGlassData> _futuremissingData;
  Future<UvIndexData> _futureUvIndexData;

  SourceListBloc _bloc = SourceListBloc();

  String currentlySelectedSource;

  bool useMobileLayout;

  SourcePriorityBloc _sourcePriorityBloc = new SourcePriorityBloc(
      ApplicationStatics.selectedWeatherProvider ??
          ListHelper.getSourceList()[0]);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      _futureWeatherData =
          Provider.of<StormGlassDataProvider>(context).fetchWeatherData();

      _futuremissingData = Provider.of<LocalWeatherDataProvider>(context)
          .fetchDeviceObservationData();

      if (_user.selectedWeatherSource != null &&
          _user.selectedWeatherSource.compareTo('local') == 0) {
        currentlySelectedSource = ListHelper.getSourceList()[1];
      } else {
        currentlySelectedSource = ListHelper.getSourceList()[0];
      }

      ApplicationStatics.selectedWeatherProvider = currentlySelectedSource;

      _sourcePriorityBloc.topProprityChanged(currentlySelectedSource);
      _sourcePriorityBloc.topProprity.listen((event) {
        if (event.compareTo(ListHelper.getSourceList()[1]) == 0) {
          _futureWeatherData = Provider.of<LocalWeatherDataProvider>(context)
              .fetchDeviceObservationData();
          currentlySelectedSource = ListHelper.getSourceList()[1];
        } else if (event.compareTo(ListHelper.getSourceList()[0]) == 0) {
          _futureWeatherData =
              Provider.of<StormGlassDataProvider>(context).fetchWeatherData();
          _futuremissingData = Provider.of<LocalWeatherDataProvider>(context)
              .fetchDeviceObservationData();
          currentlySelectedSource = ListHelper.getSourceList()[0];
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
    _userProvider = Provider.of<UserProvider>(context);
    _user = _userProvider.authenticatedUser;

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;
    return _mainContent();
  }

  _mainContent() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: ColorConstants.BCKG_COLOR_START),
          child: CustomScrollView(
            slivers: <Widget>[
              _topSpace(),
              _itemGrid(),
            ],
          ),
        ),
        _topBar(),
        _sourceSelectionPositioned()
      ],
    );
  }

  SliverPadding _itemGrid() {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: 256.h,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            _weatherItemsWidgetFuture(),
          ],
        ),
      ),
    );
  }

  AppbarWeather _topBar() {
    return AppbarWeather(
      ScreenTitle.WEATHER,
      scaffoldKey: widget.scaffoldKey,
      futureWOWWeatherData: _futureWeatherData,
    );
  }

  _topSpace() {
    return UIHelper.getTopEmptyContainer(
        useMobileLayout
            ? MediaQuery.of(context).size.height * 0.55
            : MediaQuery.of(context).size.height * 0.75,
        true);
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
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _weatherItemContainer(snapshot.data)
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
                fontSize: 48.w, color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
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

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      if (date1.difference(DateTime.now()) < Duration(minutes: 59)) {
        _solarPower = f.solarRadiation != null
            ? f.solarRadiation.attributeDataList[0].value
            : 900;
        _uvIndex =
            f.unIndex != null ? f.unIndex.attributeDataList[0].value : 0.5;
        _windSpeed = f.windSpeedList.attributeDataList[0].value;
        _windGusts = f.windGustList.attributeDataList[0].value;
        _windDirection = f.windDirectionList.attributeDataList[0].value;
        _biometricPressure =
            f.barometricPressureList.attributeDataList[0].value;
      }
    }

    return Container(
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
                  currentlySelectedSource
                              .compareTo(ListHelper.getSourceList()[1]) ==
                          0
                      ? gridRowItemSVG(
                          iconImagePath: ImagePaths.svgSolarRadiation,
                          itemName: AppStrings.solarRadiation,
                          value: '$_solarPower W/M2',
                          onTap: () {
                            if (currentlySelectedSource
                                    .compareTo(ListHelper.getSourceList()[1]) ==
                                0) {
                              PopUpHelpers.showChartPopup(
                                  context,
                                  _weatherDataWidgetFuture(
                                      title: AppStrings.solarRadiation,
                                      iconPath: ImagePaths.svgSolarRadiation));
                            }
                          })
                      : FutureBuilder<StormGlassData>(
                          future: _futuremissingData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              for (var f in snapshot.data.hours) {
                                var date1 = DateTime.parse(f.time);

                                if (date1.difference(DateTime.now()) <
                                    Duration(minutes: 59)) {
                                  _solarPower = f.solarRadiation != null
                                      ? f.solarRadiation.attributeDataList[0]
                                          .value
                                      : 90;
                                }
                              }
                            }
                            return snapshot.hasData
                                ? gridRowItemSVG(
                                    iconImagePath: ImagePaths.svgSolarRadiation,
                                    itemName: AppStrings.solarRadiation,
                                    value: '$_solarPower W/M2',
                                    onTap: () {
                                      PopUpHelpers.showChartPopup(
                                          context,
                                          _weatherMissingDataWidgetFuture(
                                              title: AppStrings.solarRadiation,
                                              iconPath: ImagePaths
                                                  .svgSolarRadiation));
                                    }) //movieGrid(snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          }),
                  currentlySelectedSource
                              .compareTo(ListHelper.getSourceList()[1]) ==
                          0
                      ? gridRowItemSVG(
                          iconImagePath: ImagePaths.svguvRadiation,
                          itemName: AppStrings.uvRadiation,
                          value: '$_uvIndex Nm',
                          onTap: () {
                            if (currentlySelectedSource
                                    .compareTo(ListHelper.getSourceList()[1]) ==
                                0) {
                              PopUpHelpers.showChartPopup(
                                  context,
                                  _weatherDataWidgetFuture(
                                      title: AppStrings.uvRadiation,
                                      iconPath: ImagePaths.svguvRadiation));
                            }
                          })
                      : FutureBuilder<StormGlassData>(
                          future: _futuremissingData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              for (var f in snapshot.data.hours) {
                                var date1 = DateTime.parse(f.time);

                                if (date1.difference(DateTime.now()) <
                                    Duration(minutes: 59)) {
                                  _uvIndex = f.unIndex != null
                                      ? f.unIndex.attributeDataList[0].value
                                      : 0.05;
                                }
                              }
                            }
                            return snapshot.hasData
                                ? gridRowItemSVG(
                                    iconImagePath: ImagePaths.svguvRadiation,
                                    itemName: AppStrings.uvRadiation,
                                    value: '$_uvIndex Nm',
                                    onTap: () {
                                      PopUpHelpers.showChartPopup(
                                          context,
                                          _weatherMissingDataWidgetFuture(
                                              title: AppStrings.uvRadiation,
                                              iconPath:
                                                  ImagePaths.svguvRadiation));
                                    }) //movieGrid(snapshot.data)
                                : Center(child: CircularProgressIndicator());
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<StormGlassData>(
                future: _futureWeatherData,
                builder: (context, snapshot) {
                  return snapshot.hasData
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

  Widget _weatherMissingDataWidgetFuture({String title, String iconPath}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<StormGlassData>(
                future: _futuremissingData,
                builder: (context, snapshot) {
                  return snapshot.hasData
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<UvIndexData>(
                future: _futureUvIndexData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.hasData
                        ? _beizerChartUvIndex(
                            data: snapshot.data,
                            title: title,
                            iconPath: iconPath,
                          )
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PopUpHelpers.popUpTitle(
                context, title, iconPath, '$selectedValue Meters'),
            Container(
              height: 380.h,
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
                    fontSize: 72.sp,
                  ),
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
