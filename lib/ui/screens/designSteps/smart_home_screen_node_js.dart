import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/bloc/iot_topic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/screens/designSteps/smart_home_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SmartHomeScreenNodeServer extends StatefulWidget {
  static const String routeName = '/smart_home_node';

  @override
  _SmartHomeScreenNodeServerState createState() =>
      _SmartHomeScreenNodeServerState();
}

class _SmartHomeScreenNodeServerState extends State<SmartHomeScreenNodeServer> {
  Future<List<IotEventData>> _allSensorData;
  Future<List<IotEventData>> _sensorDataById;
  Future<List<IotEventData>> _last3dayssensorData;

  List<IotTopic> _topicList;
  IotTopicBloc _iotTopicBloc;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    _iotTopicBloc = IotTopicBloc();
    Future.delayed(Duration.zero).then((_) {
      _allSensorData =
          // Provider.of<SmartHomeDataProvider>(context).fetchAllSensorData();
          // _sensorDataById =
          //     Provider.of<SmartHomeDataProvider>(context).fetchSensorDataById(1);
          // _last3dayssensorData = Provider.of<SmartHomeDataProvider>(context)
          //     .fetchSensorDataLast3Days();
          Provider.of<SmartHomeDataProvider>(context)
              .fetchAllTopicsData()
              .then((topicList) {
        _topicList = topicList;
        _isLoading = false;
      });
    });

    _iotTopicBloc.topicController.listen((topic) {
      _sensorDataById = Provider.of<SmartHomeDataProvider>(context)
          .fetchSensorDataByTopic(topic);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _iotTopicBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Appbar(
                  ScreenTitle.SMART_HOME,
                  isDesignScreen: true,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 64.w),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _topicList != null && _topicList.length > 0
                              ? _getTopicsDropdown(
                                  _topicList.map((e) => e.topic).toList(),
                                  _iotTopicBloc.topicController,
                                  _iotTopicBloc.selectedTopicChanged,
                                  false,
                                  label: 'Topic')
                              : Container(),
                        ),
                        FutureBuilder<List<IotEventData>>(
                            future: _allSensorData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child: Container(),
                                );
                              }

                              if (snapshot.hasData) {
                                return _sensorDataList(
                                    snapshot.data, 'All Sensor List');
                              }

                              return SliverToBoxAdapter(
                                child: Container(),
                              );
                            }),
                        FutureBuilder<List<IotEventData>>(
                            future: _sensorDataById,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child: Container(),
                                );
                              }

                              if (snapshot.hasData) {
                                return _sensorDataList(
                                    snapshot.data, 'Sensor Data By Id');
                              }

                              return SliverToBoxAdapter(
                                child: Container(),
                              );
                            }),
                        FutureBuilder<List<IotEventData>>(
                            future: _last3dayssensorData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child: Container(),
                                );
                              }

                              if (snapshot.hasData) {
                                return _sensorDataList(
                                    snapshot.data, 'Last 3 Day Sensor Data');
                              }

                              return SliverToBoxAdapter(
                                child: Container(),
                              );
                            })
                      ],
                    ),
                  ),
                ),
                BottomClipper(ButtonText.BACK, '', goBack, () {},
                    isNextEnabled: false)
              ],
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  // _sensorDataWithInDatesList

  // _sensorDataByIDList

  // _sensorDataList(List<IotEventData> sensorDataList, String title) {
  //   return SliverStickyHeader(
  //     header: _buildHeader(title),
  //     sliver: SliverList(
  //       delegate: SliverChildBuilderDelegate((context, index) {
  //         return Container(
  //           padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Wrap(
  //                 children: [
  //                   Text('EventId: ${sensorDataList[index].eventID.toString()}')
  //                 ],
  //               ),
  //               Wrap(
  //                 children: [
  //                   Text(
  //                       'Temperature: ${sensorDataList[index].value.toString()}')
  //                 ],
  //               ),
  //               Wrap(
  //                 children: [
  //                   Text(
  //                       'Timestamp: ${sensorDataList[index].tiemStamp.toString()}')
  //                 ],
  //               )
  //             ],
  //           ),
  //         );
  //       }, childCount: sensorDataList.length),
  //     ),
  //   );
  // }

  // _allSensorDataList(List<IotEventData> sensorDataList, String title) {
  //   return SliverStickyHeader(
  //     header: _buildHeader(title),
  //     sliver: SliverList(
  //       delegate: SliverChildBuilderDelegate((context, index) {
  //         var roomName = sensorDataList[index].topic.split('/').first;
  //         var sensorName = sensorDataList[index].topic.split('/').last;
  //         return _tableRow(
  //             roomName,
  //             sensorName,
  //             sensorDataList[index].value.toString(),
  //             sensorDataList[index].tiemStamp.toString());
  //       }, childCount: sensorDataList.length),
  //     ),
  //   );
  // }

  _sensorDataList(List<IotEventData> sensorDataList, String title) {
    return SliverStickyHeader(
      header: _buildHeader(title),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          var roomName = sensorDataList[index].topic.split('/').first;
          var sensorName = sensorDataList[index].topic.split('/').last;
          return _tableRow(
              roomName,
              sensorName,
              sensorDataList[index].value.toString(),
              sensorDataList[index].tiemStamp.toString());
        }, childCount: sensorDataList.length),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          SizedBox(
            height: 32.h,
          ),
          _sensorTableTitle(text),
          _tableRow('Room', 'Sensor', 'Data', 'Time')
        ],
      ),
    );
  }

  Row _sensorTableTitle(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          textScaleFactor: 1.5,
          style: TextStyle(color: ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE),
        ),
      ],
    );
  }

  Widget _tableRow(String col1, String col2, String col3, String col4) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Text(col1,
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
          Text(col2,
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
          Text(col3,
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
          Text(col4,
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
        ])
      ],
    );
  }

  goBack() {
    Navigator.pop(context);
  }

  Widget _getTopicsDropdown(
      List<String> list, Observable<String> stream, changed, bool addPadding,
      {String label = 'Label'}) {
    ScreenUtil _util = ScreenUtil();
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: _util.setWidth(48))
                : EdgeInsets.symmetric(horizontal: 0),
            child: InputDecorator(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.w),
                  borderSide: BorderSide(
                      color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                      width: 1),
                ),
                contentPadding: EdgeInsets.only(
                  top: 16.h,
                  bottom: 16.h,
                  left: 48.w,
                  // right: 32.w
                ),
                // alignLabelWithHint: true,
                labelText: label,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // hintStyle: TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                    color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                    fontSize: _util.setSp(48)),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 96.w,
                        color: snapshot.hasData
                            ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                            : ColorConstants
                                .ACCESS_MANAGEMENT_SUBTITLE //ColorConstants.INVALID_TEXTFIELD,
                        ),
                    value: snapshot.hasData ? snapshot.data : list[0],
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                      color: snapshot.hasData
                          ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                          : ColorConstants
                              .ACCESS_MANAGEMENT_SUBTITLE, //ColorConstants.INVALID_TEXTFIELD,
                      fontSize: _util.setSp(40),
                      fontWeight: FontWeight.w400,
                      // letterSpacing: 1.2,
                      // wordSpacing: 4
                    ),
                    onChanged: changed,
                    items: list.map((data) {
                      return DropdownMenuItem(
                          value: data,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(parseTopicName(data)),
                            ],
                          ));
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
