import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/storm_glass_data.dart' as sgd;
import 'package:ocean_builder/core/models/w_weather_o_data.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class SharedChart {
//  tideDataList = [];

  /* static Widget beizerChart(
      {BuildContext context,
      StormGlassData data,
      String title,
      String iconPath}) {
    ScreenUtil util = ScreenUtil();

    List<Hourly> hours;

    // for (var f in data.data.weathers) {

    //   var date1 = DateTime.parse(f.date);//.toIso8601String();

    //   for(var h in f.hours){

    //     h.dateTime = date1.add(Duration(hours: int.parse(h.time))).toIso8601String();
    //     Hourly hour = h;
    //     hours.add(hour);

    //   }

    // }

    int length = data.hours.length;
    final fromDate = DateTime.parse(data.hours[0].time);
    final toDate = DateTime.parse(data.hours[length - 1].time);

    final selectedDate = DateTime.now();
    double selectedValue = 0.0;

    String indicatorValueUnit = ''; // = '${SymbolConstant.DEGREE}C';

    List<DataPoint<DateTime>> dataPointList = data.hours.map((f) {
      // 2019-09-16T00:00:00+00:00
      var date1 = DateTime.parse(f.time);
      // double xAxisValue = date1.hour.toDouble();

      DateTime xAxisValue = date1;
      double pointValue;

      if (title.contains(AppStrings.waterTemp)) {
        pointValue = f.waterTemperatureList.attributeDataList[0].value
            .round()
            .toDouble();
        indicatorValueUnit = '${SymbolConstant.DEGREE}C';
      } else if (title.contains(AppStrings.seaLevel)) {
        pointValue = f.seaLevelList.attributeDataList[0].value;
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.waveHeight)) {
        pointValue =
            f.waveHeightList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.significantWave)) {
        pointValue =
            f.significantWaveList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.visibility)) {
        pointValue =
            f.visiblityList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Meters';
      } else if (title.contains(AppStrings.swellHeight)) {
        pointValue = f.swellHeightList.attributeDataList[0].value;
        indicatorValueUnit = 'Meters';
      } else if (title.contains(AppStrings.swellDirection)) {
        pointValue =
            f.swellDirectionList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = SymbolConstant.DEGREE;
      } else if (title.contains(AppStrings.swellPeriod)) {
        pointValue =
            f.swellPeriodList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Seconds';
      } else if (title.contains(AppStrings.windSpeed)) {
        pointValue =
            f.windSpeedList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Km/H';
      } else if (title.contains(AppStrings.windGusts)) {
        pointValue =
            f.windGustList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Mph';
      } else if (title.contains(AppStrings.windDirection)) {
        pointValue =
            f.windDirectionList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = SymbolConstant.DEGREE;
      } else if (title.contains(AppStrings.barometricPressure)) {
        pointValue = f.barometricPressureList.attributeDataList[0].value
            .round()
            .toDouble();
        indicatorValueUnit = 'Inch';
      }

      if (date1.difference(DateTime.now()) < Duration(minutes: 59)) {
        selectedValue = pointValue;
      }

      return DataPoint<DateTime>(value: pointValue, xAxis: xAxisValue);
    }).toList();

    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        // color: Colors.white,
        // height: ScreenUtil().setHeight(512),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PopUpHelpers.popUpTitle(
                context, title, iconPath, '$selectedValue $indicatorValueUnit'),
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
                    lineStrokeWidth: util.setHeight(8),
                    data: dataPointList,
                  ),
                ],
                config: BezierChartConfig(
                  footerHeight: util.setHeight(128),
                  verticalIndicatorColor:
                      ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                  showVerticalIndicator: true,
                  contentWidth: MediaQuery.of(context).size.width * 2,
                  showDataPoints: false,
                  displayLinesXAxis: true,
                  bubbleIndicatorValueStyle: TextStyle(
                      color:
                          ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                      fontSize: util.setSp(72)),
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
  } */

  static Widget beizerChartWeather(
      {BuildContext context,
      WorldWeatherOnlineData data,
      String title,
      String iconPath,
      SourceListBloc bloc}) {
    ScreenUtil _util = ScreenUtil();

    List<Hourly> hours = [];

    for (var f in data.data.weathers) {
      var date1 = DateTime.parse(f.date); //.toIso8601String();

      for (var h in f.hours) {
        int hourNo = int.parse(h.time);
        hourNo = (hourNo / 100).round();
        h.dateTime = date1.add(Duration(hours: hourNo)).toString();
        Hourly hour = h;
        hours.add(hour);
      }
    }

    int length = hours.length;
    final fromDate = DateTime.parse(hours[0].dateTime);
    final toDate = DateTime.parse(hours[length - 1].dateTime);
    var selectedDate = DateTime.now();
    double selectedValue = 0.0;

    String indicatorValueUnit = ''; // = '${SymbolConstant.DEGREE}C';

    List<DataPoint<DateTime>> dataPointList = hours.map((f) {
      // 2019-09-16T00:00:00+00:00
      var date1 = DateTime.parse(f.dateTime);
      // double xAxisValue = date1.hour.toDouble();

      DateTime xAxisValue = date1;
      double pointValue;

      if (title.contains(AppStrings.waterTemp)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = '${SymbolConstant.DEGREE}C';
      } else if (title.contains(AppStrings.seaLevel)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.waveHeight)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.significantWave)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.visibility)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = 'Meters';
      } else if (title.contains(AppStrings.swellHeight)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = 'Meters';
      } else if (title.contains(AppStrings.swellDirection)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = SymbolConstant.DEGREE;
      } else if (title.contains(AppStrings.swellPeriod)) {
        pointValue = double.parse(f.tempC).round().toDouble();
        indicatorValueUnit = 'Seconds';
      } else if (title.contains(AppStrings.uvRadiation)) {
        pointValue = double.parse(f.uvIndex);
        indicatorValueUnit = 'NM';
      } else if (title.contains(AppStrings.windSpeed)) {
        pointValue = double.parse(f.windspeedKmph);
        indicatorValueUnit = 'Km/H';
      } else if (title.contains(AppStrings.windGusts)) {
        pointValue = double.parse(f.windGustKmph).round().toDouble();
        indicatorValueUnit = 'Mph';
      } else if (title.contains(AppStrings.windDirection)) {
        pointValue = double.parse(f.winddirection).round().toDouble();
        indicatorValueUnit = SymbolConstant.DEGREE;
      } else if (title.contains(AppStrings.barometricPressure)) {
        pointValue = double.parse(f.pressureInches).round().toDouble();
        indicatorValueUnit = 'Inch';
      }

      if (date1.difference(DateTime.now()) < Duration(minutes: 59)) {
        selectedValue = pointValue;
        selectedDate = xAxisValue;
      }

      return DataPoint<DateTime>(value: pointValue, xAxis: xAxisValue);
    }).toList();

    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        // color: Colors.white,
        // height: ScreenUtil().setHeight(512),
        padding: EdgeInsets.only(
            left: _util.setWidth(32),
            right: _util.setWidth(32),
            bottom: _util.setWidth(32)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PopUpHelpers.popUpTitle(
                context, title, iconPath, '$selectedValue $indicatorValueUnit'),
            Padding(
              padding: EdgeInsets.all(_util.setWidth(32)),
              child: Container(
                height: _util.setHeight(54),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () {},
                        padding: EdgeInsets.only(
                            left: _util.setWidth(32),
                            right: _util.setWidth(32),
                            top: 0,
                            bottom: 0),
                        child: Text(
                          'SHORT TERM',
                          style: TextStyle(fontSize: _util.setSp(28)),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.circular(_util.setWidth(48)),
                            side: BorderSide(
                              color:
                                  ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                            )),
                        textColor: Colors.white,
                        color: ColorConstants.LIGHT_POPUP_TEXT),
                    SizedBox(
                      width: _util.setWidth(32),
                    ),
                    RaisedButton(
                        onPressed: () {},
                        padding: EdgeInsets.only(
                            left: _util.setWidth(32),
                            right: _util.setWidth(32),
                            top: 0,
                            bottom: 0),
                        child: Text(
                          'LONG TERM',
                          style: TextStyle(fontSize: _util.setSp(28)),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              new BorderRadius.circular(_util.setWidth(48)),
                          side: BorderSide(
                            color:
                                ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                          ),
                        ),
                        textColor: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                        color: Colors.white)
                  ],
                ),
              ),
            ),
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
                    lineStrokeWidth: _util.setHeight(8),
                    data: dataPointList,
                  ),
                ],
                config: BezierChartConfig(
                  footerHeight: _util.setHeight(128),
                  verticalIndicatorColor:
                      ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                  showVerticalIndicator: true,
                  contentWidth: MediaQuery.of(context).size.width * 2,
                  showDataPoints: false,
                  displayLinesXAxis: true,
                  bubbleIndicatorValueStyle: TextStyle(
                      color:
                          ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                      fontSize: _util.setSp(72)),
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
            // SizedBox(
            //   height: util.setHeight(64),
            // ),
            getDropdown(ListHelper.getSourceList(), bloc.weatherSource,
                bloc.weatherSourceChanged, false,
                label: 'Select Source'),
          ],
        ),
      ),
    );
  }
}

