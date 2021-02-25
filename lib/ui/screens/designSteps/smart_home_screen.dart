import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:rxdart/rxdart.dart';

class SmartHomeScreen extends StatefulWidget {
  static const String routeName = '/smart_home';

  @override
  _SmartHomeScreenState createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  Future<MqttServerClient> _mqttServerClientFuture;
  MqttServerClient _mqttServerClient;
  SmartHomeDataProvider _smartHomeDataProvider;
  bool _isConnecting = false;
  IotTopicBloc _iotTopicBloc;
  List<IotTopic> _topicList;
  String _currentlySubscribedTopic;

  bool _isLedOn = false;
  bool _isRedLedOn = false;
  bool _isGreenLedOn = false;
  bool _isBlueLedOn = false;
  String _msgRedLedOn = 'red_on';
  String _msgRedLedOff = 'red_off';
  String _msgGreenLedOn = 'green_on';
  String _msgGreenLedOff = 'green_off';
  String _msgBlueLedOn = 'blue_on';
  String _msgBlueLedOff = 'blue_off';
  String _topicLedControl = 'test/leds';
  String _topicLedControlStatus = 'test/leds/status';

  @override
  void initState() {
    super.initState();
    _iotTopicBloc = IotTopicBloc();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    Future.delayed(Duration.zero).then((_) {
      _smartHomeDataProvider.fetchAllTopicsData().then((topicList) {
        _mqttServerClientFuture = _smartHomeDataProvider.connect();
        _topicList = topicList;
        _mqttServerClientFuture.then((client) {
          if (client.connectionStatus.returnCode ==
              MqttConnectReturnCode.connectionAccepted) {
            _mqttServerClient = client;
            _isConnecting = true;
            if (topicList.length > 0) {
              client.subscribe(topicList[0].topic, MqttQos.exactlyOnce);
              _currentlySubscribedTopic = topicList[0].topic;
              _mqttServerClient.subscribe(
                  _topicLedControlStatus, MqttQos.exactlyOnce);

              final builder1 = MqttClientPayloadBuilder();
              builder1.addString('requset_status');
              _mqttServerClient.publishMessage(
                  _topicLedControl, MqttQos.exactlyOnce, builder1.payload);
            }

            showInfoBar('Connected', 'Connected with MQTT broker', context);
          } else {
            showInfoBar('Not Connected', 'Could not connected with MQTT broker',
                context);
            _isConnecting = false;
          }
        });
      });
    });

    _iotTopicBloc.topicController.listen((event) {
      if (_mqttServerClient.connectionStatus.returnCode ==
          MqttConnectReturnCode.connectionAccepted) {
        _mqttServerClient.subscribe(event, MqttQos.exactlyOnce);
        _currentlySubscribedTopic = event;
      }
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
    _smartHomeDataProvider = Provider.of<SmartHomeDataProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 6, true),
                SliverToBoxAdapter(child: _mainContent()),
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 4, false),
              ],
            ),
            Appbar(
              ScreenTitle.SMART_HOME,
              isDesignScreen: true,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _controllContainer(),
                    BottomClipper(ButtonText.BACK, '', goBack, () {},
                        isNextEnabled: false),
                  ],
                )),
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

  Container _mainContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
      child: Column(
        children: [
          _buildConnectionStatusWidget(
              _smartHomeDataProvider.getAppConnectionState),
          SizedBox(
            height: 32.h,
          ),
          _topicList != null && _topicList.length > 0
              ? _getTopicsDropdown(
                  _topicList.map((e) => e.topic).toList(),
                  _iotTopicBloc.topicController,
                  _iotTopicBloc.selectedTopicChanged,
                  false,
                  label: 'Topic')
              : Container(),
          // _buildScrollableTextWith(_smartHomeDataProvider.getHistoryText),
          _buildSensorDataTableHeader(),
          _buildSensorDataTable(_smartHomeDataProvider.sensorDataList),
          SizedBox(
            height: 32.h,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusWidget(
      [MQTTAppConnectionState connectionState]) {
    Color color = Colors.red;
    String status = "";
    switch (connectionState) {
      case MQTTAppConnectionState.connected:
        color = Colors.green;
        status = 'Connected';
        break;
      case MQTTAppConnectionState.connecting:
        color = Colors.yellow;
        status = 'Connecting';
        break;
      case MQTTAppConnectionState.disconnected:
        color = Colors.red;
        status = 'Disconnected';
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(32.w),
                shape: BoxShape.circle,
                color: color,
              ),
              padding: EdgeInsets.all(32.w),
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              textScaleFactor: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  // letterSpacing: 1,
                  color: ColorConstants.TEXT_COLOR),
            )
          ],
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

  Widget _controllContainer() {
    debugPrint('led status is -- ${_smartHomeDataProvider.ledControl}');
    if (_smartHomeDataProvider.ledControl.compareTo("LED is on") == 0)
      _isLedOn = true;
    else
      _isLedOn = false;

    if (_smartHomeDataProvider.ledControl.compareTo(_msgRedLedOn) == 0) {
      _isRedLedOn = true;
    } else if (_smartHomeDataProvider.ledControl.compareTo(_msgGreenLedOn) ==
        0) {
      _isGreenLedOn = true;
    } else if (_smartHomeDataProvider.ledControl.compareTo(_msgBlueLedOn) ==
        0) {
      _isBlueLedOn = true;
    } else if (_smartHomeDataProvider.ledControl.compareTo(_msgRedLedOff) ==
        0) {
      _isRedLedOn = false;
    } else if (_smartHomeDataProvider.ledControl.compareTo(_msgGreenLedOff) ==
        0) {
      _isGreenLedOn = false;
    } else if (_smartHomeDataProvider.ledControl.compareTo(_msgBlueLedOff) ==
        0) {
      _isBlueLedOn = false;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.w),
      ),
      height: 250.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _controlWidgetRgbLed(
              ledStatus: _isRedLedOn,
              onMessage: _msgRedLedOn,
              offMessage: _msgRedLedOff,
              ledColor: Colors.red),
          _controlWidgetRgbLed(
              ledStatus: _isGreenLedOn,
              onMessage: _msgGreenLedOn,
              offMessage: _msgGreenLedOff,
              ledColor: Colors.green),
          _controlWidgetRgbLed(
              ledStatus: _isBlueLedOn,
              onMessage: _msgBlueLedOn,
              offMessage: _msgBlueLedOff,
              ledColor: Colors.blue),
          // _controlWidget(),
        ],
      ),
    );
  }

  Container _controlWidget() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.w),
          // shape: BoxShape.rectangle,
          color: ColorConstants.AVATAR_BKG),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                // send message to all topics
                final builder1 = MqttClientPayloadBuilder();
                // builder1.addInt(1);
                if (_isLedOn) {
                  builder1.addString("0");
                  // _isLedOn = false;
                } else {
                  builder1.addString("1");
                  // _isLedOn = true;
                }
                _mqttServerClient.publishMessage(
                    "test/message", MqttQos.exactlyOnce, builder1.payload,
                    retain: true);
                _mqttServerClient.subscribe(
                    "test/message/status", MqttQos.exactlyOnce);
              },
              child: Container(
                decoration: BoxDecoration(
                  //  borderRadius: BorderRadius.circular(32.w),
                  shape: BoxShape.circle,
                  color: _isLedOn ? Colors.red : Colors.green,
                ),
                padding: EdgeInsets.all(32.w),
                child: Text(
                  _isLedOn ? "OFF" : "ON",
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                _isLedOn ? "Test led is on" : "Test led is off",
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: _isLedOn ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _controlWidgetRgbLed(
      {bool ledStatus, String onMessage, String offMessage, Color ledColor}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.w),
          // shape: BoxShape.rectangle,
          color: ColorConstants.AVATAR_BKG),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                // send message to all topics
                final builder1 = MqttClientPayloadBuilder();
                // builder1.addInt(1);
                if (!ledStatus) {
                  builder1.addString(onMessage);
                  debugPrint('Messge payload $onMessage');
                } else {
                  builder1.addString(offMessage);
                  debugPrint('Messge payload $offMessage');
                }
                if (_smartHomeDataProvider.getAppConnectionState ==
                    MQTTAppConnectionState.connected) {
                  _mqttServerClient.publishMessage(
                      _topicLedControl, MqttQos.exactlyOnce, builder1.payload,
                      retain: false);
                } else {
                  debugPrint('mqttaApp not connected');
                }
              },
              child: Ink(
                child: Container(
                  decoration: BoxDecoration(
                    //  borderRadius: BorderRadius.circular(32.w),
                    shape: BoxShape.circle,
                    color: ledStatus ? Colors.red : Colors.green,
                  ),
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    ledStatus ? "OFF" : "ON",
                    textScaleFactor: 1.25,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                ledStatus ? "Led is on" : "Led is off",
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: ledStatus ? ledColor : ledColor.withOpacity(.25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSensorDataTable(List<SensorData> sensorDataList) {
    return Container(
      // margin: EdgeInsets.all(32.w),
      // height: 600.h,
      child: Table(
        border: TableBorder.all(),
        children: [
          ...sensorDataList
              .map((sensorData) => TableRow(children: [
                    Text(sensorData.roomName,
                        textScaleFactor: 1.1, textAlign: TextAlign.center),
                    Text(sensorData.sensorName,
                        textScaleFactor: 1.1, textAlign: TextAlign.center),
                    Text(sensorData.sensorData,
                        textScaleFactor: 1.1, textAlign: TextAlign.center),
                  ]))
              .toList()
        ],
      ),
    );
  }

  _buildSensorDataTableHeader() {
    return Container(
      margin: EdgeInsets.only(top: 32.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Sensor Data",
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                Text("Room",
                    textScaleFactor: 1.25,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
                Text("Sensor",
                    textScaleFactor: 1.25,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
                Text("Data",
                    textScaleFactor: 1.25,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.ACCESS_MANAGEMENT_TITLE)),
              ])
            ],
          ),
        ],
      ),
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

String parseTopicName(String topic) {
  String topicName = '';
  var topics = topic.split("/");
  if (topics.length >= 2) {
    topicName = topics.last + " ( " + topics.first + " )";
  } else {
    topicName = topic;
  }
  return topicName;
}
