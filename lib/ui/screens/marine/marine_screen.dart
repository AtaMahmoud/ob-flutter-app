import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/bloc/source_priority_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/storm_glass_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/shared/grid_menu_helper.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/shared/shared_chart.dart';
import 'package:ocean_builder/ui/widgets/marine_appbar.dart';
import 'package:ocean_builder/ui/widgets/source_priority_changer_modal.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MarineScreen extends StatefulWidget {
  static const routeName = '/marine';
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MarineScreen({this.scaffoldKey});

  @override
  _MarineScreenState createState() => _MarineScreenState();
}

class _MarineScreenState extends State<MarineScreen> {
  UserProvider _userProvider;
  User _user;
  ScreenUtil _util = ScreenUtil();

  Future<StormGlassData> _futureWeatherData;
  Future<TideData> _futureTideData;
  StormGlassDataProvider stormGlassDataProvider;

  SourceListBloc _bloc = SourceListBloc();

  String currentlySelectedSource;

  bool useMobileLayout;

  SourcePriorityBloc _sourcePriorityBloc = SourcePriorityBloc();

  @override
  void initState() {
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Future.delayed(Duration.zero).then((_) {
      _futureWeatherData =
          Provider.of<StormGlassDataProvider>(context).fetchWeatherData();
      _futureTideData =
          Provider.of<StormGlassDataProvider>(context).fetchTideData();
    });
    currentlySelectedSource = ListHelper.getSourceList()[0];
    _bloc.weatherSourceController.listen((onData) {});

    super.initState();
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
    stormGlassDataProvider = Provider.of<StormGlassDataProvider>(context);

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;
    return _mainContent();
  }

