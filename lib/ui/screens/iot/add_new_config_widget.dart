import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/bloc/smart_home_config_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/mqtt_setting_item.dart';
import 'package:ocean_builder/core/providers/mqtt_settings_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AddMqttConfig extends StatefulWidget {
  final MqttSettingsItem mqttSettingsItem;
  AddMqttConfig({Key key, this.mqttSettingsItem}) : super(key: key);

  @override
  _AddMqttConfigState createState() => _AddMqttConfigState();
}

class _AddMqttConfigState extends State<AddMqttConfig> {
  SmartHomeConfigBloc _blocSmartHomeConfig;

  TextEditingController _mqttServerController;
  FocusNode _mqttServerNode;
  TextEditingController _mqttPortController;
  FocusNode _mqttPortNode;
  TextEditingController _mqttIdentifierController;
  FocusNode _mqttIdentifierNode;
  TextEditingController _mqttUserController;
  FocusNode _mqttUserNode;
  TextEditingController _mqttPasswordController;
  FocusNode _mqttPasswordNode;
  TextEditingController _mqttTopicController;
  FocusNode _mqttTopicNode;

  MqttSettingsProvider _mqttSettingsProvider;

  MqttSettingsItem _mqttSettingsItem;
  String _topic;
  List<String> _topicList = [];

  GenericBloc<String> _topicBLoc = GenericBloc<String>(null);

  ScrollController _scrollController;

