import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/source_list_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:rxdart/rxdart.dart';

class SelectSourceWidget extends StatefulWidget {
  static const String routeName = '/selecctSourceWidget';
  SelectSourceWidget();
  @override
  _SelectSourceWidgetState createState() => _SelectSourceWidgetState();
}

class _SelectSourceWidgetState extends State<SelectSourceWidget> {
  ScreenUtil _util;
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
    _util = ScreenUtil();
    // GlobalContext.currentScreenContext = context;
    return Container(
        decoration: BoxDecoration(
            // gradient: profileGradient,
            color: ColorConstants.SOURCE_POPUP_BKG,
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                // UIHelper.getTopEmptyContainer(
                //     MediaQuery.of(context).size.height / 16, false),

                SliverPadding(
                  padding: EdgeInsets.only(
                    top: _util.setHeight(32),
                    bottom: _util.setHeight(32),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: _util.setWidth(32),
                              vertical: _util.setHeight(8)),
                          padding: EdgeInsets.symmetric(
                              vertical: _util.setHeight(8),
                              horizontal: _util.setWidth(32)),
                          child: Text(
                            'SELECT SOURCE',
                            style: TextStyle(
                                color: ColorConstants.COLOR_NOTIFICATION_TITLE,
                                fontWeight: FontWeight.w400,
                                fontSize: _util.setSp(36)),
                          ),
                        ),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.humiditySource,
                            _bloc.humiditySourceChanged,
                            true,
                            label: 'Humidity'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.solarRadiationSource,
                            _bloc.solarRadiationSourceChanged,
                            true,
                            label: 'Solar Radiation'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.uvRadiationSource,
                            _bloc.uvRadiationSourceChanged,
                            true,
                            label: 'UV Radiation'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.windSpeedSource,
                            _bloc.windSpeedSourceChanged,
                            true,
                            label: 'Wind Speed'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.windGustsSource,
                            _bloc.windGustsSourceChanged,
                            true,
                            label: 'Wind Gusts'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.windDirectionSource,
                            _bloc.windDirectionSourceChanged,
                            true,
                            label: 'Wind Direction'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.bpuSource,
                            _bloc.bpuSourceChanged,
                            true,
                            label: 'BPU'),
                        SizedBox(height: _util.setHeight(48)),
                        getDropdown(
                            ListHelper.getSourceList(),
                            _bloc.temperatureSource,
                            _bloc.temperatureSourceChanged,
                            true,
                            label: 'Temperature'),
                      ],
                    ),
                  ),
                ),
                // UIHelper.getTopEmptyContainer(90, false),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                //color: ColorConstants.MODAL_BKG.withOpacity(.375),
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
                              right: _util.setWidth(32),
                              top: _util.setHeight(16),
                              bottom: _util.setHeight(32),
                            ),
                            child: Image.asset(
                              ImagePaths.cross,
                              width: _util.setWidth(48),
                              height: _util.setHeight(48),
                              color: ColorConstants.WEATHER_MORE_ICON_COLOR,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )
        // ),
        );
  }


}
