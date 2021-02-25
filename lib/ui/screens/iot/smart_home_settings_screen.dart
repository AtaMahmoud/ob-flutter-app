import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/mqtt_settings_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/iot/add_new_config_widget.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MqttSettingsScreen extends StatefulWidget {
  static const String routeName = '/mqttSettingsScreen';
  MqttSettingsScreen({Key key}) : super(key: key);

  @override
  _MqttSettingsScreenState createState() => _MqttSettingsScreenState();
}

class _MqttSettingsScreenState extends State<MqttSettingsScreen> {
  List<String> _topicList;
  GenericBloc<String> _iotTopicBloc;

  MqttSettingsProvider _mqttSettingsProvider;

  @override
  void initState() {
    super.initState();
    _iotTopicBloc = GenericBloc<String>('');
    Future.delayed(Duration.zero).then((value) {
      _mqttSettingsProvider.getMqttSettings();
      _topicList = _mqttSettingsProvider.mqttSettingsList;
      // _topicList.add('Add New');
    });

    _iotTopicBloc.controller.listen((event) {
      String topic = event;
      print('topic');
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _mqttSettingsProvider = Provider.of<MqttSettingsProvider>(context);
    // _smartHomeDataProvider = Provider.of<SmartHomeDataProvider>(context);
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
              ScreenTitle.SMART_HOME_SETTINGS,
              isDesignScreen: true,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // _controllContainer(),
                    BottomClipper(ButtonText.BACK, '', goBack, () {},
                        isNextEnabled: false),
                  ],
                )),
            // _isConnecting
            //     ? Container()
            //     : Center(
            //         child: CircularProgressIndicator(),
            //       )
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
/*           _buildConnectionStatusWidget(
              _smartHomeDataProvider.getAppConnectionState), */
          SizedBox(
            height: 64.h,
          ),
          _topicList != null && _topicList.length > 0
              ? _getTopicsDropdown(_topicList.map((e) => e).toList(),
                  _iotTopicBloc.stream, _iotTopicBloc.sink, false,
                  label: 'Topic')
              : _buttonAddNewConfig(context), //Container(),
          // _buildScrollableTextWith(_smartHomeDataProvider.getHistoryText),
          /* _buildSensorDataTableHeader(),
          _buildSensorDataTable(_smartHomeDataProvider.sensorDataList), */
          SizedBox(
            height: 32.h,
          ),
        ],
      ),
    );
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
                    onChanged: changed.add,
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

  Row _buttonAddNewConfig(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            // Navigator.of(context).pushNamed(ManagePermissionScreen.routeName);
            _newConfigurationPopUp();
          },
          child: Container(
            // height: h,
            width: MediaQuery.of(context).size.width - 72.w,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(72.w),
                color: ColorConstants.TOP_CLIPPER_END_DARK),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add New Mqtt Configuration',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 36.sp),
                ),
              ],
            )),
          ),
        )
      ],
    );
  }

  _newConfigurationPopUp() {
    return Navigator.push(
      context,
      PopupLayout(
        top: 32.h,
        left: 48.w,
        right: 48.w,
        bottom: 32.h,
        child: _popUpContent(),
      ),
    );
  }

  _popUpContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppTheme.nearlyWhite,
      ),
      padding: EdgeInsets.all(8),
      child: _addNewConfigurationWidget(),
    );
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

  goBack() {
    Navigator.pop(context);
  }

  _addNewConfigurationWidget() {
    return Container(child: AddMqttConfig());
  }
}