  bool _showAddNewTopicField = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero).then((value) {
    //   _mqttSettingsProvider.getMqttSettings();
    // });

    _topicList.add('Add New Topic');
    _mqttSettingsItem = new MqttSettingsItem.private();
    _scrollController = new ScrollController();
    _blocSmartHomeConfig = SmartHomeConfigBloc();
    _mqttServerController = TextEditingController();
    _mqttServerNode = FocusNode();
    _mqttPortController = TextEditingController();
    _mqttPortNode = FocusNode();
    _mqttIdentifierController = TextEditingController();
    _mqttIdentifierNode = FocusNode();
    _mqttUserController = TextEditingController();
    _mqttUserNode = FocusNode();
    _mqttPasswordController = TextEditingController();
    _mqttPasswordNode = FocusNode();
    _mqttTopicController = TextEditingController();
    _mqttTopicNode = FocusNode();

    if (widget.mqttSettingsItem != null) {
      MqttSettingsItem m = widget.mqttSettingsItem;
      _topicList.addAll(m.mqttTopics.toList());
      _mqttServerController.text = m.mqttServer;
      _mqttPortController.text = m.mqttPort;
      _mqttIdentifierController.text = m.mqttIdentifier;
      _mqttUserController.text = m.mqttUserName;

      _mqttSettingsItem.key = m.key;
      _mqttSettingsItem.mqttServer = m.mqttServer;
      _mqttSettingsItem.mqttPort = m.mqttPort;
      _mqttSettingsItem.mqttIdentifier = m.mqttIdentifier;
      _mqttSettingsItem.mqttUserName = m.mqttUserName;
      _mqttSettingsItem.mqttPassword = m.mqttPassword;
      _mqttSettingsItem.mqttTopics = m.mqttTopics;
    }

    _setListeners();
  }

  @override
  void dispose() {
    _blocSmartHomeConfig.dispose();
    _mqttServerController.dispose();
    _mqttServerNode.dispose();
    _mqttPortController.dispose();
    _mqttPortNode.dispose();
    _mqttIdentifierController.dispose();
    _mqttIdentifierNode.dispose();
    _mqttUserController.dispose();
    _mqttUserNode.dispose();
    _mqttPasswordController.dispose();
    _mqttPasswordNode.dispose();
    _mqttTopicController.dispose();
    _mqttTopicNode.dispose();

    super.dispose();
  }

  _setListeners() {
    _blocSmartHomeConfig.mqttServerController.listen((event) {
      if (event != null) {
        _mqttSettingsItem.mqttServer = event;
      }
    });
    _blocSmartHomeConfig.mqttPortController.listen((event) {
      if (event != null) {
        _mqttSettingsItem.mqttPort = event;
      }
    });
    _blocSmartHomeConfig.mqttIdentifierController.listen((event) {
      if (event != null) {
        _mqttSettingsItem.mqttIdentifier = event;
      }
    });
    _blocSmartHomeConfig.mqttUserController.listen((event) {
      if (event != null) {
        _mqttSettingsItem.mqttUserName = event;
      }
    });
    _blocSmartHomeConfig.mqttPasswordController.listen((event) {
      if (event != null) {
        _mqttSettingsItem.mqttPassword = event;
      }
    });
    _blocSmartHomeConfig.mqttTopicController.listen((event) {
      if (event != null) {
        _topic = event;
      }
    });

    _topicBLoc.controller.listen((event) {
      if (event != null && event.compareTo('Add New Topic') == 0) {
        setState(() {
          if (!_showAddNewTopicField) {
            _showAddNewTopicField = true;
            _mqttTopicNode.requestFocus();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _mqttSettingsProvider = Provider.of<MqttSettingsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.only(
                  top: 80.h,
                  left: 48.w,
                  right: 48.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.nearlyWhite,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _topLabel(),
                  SpaceH48(),
                  UIHelper.getBorderedTextField(
                      context,
                      _blocSmartHomeConfig.mqttServer,
                      _blocSmartHomeConfig.mqttServerChanged,
                      TextFieldHints.MQTT_SERVER,
                      _mqttServerController,
                      InputTypes.TEXT,
                      null,
                      false,
                      TextInputAction.next,
                      _mqttServerNode,
                      null),
                  SpaceH48(),
                  UIHelper.getBorderedTextField(
                      context,
                      _blocSmartHomeConfig.mqttPort,
                      _blocSmartHomeConfig.mqttPortChanged,
                      TextFieldHints.MQTT_PORT,
                      _mqttPortController,
                      InputTypes.NUMBER,
                      null,
                      false,
                      TextInputAction.next,
                      _mqttPortNode,
                      null),
                  SpaceH48(),
                  UIHelper.getBorderedTextField(
                      context,
                      _blocSmartHomeConfig.mqttIdentifier,
                      _blocSmartHomeConfig.mqttIdentifierChanged,
                      TextFieldHints.MQTT_IDENTIFIER,
                      _mqttIdentifierController,
                      InputTypes.TEXT,
                      null,
                      false,
                      TextInputAction.next,
                      _mqttIdentifierNode,
                      null),
                  SpaceH48(),
                  UIHelper.getBorderedTextField(
                      context,
                      _blocSmartHomeConfig.mqttUser,
                      _blocSmartHomeConfig.mqttUserChanged,
                      TextFieldHints.MQTT_USER,
                      _mqttUserController,
                      InputTypes.TEXT,
                      null,
                      false,
                      TextInputAction.next,
                      _mqttUserNode,
                      null),
                  SpaceH48(),
                  UIHelper.getBorderedTextField(
                      context,
                      _blocSmartHomeConfig.mqttPassword,
                      _blocSmartHomeConfig.mqttPasswordChanged,
                      TextFieldHints.MQTT_PASSWORD,
                      _mqttPasswordController,
                      TextInputType.visiblePassword,
                      null,
                      false,
                      TextInputAction.next,
                      _mqttPasswordNode,
                      null

                      //      () {

                      //   _scrollController.animateTo(

                      //       _scrollController.position.maxScrollExtent,

                      //       duration: Duration(milliseconds: 100),

                      //       curve: Curves.easeInOut);

                      // }

                      ),
                  SpaceH48(),
                  _showAddNewTopicField ? _addTopic(context) : Container(),
                  _topicList != null &&
                          _topicList.isNotEmpty &&
                          !_showAddNewTopicField
                      ? _getTopicsDropdown(
                          // model.mqttSettingsList.map((e) {
                          //   MqttSettingsItem m = e;
                          //   return m.mqttServer;
                          // }).toList(),
                          _topicList,
                          _topicBLoc.stream,
                          _topicBLoc.sink,
                          false,
                          label: 'Topics')
                      : Container(),
                  SpaceH64(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: ColorConstants.TOP_CLIPPER_END_DARK,
                          child: Text(
                            widget.mqttSettingsItem == null ? "Save" : "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (widget.mqttSettingsItem == null) {
                              _createMqttSettings();
                            } else {
                              _updateMqttSettings();
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: ColorConstants.TOP_CLIPPER_END_DARK,
                          child: Text(
                            "Reset",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _clearFields();
                          },
                        ),
                      ),
                    ],
                  ),
                  SpaceH32()
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 48.h, right: 12.w),
                      child: Image.asset(
                        ImagePaths.cross,
                        color: ColorConstants.TOP_CLIPPER_END_DARK,
                        width: 48.h,
                        height: 48.h,
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget _addTopic(BuildContext context) {
    return Column(
      children: [
        UIHelper.getBorderedTextField(
            context,
            _blocSmartHomeConfig.mqttTopic,
            _blocSmartHomeConfig.mqttTopicChanged,
            TextFieldHints.MQTT_TOPIC,
            _mqttTopicController,
            InputTypes.TEXT,
            null,
            false,
            TextInputAction.done,
            _mqttTopicNode,
            null),
        SpaceH32(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(_mqttServerNode);
                FocusScope.of(context).unfocus();
                setState(() {
                  _showAddNewTopicField = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: ColorConstants.TOP_CLIPPER_END_DARK
                    border: Border.all(
                        color: ColorConstants.ACCESS_MANAGEMENT_DIVIDER)),
                padding: EdgeInsets.all(8),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: ColorConstants.TOP_CLIPPER_END_DARK,
                      fontSize: 32.sp),
                ),
              ),
            ),
            SpaceW16(),
            InkWell(
              onTap: () {
                // FocusScope.of(context).requestFocus(_mqttServerNode);
                // FocusScope.of(context).unfocus();
                if (_topic != null && _topic.isNotEmpty) {
                  if (!_topicList.contains(_topic)) _topicList.add(_topic);
                  // _topic = null;
                  _mqttTopicController.clear();
                  setState(() {
                    // _showAddNewTopicField = false;
                    _topicBLoc.sink.add(_topic);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: ColorConstants.TOP_CLIPPER_END_DARK
                    border: Border.all(
                        color: ColorConstants.ACCESS_MANAGEMENT_DIVIDER)),
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: ColorConstants.TOP_CLIPPER_END_DARK,
                      fontSize: 32.sp),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void _clearFields() {
    if (widget.mqttSettingsItem != null) {
      MqttSettingsItem m = widget.mqttSettingsItem;
      _mqttServerController.text = m.mqttServer;
      _mqttPortController.text = m.mqttPort;
      _mqttIdentifierController.text = m.mqttIdentifier;
      _mqttUserController.text = m.mqttUserName;

      _mqttSettingsItem.key = m.key;
      _mqttSettingsItem.mqttServer = m.mqttServer;
      _mqttSettingsItem.mqttPort = m.mqttPort;
      _mqttSettingsItem.mqttIdentifier = m.mqttIdentifier;
      _mqttSettingsItem.mqttUserName = m.mqttUserName;
      _mqttSettingsItem.mqttPassword = m.mqttPassword;
      _mqttSettingsItem.mqttTopics = m.mqttTopics;

      setState(() {
        _topicList = [];
        _topicList.add('Add New Topic');
        if (m.mqttTopics != null && m.mqttTopics.length > 0) {
          _topicList.addAll(m.mqttTopics);
          _topicBLoc.sink.add(m.mqttTopics[0]);
        } else {
          _topicBLoc.sink.add('Add New Topic');
        }
      });
    } else {
      _mqttSettingsItem = new MqttSettingsItem.private();
      _mqttServerController.clear();
      _mqttPortController.clear();
      _mqttIdentifierController.clear();
      _mqttUserController.clear();
      _mqttPasswordController.clear();
      _mqttTopicController.clear();

      setState(() {
        _topicList = [];
        _topicList.add('Add New Topic');
        // _topicBLoc.sink.add('Add New Topic');
      });
    }
    // FocusScope.of(context).requestFocus(_mqttServerNode);
  }

  _topLabel() {
    return Row(
      children: [
        Text(
          'MQTT CONFIGURATION',
          style: TextStyle(
              color: ColorConstants.TOP_CLIPPER_END_DARK,
              fontSize: AppTheme.title.fontSize),
        )
      ],
    );
  }

  void _createMqttSettings() {
    // hide keyboard
    // FocusScope.of(context).requestFocus(FocusNode());
    print(_mqttSettingsItem.toString());
    _mqttSettingsItem.mqttTopics = _topicList.skipWhile((topic) {
      return topic == 'Add New Topic';
    }).toList();
    if (_mqttSettingsItem.validate()) {
      print('valideated -------- ${_mqttSettingsItem.toString()}');
      Provider.of<MqttSettingsProvider>(context, listen: false)
          .selectedMqttSettings = _mqttSettingsItem;
      _mqttSettingsProvider.addMqttSettingsItem(_mqttSettingsItem);
      _mqttSettingsProvider.getMqttSettings();
      // _clearFields();
      // Navigator.of(context).pop();
      showInfoBar('Successful', 'New MQTT configuration is Added', context);
    } else {
      print('Invalid settings item');
      showInfoBar('Failed', 'Invalid MQTT configuration', context);
    }
  }

  void _updateMqttSettings() {
    // hide keyboard
    // FocusScope.of(context).requestFocus(FocusNode());
    print(_mqttSettingsItem.toString());
    _mqttSettingsItem.mqttTopics = _topicList.skipWhile((topic) {
      return topic == 'Add New Topic';
    }).toList();
    if (_mqttSettingsItem.validate()) {
      print('valideated -------- ${_mqttSettingsItem.toString()}');
      Provider.of<MqttSettingsProvider>(context, listen: false)
          .selectedMqttSettings = _mqttSettingsItem;

      _mqttSettingsProvider.updateMqttSettingsItem(_mqttSettingsItem);
      _mqttSettingsProvider.getMqttSettings();
      // _clearFields();
      // Navigator.of(context).pop();
      showInfoBar('Successful', 'MQTT configuration is Updated', context);
    } else {
      print('Invalid settings item');
      showInfoBar('Failed', 'Invalid MQTT configuration', context);
    }
  }

  Widget _getTopicsDropdown(
      List<String> list, Observable<String> stream, changed, bool addPadding,
      {String label = 'Label'}) {
    // print('get topic list --- ${list.toString()}');
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          // print('snapshot data ----------------- ${snapshot.data.toString()}');
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
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 96.w,
                        color: snapshot.hasData
                            ? ColorConstants.ACCESS_MANAGEMENT_TITLE
                            : ColorConstants
                                .ACCESS_MANAGEMENT_SUBTITLE //ColorConstants.INVALID_TEXTFIELD,
                        ),
                    value: snapshot.hasData ? snapshot.data : list.first,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  data,
                                  style: AppTheme.body1.apply(
                                      color: ColorConstants
                                          .COLOR_NOTIFICATION_DIVIDER,
                                      fontWeightDelta: 0),
                                ),
                              ),
                              data.compareTo('Add New Topic') != 0 &&
                                      data.compareTo(snapshot.data ?? '') != 0
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          _topicList.remove(data);
                                          _topicBLoc.sink.add('Add New Topic');
                                        });
                                      },
                                      child: const Icon(Icons.delete,
                                          color: ColorConstants
                                              .COLOR_NOTIFICATION_DIVIDER),
                                    )
                                  : Container(),
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
