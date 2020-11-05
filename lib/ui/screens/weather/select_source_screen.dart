import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:rxdart/rxdart.dart';

class SelectSourceWidget extends StatefulWidget {
  static const String routeName = '/selecctSourceWidget';
  SelectSourceWidget();
  @override
  _SelectSourceWidgetState createState() => _SelectSourceWidgetState();
}

class _SelectSourceWidgetState extends State<SelectSourceWidget> {
  SourceListBloc _bloc = SourceListBloc();

  @override
  void initState() {
    UIHelper.setStatusBarColor();
    super.initState();
    _setUserDataListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setUserDataListener() {
    //-----
    _bloc.weatherSourceController.listen((onData) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // gradient: profileGradient,
            color: ColorConstants.SOURCE_POPUP_BKG,
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: 32.h,
                    bottom: 32.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _textTitle(),
                        SpaceH48(),
                        _dropDownHumiditySource(),
                        SpaceH48(),
                        _dropdownSolarRadSource(),
                        SpaceH48(),
                        _dropdownUvRadSource(),
                        SpaceH48(),
                        _dropdownWindSpeedSource(),
                        SpaceH48(),
                        _dropDownWindGustSource(),
                        SpaceH48(),
                        _dropdownWindDirectionSource(),
                        SpaceH48(),
                        _dropdownBPUSource(),
                        SpaceH48(),
                        _dropdownTempSource(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _topBar(context)
          ],
        )
        // ),
        );
  }

  Positioned _topBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 32.w,
                      top: 16.h,
                      bottom: 32.h,
                    ),
                    child: Image.asset(
                      ImagePaths.cross,
                      width: 48.w,
                      height: 48.h,
                      color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownTempSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.temperatureSource,
        _bloc.temperatureSourceChanged, true,
        label: 'Temperature');
  }

  Widget _dropdownBPUSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.bpuSource,
        _bloc.bpuSourceChanged, true,
        label: 'BPU');
  }

  Widget _dropdownWindDirectionSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.windDirectionSource,
        _bloc.windDirectionSourceChanged, true,
        label: 'Wind Direction');
  }

  Widget _dropDownWindGustSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.windGustsSource,
        _bloc.windGustsSourceChanged, true,
        label: 'Wind Gusts');
  }

  Widget _dropdownWindSpeedSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.windSpeedSource,
        _bloc.windSpeedSourceChanged, true,
        label: 'Wind Speed');
  }

  Widget _dropdownUvRadSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.uvRadiationSource,
        _bloc.uvRadiationSourceChanged, true,
        label: 'UV Radiation');
  }

  Widget _dropdownSolarRadSource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.solarRadiationSource,
        _bloc.solarRadiationSourceChanged, true,
        label: 'Solar Radiation');
  }

  Widget _dropDownHumiditySource() {
    return getDropdown(ListHelper.getSourceList(), _bloc.humiditySource,
        _bloc.humiditySourceChanged, true,
        label: 'Humidity');
  }

  Container _textTitle() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 32.w,
        vertical: 8.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Text(
        'SELECT SOURCE',
        style: TextStyle(
            color: ColorConstants.COLOR_NOTIFICATION_TITLE,
            fontWeight: FontWeight.w400,
            fontSize: 36.sp),
      ),
    );
  }
}
