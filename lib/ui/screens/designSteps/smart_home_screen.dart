import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SmartHomeScreen extends StatefulWidget {
  static const String routeName = '/smart_home';

  @override
  _SmartHomeScreenState createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  SmartHomeDataProvider _smartHomeDataProvider;
  MqttServerClient _mqttServerClient;

  @override
  void initState() {
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Future.delayed(Duration.zero).then((_) {
      _smartHomeDataProvider.connect().then((value) {
        _mqttServerClient = value;
        _mqttServerClient.subscribe(Config.MQTT_TOPIC, MqttQos.atLeastOnce);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _smartHomeDataProvider = Provider.of<SmartHomeDataProvider>(context);
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