class BeizerChartPopup extends StatefulWidget {
  final sgd.StormGlassData data;
  final String title;
  final String iconPath;
  final SourceListBloc bloc;

  const BeizerChartPopup(
      {Key key, this.data, this.title, this.iconPath, this.bloc})
      : super(key: key);

  @override
  _BeizerChartPopupState createState() => _BeizerChartPopupState();
}

class _BeizerChartPopupState extends State<BeizerChartPopup> {
  bool isShortTerm = true;

  @override
  Widget build(BuildContext context) {
    return _beizerChartWeather(
        data: widget.data,
        title: widget.title,
        iconPath: widget.iconPath,
        bloc: widget.bloc);
  }

  Widget _beizerChartWeather(
      {sgd.StormGlassData data,
      String title,
      String iconPath,
      SourceListBloc bloc}) {
    ScreenUtil _util = ScreenUtil();

    int length = data.hours.length;
    final fromDate = DateTime.parse(data.hours[0].time);
    final toDate = DateTime.parse(data.hours[length - 1].time);
    final selectedDate = DateTime.now();
    double selectedValue = 0.0;

    String indicatorValueUnit = ''; // = '${SymbolConstant.DEGREE}C';
    int counter = 0;
    List<DataPoint<DateTime>> dataPointList = data.hours.map((f) {
      counter++;
      // 2019-09-16T00:00:00+00:00
      var date1 = DateTime.parse(f.time);
      // double xAxisValue = date1.hour.toDouble();

      DateTime xAxisValue = date1;
      double pointValue;
      if (title.contains(AppStrings.temperature)) {
        pointValue =
            f.airTemperatureList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = '${SymbolConstant.DEGREE}C';
      } else if (title.contains(AppStrings.chanceOfRain)) {
        pointValue =
            f.precipitationList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = ' %';
      } else if (title.contains(AppStrings.humidity)) {
        pointValue =
            f.humidityList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = ' %';
      } else if (title.contains(AppStrings.waterTemp)) {
        pointValue = f.waterTemperatureList.attributeDataList[0].value
            .round()
            .toDouble();
        indicatorValueUnit = '${SymbolConstant.DEGREE}C';
      } else if (title.contains(AppStrings.seaLevel)) {
        pointValue = f.seaLevelList.attributeDataList[0].value;
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.waveHeight)) {
        pointValue =
            f.waveHeightList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.significantWave)) {
        pointValue =
            f.significantWaveList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'meters';
      } else if (title.contains(AppStrings.visibility)) {
        pointValue =
            f.visiblityList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Meters';
      } else if (title.contains(AppStrings.swellHeight)) {
        pointValue = f.swellHeightList.attributeDataList[0].value;
        indicatorValueUnit = 'Meters';
      } else if (title.contains(AppStrings.swellDirection)) {
        pointValue =
            f.swellDirectionList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = SymbolConstant.DEGREE;
      } else if (title.contains(AppStrings.swellPeriod)) {
        pointValue =
            f.swellPeriodList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Seconds';
      } else if (title.contains(AppStrings.windSpeed)) {
        pointValue =
            f.windSpeedList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Km/H';
      } else if (title.contains(AppStrings.windGusts)) {
        pointValue =
            f.windGustList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = 'Mph';
      } else if (title.contains(AppStrings.windDirection)) {
        pointValue =
            f.windDirectionList.attributeDataList[0].value.round().toDouble();
        indicatorValueUnit = SymbolConstant.DEGREE;
      } else if (title.contains(AppStrings.barometricPressure)) {
        pointValue = f.barometricPressureList.attributeDataList[0].value
            .round()
            .toDouble();
        indicatorValueUnit = 'Inch';
      }

      if (date1.difference(DateTime.now()) < Duration(minutes: 59)) {
        selectedValue = pointValue;
      }
      debugPrint(
          '---counter ------ $counter--------- point value ----- $pointValue ------ x value -------- $xAxisValue');
      return DataPoint<DateTime>(value: pointValue, xAxis: xAxisValue);
    }).toList();

    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.white),
        // color: Colors.white,
        // height: ScreenUtil().setHeight(512),
        padding: EdgeInsets.only(
            left: _util.setWidth(32),
            right: _util.setWidth(32),
            bottom: _util.setWidth(32)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PopUpHelpers.popUpTitle(
                context, title, iconPath, '$selectedValue $indicatorValueUnit'),
            Padding(
              padding: EdgeInsets.all(_util.setWidth(32)),
              child: Container(
                height: _util.setHeight(54),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () {
                          setState(() {
                            isShortTerm = true;
                          });
                        },
                        padding: EdgeInsets.only(
                            left: _util.setWidth(32),
                            right: _util.setWidth(32),
                            top: 0,
                            bottom: 0),
                        child: Text(
                          'SHORT TERM',
                          style: TextStyle(fontSize: _util.setSp(28)),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.circular(_util.setWidth(48)),
                            side: BorderSide(
                              color:
                                  ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                            )),
                        textColor: isShortTerm
                            ? Colors.white
                            : ColorConstants.ACCESS_MANAGEMENT_TITLE,
                        color: isShortTerm
                            ? ColorConstants.LIGHT_POPUP_TEXT
                            : Colors.white),
                    SizedBox(
                      width: _util.setWidth(32),
                    ),
                    RaisedButton(
                        onPressed: () {
                          setState(() {
                            isShortTerm = false;
                          });
                        },
                        padding: EdgeInsets.only(
                            left: _util.setWidth(32),
                            right: _util.setWidth(32),
                            top: 0,
                            bottom: 0),
                        child: Text(
                          'LONG TERM',
                          style: TextStyle(fontSize: _util.setSp(28)),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              new BorderRadius.circular(_util.setWidth(48)),
                          side: BorderSide(
                            color:
                                ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
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
            ),
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
                    lineStrokeWidth: _util.setHeight(8),
                    data: dataPointList,
                  ),
                ],
                config: BezierChartConfig(
                  footerHeight: _util.setHeight(128),
                  verticalIndicatorColor:
                      ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                  showVerticalIndicator: true,
                  contentWidth: MediaQuery.of(context).size.width * 2,
                  showDataPoints: false,
                  displayLinesXAxis: true,
                  bubbleIndicatorValueStyle: TextStyle(
                      color:
                          ColorConstants.WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                      fontSize: _util.setSp(72)),
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
            SizedBox(
              height: _util.setHeight(64),
            ),
            // getDropdown(ListHelper.getSourceList(), bloc.weatherSource,
            //     bloc.weatherSourceChanged, false,
            //     label: 'Select Source'),
          ],
        ),
      ),
    );
  }
}
