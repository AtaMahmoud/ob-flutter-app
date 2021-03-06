import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/weather_data_day.dart';
import 'package:ocean_builder/ui/screens/weather/select_source_screen.dart';
import 'package:ocean_builder/ui/shared/popup.dart';

class WeatherByDayInfoList extends StatefulWidget {
  final WeatherDataDay weatherDataDay;
  const WeatherByDayInfoList(this.weatherDataDay);

  @override
  _WeatherByDayInfoListState createState() => _WeatherByDayInfoListState();
}

class _WeatherByDayInfoListState extends State<WeatherByDayInfoList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String _nameOfDay = widget.weatherDataDay.name.toUpperCase();
    String _temp = widget.weatherDataDay.temperatureMax.toString();
    String _tempLowest = widget.weatherDataDay.temperatureMin.toString();
    String iconPath = ImagePaths.svgCloudRain;

    iconPath =
        WeatherDescMap.weatherCodeMap[widget.weatherDataDay.weatherType].last;

    return Stack(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
            child: Center(
              child: Theme(
                child: ExpansionTile(
                    leading: SvgPicture.asset(
                      iconPath,
                      fit: BoxFit.scaleDown,
                      color: isExpanded
                          ? ColorConstants
                              .WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY
                          : ColorConstants
                              .WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '$_temp${SymbolConstant.DEGREE}/$_tempLowest${SymbolConstant.DEGREE}',
                        style: TextStyle(
                            color: isExpanded
                                ? ColorConstants
                                    .WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY
                                : ColorConstants
                                    .WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                            fontSize: 48.sp),
                      ),
                    ),
                    onExpansionChanged: (b) {
                      setState(() {
                        // // print(b);
                        isExpanded = b;
                      });
                    },
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _nameOfDay,
                          style: TextStyle(
                              color: isExpanded
                                  ? ColorConstants
                                      .WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY
                                  : ColorConstants
                                      .WEATHER_MORE_DAY_INFO_ICON_COLOR_LIGHT,
                              fontSize: 32.sp),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SvgPicture.asset(
                          ImagePaths.svgWeatherDayStatus,
                          fit: BoxFit.scaleDown,
                          color: ColorConstants.WEATHER_BKG_CIRCLE,
                        ),
                      ],
                    ),
                    children: [
                      _dayDataRow(),
                      // _dayDataMinRow(),
                      // Row(
                      //   children: <Widget>[
                      //     Expanded(
                      //       child: Container(
                      //           padding: EdgeInsets.only(
                      //               left: _util.setWidth(48),
                      //               right: _util.setWidth(48)),
                      //           child: RaisedButton(
                      //               onPressed: () {
                      //                 // Navigator.of(context).pop();
                      //                 showSelectSourcePopup(
                      //                     context, SelectSourceWidget(), " ");
                      //               },
                      //               elevation: 0,
                      //               child: Text('SELECT SOURCE'),
                      //               shape: RoundedRectangleBorder(
                      //                   borderRadius: new BorderRadius.circular(
                      //                       _util.setWidth(32)),
                      //                   side: BorderSide(
                      //                     color: ColorConstants
                      //                         .ACCESS_MANAGEMENT_INPUT_BORDER,
                      //                   )),
                      //               textColor:
                      //                   ColorConstants.ACCESS_MANAGEMENT_TITLE,
                      //               color: Colors.white)),
                      //     ),
                      //   ],
                      // )
                    ]),
                data: ThemeData(dividerColor: Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dayDataRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _dayInfoRowItem(
                  name: 'HUMIDITY',
                  value:
                      '${widget.weatherDataDay.humidityMax.toString()} / ${widget.weatherDataDay.humidityMin.toString()}',
                  unit: '%'),
              _dayInfoRowItem(
                  name: 'SOLAR RAD', value: '900 / 700', unit: 'W/M2'),
              _dayInfoRowItem(
                  name: 'UV RAD',
                  value:
                      '${widget.weatherDataDay.uvRadMax.toString()} / ${widget.weatherDataDay.uvRadMin.toString()}',
                  unit: 'Nm'),
              _dayInfoRowItem(
                name: 'WIND SPEED',
                value:
                    '${widget.weatherDataDay.windSpeedMax.toString()} / ${widget.weatherDataDay.windSpeedMin.toString()}',
                unit: 'km/H',
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _dayInfoRowItem(
                  name: 'WIND GUSTS',
                  value:
                      '${widget.weatherDataDay.windGustsMax.toString()} / ${widget.weatherDataDay.windGustsMin.toString()}',
                  unit: 'Mph'),
              _dayInfoRowItem(
                name: 'WIND DIR',
                value:
                    '${widget.weatherDataDay.windDirMax.toString()} / ${widget.weatherDataDay.windDirMin.toString()}',
                unit: '${SymbolConstant.DEGREE}',
              ),
              _dayInfoRowItem(
                  name: 'BPU',
                  value:
                      '${widget.weatherDataDay.baromatricPressureMax.toString()} / ${widget.weatherDataDay.windDirMin.toString()}',
                  unit: 'Inch'),
              _dayInfoRowItem(
                  name: 'PRECIPITATION',
                  value:
                      '${widget.weatherDataDay.precipMMMax.toString()} / ${widget.weatherDataDay.precipMMMin.toString()}',
                  unit: 'mm')
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayInfoRowItem({String name, String value, String unit}) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        0.0,
        8.h,
        0.0,
        8.h,
      ),
      width: 425.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              name.toUpperCase(),
              style: TextStyle(
                color: ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
              child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: value,
                  style: TextStyle(
                      color:
                          ColorConstants.WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                      fontSize: 32.sp),
                ),
                TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                        color: ColorConstants
                            .WEATHER_MORE_DAY_INFO_ITEM_COLOR_HEAVY,
                        fontSize: 24.sp))
              ],
            ),
          )),
        ],
      ),
    );
  }

  showSelectSourcePopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 256.h,
        left: 48.w,
        right: 48.w,
        bottom: 48.h,
        child: widget,
      ),
    );
  }
}
