import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Future.delayed(Duration.zero).then((_) {
      _allSensorData =
          Provider.of<SmartHomeDataProvider>(context).fetchAllSensorData();
      _sensorDataById =
          Provider.of<SmartHomeDataProvider>(context).fetchSensorDataById(1);
      _last3dayssensorData = Provider.of<SmartHomeDataProvider>(context)
          .fetchSensorDataLast3Days();
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Appbar(
              ScreenTitle.SMART_HOME,
              isDesignScreen: true,
            ),
            // Spacer(),
            Expanded(
              child: Container(
                child: CustomScrollView(
                  slivers: [
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
      ),
    );
  }

  // _sensorDataWithInDatesList

  // _sensorDataByIDList

  _sensorDataList(List<IotEventData> sensorDataList, String title) {
    return SliverStickyHeader(
      header: _buildHeader(title),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text('EventId: ${sensorDataList[index].eventID.toString()}')
                  ],
                ),
                Wrap(
                  children: [
                    Text(
                        'Temperature: ${sensorDataList[index].temperature.toString()}')
                  ],
                ),
                Wrap(
                  children: [
                    Text(
                        'Timestamp: ${sensorDataList[index].tiemStamp.toString()}')
                  ],
                )
              ],
            ),
          );
        }, childCount: sensorDataList.length),
      ),
    );
  }

  _allSensorDataList(List<IotEventData> sensorDataList) {
    return SliverStickyHeader(
      header: _buildHeader('All Sensor Data'),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text('EventId: ${sensorDataList[index].eventID.toString()}')
                  ],
                ),
                Wrap(
                  children: [
                    Text(
                        'Temperature: ${sensorDataList[index].temperature.toString()}')
                  ],
                ),
                Wrap(
                  children: [
                    Text(
                        'Timestamp: ${sensorDataList[index].tiemStamp.toString()}')
                  ],
                )
              ],
            ),
          );
        }, childCount: sensorDataList.length),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return new Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(top: 16.h, bottom: 16.h, left: 32.w, right: 32.w),
      alignment: Alignment.centerLeft,
      child: new Text(
        text,
        style: TextStyle(
            fontSize: 48.sp,
            color: ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }
}
