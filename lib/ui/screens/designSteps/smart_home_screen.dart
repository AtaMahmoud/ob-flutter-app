import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/bloc/iot_topic_bloc.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/shared/drop_downs.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';

class SmartHomeScreen extends StatefulWidget {
  static const String routeName = '/smart_home';

  @override
  _SmartHomeScreenState createState() => _SmartHomeScreenState();
}



class _SmartHomeScreenState extends State<SmartHomeScreen> {
  Future<MqttServerClient> _mqttServerClient;
  SmartHomeDataProvider _smartHomeDataProvider;
  bool _isConnecting = false;
  IotTopicBloc  iotTopicBloc;
  List<IotTopic>  _topicList;

  @override
  void initState() {
    super.initState();
    iotTopicBloc = IotTopicBloc();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Future.delayed(Duration.zero).then((_) {
      _smartHomeDataProvider.fetchAllTopicsData().then((topicList) {
      _mqttServerClient = _smartHomeDataProvider.connect();
      _topicList = topicList;
      _mqttServerClient.then((client) {
        if (client.connectionStatus.returnCode ==
            MqttConnectReturnCode.connectionAccepted) {
          _isConnecting = true;
          for(int i = 0; i < topicList.length ; i ++){
          client.subscribe(topicList[i].topic, MqttQos.atLeastOnce);
           debugPrint('Subscribed to Topic: ${topicList[i].topic}');
          }
          
          showInfoBar('Connected', 'Connected with MQTT broker', context);
        } else {
          showInfoBar(
              'Not Connected', 'Could not connected with MQTT broker', context);
          _isConnecting = false;
        }
      });
      });

    });
  }

  @override
void dispose() { 
  super.dispose();
  iotTopicBloc.dispose();
}



  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _smartHomeDataProvider = Provider.of<SmartHomeDataProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Stack(
          children: [
            Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Appbar(
                  ScreenTitle.SMART_HOME,
                  isDesignScreen: false,
                ),
                // Spacer(),
                _mainContent(),
                BottomClipper(ButtonText.BACK, '', goBack, () {},
                    isNextEnabled: false)
              ],
            ),
            _isConnecting
                ? Container()
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
      ),
    );
  }

  Expanded _mainContent() {
    return Expanded(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
                    children: [
                      _topicList != null && _topicList.length > 0 ?
                      getDropdown(_topicList.map((e) => e.topic).toList(), iotTopicBloc.topicController, iotTopicBloc.selectedTopicChanged, false,label: 'Topic')
                      : Container(),
                      _buildConnectionStateText(_prepareStateMessageFrom(
                          _smartHomeDataProvider.getAppConnectionState)),
                      _buildScrollableTextWith(_smartHomeDataProvider.getHistoryText),
                    ],
                  ),
      ),
    );
  }

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected With MQTT Broker';
      case MQTTAppConnectionState.connecting:
        return 'Connecting With MQTT Broker';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected From MQTT Broker';
    }
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.w),
                color: AppTheme.chipBackground,
              ),
              padding: EdgeInsets.all(32.w),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: ColorConstants.TEXT_COLOR),
              )),
        ),
      ],
    );
  }

  Widget _buildScrollableTextWith(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.w),
        color: AppTheme.chipBackground,
      ),
      height: 600.h,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: ColorConstants.TEXT_COLOR),
          ),
        ),
      ),
    );
  }

  goBack() {
    Navigator.pop(context);
  }
}
