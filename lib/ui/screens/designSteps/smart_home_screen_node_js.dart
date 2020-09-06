import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Appbar(
              ScreenTitle.SMART_HOME,
              isDesignScreen: true,
            ),
            // Spacer(),
            Text(
              AppStrings.smartHomeMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Fonts.fontVarela,
                  fontSize: ScreenUtil().setSp(48),
                  color: ColorConstants.TEXT_COLOR),
            ),
            BottomClipper(ButtonText.BACK, '', goBack, () {},
                isNextEnabled: false)
          ],
        ),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }
}