  _mainContent() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: ColorConstants.BCKG_COLOR_START),
          child: _body(),
        ),
        _topBar(),
        _sourceSelectionPositioned()
      ],
    );
  }

  CustomScrollView _body() {
    return CustomScrollView(
      slivers: <Widget>[
        _startSpace(),
        _itemsGrid(),
      ],
    );
  }

  AppbarMarine _topBar() {
    return AppbarMarine(
      ScreenTitle.MARINE,
      scaffoldKey: widget.scaffoldKey,
      futureWOWWeatherData: _futureWeatherData,
    );
  }

  SliverPadding _itemsGrid() {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: _util.setHeight(256),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            // _fathometerContainer(),
            _marineItemsWidgetFuture()
            // _marineItemContainer(),
          ],
        ),
      ),
    );
  }

  _startSpace() {
    return UIHelper.getTopEmptyContainer(
        useMobileLayout
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.7,
        false);
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
              'Lighting Screen');
        }));
  }

  _marineItemContainer(StormGlassData data) {
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

    double _waterTemperature,
        _seaLevel,
        _waveHeight,
        _significantWave,
        _visibility,
        _swellHeight,
        _swellDirection,
        _swellPeriod;

    for (var f in data.hours) {
      var date1 = DateTime.parse(f.time);

      if (date1.difference(DateTime.now()) < Duration(minutes: 59)) {
        _waterTemperature = f.waterTemperatureList.attributeDataList[0].value;
        _seaLevel = f.seaLevelList.attributeDataList[0].value;
        _waveHeight = f.waveHeightList.attributeDataList[0].value;
        _significantWave = f.significantWaveList.attributeDataList[0].value;
        _visibility = f.visiblityList.attributeDataList[0].value;
        _swellHeight = f.swellHeightList.attributeDataList[0].value;
        _swellDirection = f.swellDirectionList.attributeDataList[0].value;
        _swellPeriod = f.swellPeriodList.attributeDataList[0].value;
      }
    }

    return Container(
      // decoration: BoxDecoration(
      //   gradient: ColorConstants.BKG_GRADIENT
      //   ),
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
                      iconImagePath: ImagePaths.svgWaterTemp,
                      itemName: AppStrings.waterTemp,
                      value: '$_waterTemperature ${SymbolConstant.DEGREE}C',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.waterTemp,
                                iconPath: ImagePaths.icWaterTemp));
                      }),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgSeaLevel,
                      itemName: AppStrings.seaLevel,
                      value: '$_seaLevel Meters',
                      onTap: () {
/*                         PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.seaLevel,
                                iconPath: ImagePaths.icSeaLevel)); */
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
                      iconImagePath: ImagePaths.svgWaveHeight,
                      itemName: AppStrings.waveHeight,
                      value: '$_waveHeight Km/H',
                      onTap: () {
/*                         PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.waveHeight,
                                iconPath: ImagePaths.icWaveHeight)); */
                      }),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgSignificantWave,
                      itemName: AppStrings.significantWave,
                      value: '$_significantWave Meters',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.significantWave,
                                iconPath: ImagePaths.icSignificantWave));
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
                      iconImagePath: ImagePaths.svgVisibility,
                      itemName: AppStrings.visibility,
                      value: '$_visibility Meters',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.visibility,
                                iconPath: ImagePaths.icVisibility));
                      }),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgSwellHeight,
                      itemName: AppStrings.swellHeight,
                      value: '$_swellHeight Meters',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.swellHeight,
                                iconPath: ImagePaths.icSwellHeight));
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
                      iconImagePath: ImagePaths.svgSwellDirection,
                      itemName: AppStrings.swellDirection,
                      value: '$_swellDirection ${SymbolConstant.DEGREE}',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.swellDirection,
                                iconPath: ImagePaths.icSwellDirection));
                      }),
                  gridRowItemSVG(
                      iconImagePath: ImagePaths.svgSwellPeriod,
                      itemName: AppStrings.swellPeriod,
                      value: '$_swellPeriod Seconds',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _marineDataWidgetFuture(
                                title: AppStrings.swellPeriod,
                                iconPath: ImagePaths.icSwellPeriod));
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
                      iconImagePath: ImagePaths.svgTides,
                      itemName: AppStrings.tides,
                      value: ' Meters',
                      onTap: () {
                        PopUpHelpers.showChartPopup(
                            context,
                            _tideDataWidgetFuture(
                                title: AppStrings.tides,
                                iconPath: ImagePaths.icTides));
                      }),
                  Opacity(
                    opacity: 0.0,
                    child: gridRowItemSVG(
                        iconImagePath: ImagePaths.svgTides,
                        itemName: AppStrings.swellDirection,
                        value: 'NV',
                        onTap: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _fathometerContainer() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: _util.setHeight(48)),
      decoration: BoxDecoration(color: Colors.white),
      height: h / 2, //util.setHeight(960),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // debugPrint(
          //     'context max width -----  ${constraints.maxWidth} -- min width -- ${constraints.minWidth}and  max height   ${constraints.maxHeight} -- min height -- ${constraints.minHeight}');

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                bottom: constraints.maxHeight *
                    2 /
                    3, //constraints.maxHeight / 8, //util.setHeight(48),
                left: _util.setWidth(8),
                child: _scaleBarWidgetAboveSea(),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 2 / 3,
                  child: SvgPicture.asset(
                    ImagePaths.svgSeaWave2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  top: constraints.maxHeight / 3,
                  right: _util.setWidth(8),
                  child: _scaleBarWidgetUnderSea()),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * .43,
                  child: SvgPicture.asset(
                    ImagePaths.svgSeaGround2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image.asset(
                  ImagePaths.obWhite,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _scaleBarWidgetAboveSea() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLine(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLineWithText('4M'),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLine(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLineWithText('3M'),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLine(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLineWithText('2M'),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLine(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLineWithText('1M'),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(4), bottom: _util.setHeight(4)),
            child: _scaleBarLine(),
          ),
        ],
      ),
    );
  }

  _scaleBarWidgetUnderSea() {
    double paddingHeight = 12.0;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: _util.setHeight(4)),
            child: Text(
              'SEA LEVEL',
              style: TextStyle(
                  fontSize: _util.setSp(32), color: ColorConstants.SCALE_COLOR),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '-20M',
                style: TextStyle(
                    fontSize: _util.setSp(32),
                    color: ColorConstants.SCALE_COLOR_LIGHT),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
              ),
              _scaleBarLine(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLineFullWidth(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLine(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLineShort(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '-30M',
                style: TextStyle(
                    fontSize: _util.setSp(32),
                    color: ColorConstants.SCALE_COLOR_LIGHT),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
              ),
              _scaleBarLine(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLineFullWidth(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLine(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLineShort(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '-40M',
                style: TextStyle(
                    fontSize: _util.setSp(32),
                    color: ColorConstants.SCALE_COLOR_LIGHT),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
              ),
              _scaleBarLine(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _util.setHeight(paddingHeight),
                bottom: _util.setHeight(paddingHeight)),
            child: _scaleBarLineFullWidth(),
          ),
        ],
      ),
    );
  }

  _scaleBarLine() {
    return SizedBox(
      width: _util.setWidth(72),
      height: _util.setHeight(4),
      child: new Center(
          child: SvgPicture.asset(
        ImagePaths.svgMarineDividerLine,
        color: ColorConstants.SCALE_COLOR_LIGHT,
        fit: BoxFit.cover,
      )),
    );
  }

  _scaleBarLineFullWidth() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: _util.setHeight(4),
      child: new Center(
          child: SvgPicture.asset(
        ImagePaths.svgMarineDividerLine,
        color: ColorConstants.SCALE_COLOR_LIGHT,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      )),
    );
  }

  _scaleBarLineShort() {
    return SizedBox(
      width: _util.setWidth(48),
      height: _util.setHeight(2),
      child: new Center(
          child: SvgPicture.asset(
        ImagePaths.svgMarineDividerLine,
        color: ColorConstants.SCALE_COLOR_LIGHT,
        fit: BoxFit.cover,
      )),
    );
  }

  _scaleBarLineWithText(String text) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: _util.setWidth(48),
          height: _util.setHeight(12),
          child: new Center(
              child: SvgPicture.asset(
            ImagePaths.svgMarineDividerLine,
            color: ColorConstants.SCALE_COLOR_LIGHT,
            fit: BoxFit.cover,
          )),
        ),
        SizedBox(
          width: _util.setWidth(8),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: _util.setSp(40), color: ColorConstants.SCALE_COLOR),
        )
      ],
    );
  }

  Widget _marineItemsWidgetFuture() {
    return FutureBuilder<StormGlassData>(
        future: _futureWeatherData,
        // initialData: stormGlassDataProvider.weatherDataToday,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _marineItemContainer(snapshot.data) //movieGrid(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget _marineDataWidgetFuture({String title, String iconPath}) {
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

  Widget _tideDataWidgetFuture({String title, String iconPath}) {
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
            FutureBuilder<TideData>(
                future: _futureTideData,
                // initialData: stormGlassDataProvider.weatherDataToday,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    print(snapshot.data.extremas.length);
                  else
                    print('no data');
                  return snapshot.hasData
                      ? _beizerChartTide(
                          data: snapshot.data,
                          title: title,
                          iconPath: iconPath) //movieGrid(snapshot.data)
                      : Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget _beizerChartTide({TideData data, String title, String iconPath}) {
    int length = data.extremas.length;
    final fromDate = DateTime.parse(data.extremas[0].time);
    final toDate = DateTime.parse(data.extremas[length - 1].time);
    final selectedDate = DateTime.now();
    double selectedValue = 0.0;

    String indicatorValueUnit = ''; // = '${SymbolConstant.DEGREE}C';

    List<DataPoint<DateTime>> dataPointList = data.extremas.map((f) {
      // 2019-09-16T00:00:00+00:00
      var date1 = DateTime.parse(f.time);
      // double xAxisValue = date1.hour.toDouble();
      DateTime xAxisValue = date1;
      double pointValue = num.parse(
          f.height.toStringAsFixed(2)); //f.height;//double.parse(f.height);

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
