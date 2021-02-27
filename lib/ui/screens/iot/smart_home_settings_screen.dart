import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/mqtt_setting_item.dart';
import 'package:ocean_builder/core/providers/mqtt_settings_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/screens/iot/add_new_config_widget.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
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
  MqttSettingsProvider _mqttSettingsProvider;
  List<String> _topicList;
  GenericBloc<MqttSettingsItem> _iotServerBloc;

  TextEditingController _portController;
  TextEditingController _indentifierController;
  TextEditingController _userController;
  TextEditingController _topicController;

  final MqttSettingsItem _selectForDetails =
      MqttSettingsItem('Select One For Details', '-', '-', '-', '_', []);

  MqttSettingsItem _selectedServer;

  var _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _iotServerBloc = GenericBloc<MqttSettingsItem>(null);
    _portController = TextEditingController();
    _indentifierController = TextEditingController();
    _userController = TextEditingController();
    _topicController = TextEditingController();

    Future.delayed(Duration.zero).then((value) {
      _mqttSettingsProvider.getMqttSettings();
    });

    _iotServerBloc.controller.listen((event) {
      if (event != null &&
          event.mqttServer.compareTo('Select One For Details') != 0) {
        _selectedServer = event;
        setState(() {
          _setFields(event);
        });
      } else {
        setState(() {
          _clearFields();
        });
      }
    });
  }

  void _setFields(MqttSettingsItem event) {
    _portController.text = event.mqttPort;
    _indentifierController.text = event.mqttIdentifier;
    _userController.text = event.mqttUserName;
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;
    _mqttSettingsProvider = Provider.of<MqttSettingsProvider>(context);
    // _mqttSettingsProvider.getMqttSettings();

    // _smartHomeDataProvider = Provider.of<SmartHomeDataProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.BKG_GRADIENT),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                UIHelper.getTopEmptyContainer(
                    MediaQuery.of(context).size.height / 5, true),

                SliverToBoxAdapter(
                  child: _mqttConfigExapnder(),
                ),
                // SliverToBoxAdapter(child: _mainContent()),
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

  _mqttConfigExapnder() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
              width: 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 48.h, left: 8.w, right: 8.w),
      child: Center(
        child: Theme(
          child: ExpansionTile(
            trailing: Icon(
              _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 128.w,
              color: ColorConstants.TOP_CLIPPER_START,
            ),
            title: Text(
              'MQTT SETTINGS',
              style: TextStyle(
                  fontSize: 43.69.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.TOP_CLIPPER_START,
                  letterSpacing: 1.3),
            ),
            children: [_mainContent()],
            onExpansionChanged: (value) {
              setState(() {
                _isExpanded = value;
              });
            },
          ),
          data: ThemeData(dividerColor: Colors.transparent),
        ),
      ),
    );

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.only(
    //         top: 16.h,
    //         bottom: 16.h,
    //         left: 48.w,
    //       ),
    //       child: Text(
    //         'MQTT SETTINGS',
    //         style: TextStyle(
    //             fontSize: 43.69.sp,
    //             fontWeight: FontWeight.w400,
    //             color: ColorConstants.TOP_CLIPPER_START),
    //       ),
    //     ),
    //   ],
    // );
  }

  Consumer _mainContent() {
    return Consumer<MqttSettingsProvider>(builder: (context, model, widget) {
      // print('mqttsettings item ------------ ${model.mqttSettingsList.length}');
      if (model.mqttSettingsList != null) {
        List<MqttSettingsItem> _listITems = //[]; // ['1', '2'];

            model.mqttSettingsList.map((e) => e as MqttSettingsItem).toList();
        // MqttSettingsItem m = new MqttSettingsItem.private();
        // m.mqttServer = 'Select One For Details';
        // _listITems.add(m);
        _listITems.add(_selectForDetails);
        print('_list items are ${_listITems.toString()}');
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
          child: Column(
            children: [
              /*           _buildConnectionStatusWidget(
                      _smartHomeDataProvider.getAppConnectionState), */
              SpaceH128(),
              model.mqttSettingsList != null &&
                      model.mqttSettingsList.length > 0
                  ? _getTopicsDropdown(
                      // model.mqttSettingsList.map((e) {
                      //   MqttSettingsItem m = e;
                      //   return m.mqttServer;
                      // }).toList(),
                      _listITems,
                      _iotServerBloc.stream,
                      _iotServerBloc.sink,
                      false,
                      label: 'Server Address')
                  : _buttonAddNewConfig(context, 'ADD NEW MQTT CONFIGURATION',
                      _newConfigurationPopUp), //Container(),
              // _buildScrollableTextWith(_smartHomeDataProvider.getHistoryText),
              /* _buildSensorDataTableHeader(),
                  _buildSensorDataTable(_smartHomeDataProvider.sensorDataList), */
              SpaceH48(),
              // UIHelper.getDisabledTextField("PORT", _portController),
              // SpaceH48(),
              // UIHelper.getDisabledTextField(
              //     "IDENTIFIER", _indentifierController),
              // SpaceH48(),
              // UIHelper.getDisabledTextField("USER", _userController),
              // SpaceH48(),
              // // UIHelper.getDisabledTextField("Topic", _topicController),
              // _getTopicChips(),
              ..._selectedServer != null ? _getServerDetails() : [Container()],
              _selectedServer != null ? _editSettingsRow() : Container(),
              SpaceH48(),
              _buttonAddNewConfig(context, 'ADD NEW MQTT CONFIGURATION',
                  _newConfigurationPopUp),
              SpaceH48()
            ],
          ),
        );
      }
      return Container();
    });
  }

  _editSettingsRow() {
    return Padding(
      padding: EdgeInsets.only(top: 32.h, bottom: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (_selectedServer != null) {
                _editConfigurationPopUp(_selectedServer);
              }
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset(ImagePaths.svgEdit),
                SizedBox(
                  width: 12.w,
                ),
                Text(
                  'EDIT SETTINGS',
                  style: TextStyle(
                      fontSize: 48.sp,
                      color: ColorConstants.COLOR_NOTIFICATION_ITEM),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getServerDetails() {
    return [
      UIHelper.getDisabledTextField("PORT", _portController),
      SpaceH48(),
      UIHelper.getDisabledTextField("IDENTIFIER", _indentifierController),
      SpaceH48(),
      UIHelper.getDisabledTextField("USER", _userController),
      SpaceH48(),
      // UIHelper.getDisabledTextField("Topic", _topicController),
      _getTopicChips(),
    ];
  }

  Widget _getTopicChips() {
    return _selectedServer != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.h,
                      bottom: 16.h,
                      left: 48.w,
                    ),
                    child: Text(
                      'TOPICS',
                      style: TextStyle(
                          fontSize: 43.69.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.TOP_CLIPPER_START),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.only(
                  top: 16.h,
                  bottom: 16.h,
                  left: 48.w,
                ),
                child: Row(
                  children: [
                    Wrap(
                      runAlignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: _selectedServer != null &&
                              _selectedServer.mqttTopics.isNotEmpty
                          ? _selectedServer.mqttTopics.map((topic) {
                              return Chip(
                                  label: Text(
                                topic ?? 'No Topic',
                              ));
                            }).toList()
                          : [Container()],
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _getTopicsDropdown(List<MqttSettingsItem> list,
      Observable<MqttSettingsItem> stream, changed, bool addPadding,
      {String label = 'Label'}) {
    print('get topic list --- ${list.toString()}');
    return StreamBuilder<MqttSettingsItem>(
        stream: stream,
        builder: (context, snapshot) {
          print('snapshot data ----------------- ${snapshot.data.toString()}');
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 48.w)
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
                labelText: label.toUpperCase(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // hintStyle: TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                    fontSize: 43.69.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.TOP_CLIPPER_START),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<MqttSettingsItem>(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 96.w,
                        color: snapshot.hasData
                            ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                            : ColorConstants
                                .ACCESS_MANAGEMENT_SUBTITLE //ColorConstants.INVALID_TEXTFIELD,
                        ),
                    value:
                        snapshot.hasData ? snapshot.data : list.reversed.first,
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                      color: snapshot.hasData
                          ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                          : ColorConstants
                              .ACCESS_MANAGEMENT_SUBTITLE, //ColorConstants.INVALID_TEXTFIELD,
                      fontSize: 40.sp,
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
                              Text(data.mqttServer),
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

  Widget _buttonAddNewConfig(
      BuildContext context, String label, Function onTap) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // height: h,
          // width: MediaQuery.of(context).size.width - 72.w,
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(48.w),
              color: ColorConstants.TOP_CLIPPER_END_DARK),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ADD NEW MQTT CONFIGURATION',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 36.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _newConfigurationPopUp() {
    return Navigator.push(
      context,
      PopupLayout(
        top: 128.h,
        left: 48.w,
        right: 48.w,
        bottom: 32.h,
        child: AddMqttConfig(),
      ),
    );
  }

  _editConfigurationPopUp(MqttSettingsItem mqttSettingsItem) {
    return Navigator.push(
      context,
      PopupLayout(
        top: 128.h,
        left: 48.w,
        right: 48.w,
        bottom: 32.h,
        child: AddMqttConfig(
          mqttSettingsItem: mqttSettingsItem,
        ),
      ),
    );
  }

  _popUpContent() {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(24),
      //   // color: AppTheme.nearlyWhite,
      // ),
      padding: EdgeInsets.all(8),
      // height: 300,
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

  void _clearFields() {
    _portController.clear();
    _indentifierController.clear();
    _userController.clear();
    _selectedServer = null;
  }
}
