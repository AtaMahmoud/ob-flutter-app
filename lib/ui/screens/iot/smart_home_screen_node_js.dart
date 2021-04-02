import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/bloc/iot_topic_bloc.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/providers/design_data_provider.dart';
import 'package:ocean_builder/core/providers/smart_home_data_provider.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper.dart';
import 'package:ocean_builder/ui/cleeper_ui/bottom_clipper_2.dart';
import 'package:ocean_builder/ui/screens/designSteps/exterior_finish_screen.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class SmartHomeScreenNodeServer extends StatefulWidget {
  static const String routeName = '/smart_home_node';

  @override
  _SmartHomeScreenNodeServerState createState() =>
      _SmartHomeScreenNodeServerState();
}

class _SmartHomeScreenNodeServerState extends State<SmartHomeScreenNodeServer> {
  Future<List<IotEventData>> _allSensorData;
  Future<List<IotEventData>> _sensorDataById;
  Future<List<IotEventData>> _sensorDataBetweenDates;

  List<IotTopic> _topicList;
  IotTopicBloc _iotTopicBloc;
  bool _isLoading = true;

  String _fromDateTime;
  String _toDateTime;
  String _selectedTopic;

  GenericBloc<String> _fromDateTimeBloc;
  GenericBloc<String> _toDateTimeBloc;

  @override
  void initState() {
    super.initState();
    UIHelper.setStatusBarColor(color: ColorConstants.TOP_CLIPPER_START_DARK);
    _iotTopicBloc = IotTopicBloc();
    _fromDateTimeBloc = GenericBloc("");
    _toDateTimeBloc = GenericBloc("");
    Future.delayed(Duration.zero).then((_) {
      // _allSensorData =
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
      _selectedTopic = topic;
      if (_fromDateTime != null &&
          _fromDateTime.length > 0 &&
          _toDateTime != null &&
          _toDateTime.length > 0 &&
          topic != null &&
          topic.length > 1) {
        _sensorDataBetweenDates = Provider.of<SmartHomeDataProvider>(context)
            .fetchSensorDataBetweenDates(topic, _fromDateTime, _toDateTime);
      } else if (topic != null && topic.length > 1) {
        _sensorDataById = Provider.of<SmartHomeDataProvider>(context)
            .fetchSensorDataByTopic(topic);
      }
    });

    _fromDateTimeBloc.controller.listen((dateTime) {
      _fromDateTime = dateTime;
      if (_fromDateTime != null &&
          _fromDateTime.length > 0 &&
          _selectedTopic != null &&
          _selectedTopic.length > 0) {
        _iotTopicBloc.selectedTopicChanged(_selectedTopic);
      }
    });

    _toDateTimeBloc.controller.listen((dateTime) {
      _toDateTime = dateTime;
      if (_toDateTime != null &&
          _toDateTime.length > 0 &&
          _selectedTopic != null &&
          _selectedTopic.length > 0) {
        _iotTopicBloc.selectedTopicChanged(_selectedTopic);
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
                          child: _dateTimePickerRow(
                              'Start Date', _fromDateTimeBloc, true),
                        ),
                        SliverToBoxAdapter(
                          child: SpaceH32(),
                        ),
                        SliverToBoxAdapter(
                          child: _dateTimePickerRow(
                              'End Date', _toDateTimeBloc, false),
                        ),
                        SliverToBoxAdapter(
                          child: SpaceH32(),
                        ),
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
                        SliverToBoxAdapter(
                          child: SpaceH32(),
                        ),
                        _clearDateFilter(),
                        SliverToBoxAdapter(
                          child: SpaceH32(),
                        ),
                        FutureBuilder<List<IotEventData>>(
                            future: _allSensorData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child:
                                      _buildHeader('Fetching all sensor data'),
                                );
                              }

                              if (snapshot.hasData) {
                                return _sensorDataList(
                                    snapshot.data, 'All Sensor Data');
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
                                  child: _buildHeader(
                                      'Fetching Sensor Data By Topic'),
                                );
                              }

                              if (snapshot.hasData) {
                                return _sensorDataList(
                                    snapshot.data, 'Sensor Data By Topic');
                              }

                              return SliverToBoxAdapter(
                                child: Container(),
                              );
                            }),
                        FutureBuilder<List<IotEventData>>(
                            future: _sensorDataBetweenDates,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SliverToBoxAdapter(
                                  child: _buildHeader(
                                      'Fetching Sensor Data Between Dates'),
                                );
                              }

                              if (snapshot.hasData) {
                                return _sensorDataList(
                                    snapshot.data, 'Sensor Data Between Dates');
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

  _clearDateFilter() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              _fromDateTimeBloc.controller.add('');
              _toDateTimeBloc.controller.add('');
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.w),
                  border: Border.all(
                      color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER)),
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Clear Filters',
                style: TextStyle(color: ColorConstants.ACCESS_MANAGEMENT_TITLE),
                // textScaleFactor: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              _parseTimeStamp(sensorDataList[index].tiemStamp.toString()));
        }, childCount: sensorDataList.length),
      ),
    );
  }

  _parseTimeStamp(String timeStamp) {
    // dd/MM/yy\nH:m:s:
    return new DateFormat.yMd().add_jm().format(DateTime.parse(timeStamp));
  }

  Widget _buildHeader(String text) {
    return new Container(
      color: AppTheme.chipBackground,
      padding: EdgeInsets.only(top: 16.h),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _sensorTableTitle(text),
          SizedBox(
            height: 16.h,
          ),
          _tableRow('Room', 'Sensor', 'Data', 'Time', isDataRow: false)
        ],
      ),
    );
  }

  Align _sensorTableTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.5,
        style: TextStyle(
            color: ColorConstants.ACCESS_MANAGEMENT_LIST_TITLE,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _tableRow(String col1, String col2, String col3, String col4,
      {bool isDataRow = true}) {
    double _textScaleFactor = isDataRow ? 1.1 : 1.25;
    Color _textColor =
        isDataRow ? Colors.black : ColorConstants.ACCESS_MANAGEMENT_TITLE;
    FontWeight _fontWeight = isDataRow ? FontWeight.normal : FontWeight.w800;
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Center(
            child: Text(col1,
                textScaleFactor: _textScaleFactor,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: _fontWeight,
                  color: _textColor,
                )),
          ),
          Center(
            child: Text(col2,
                textScaleFactor: _textScaleFactor,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: _fontWeight, color: _textColor)),
          ),
          Center(
            child: Text(col3,
                textScaleFactor: _textScaleFactor,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: _fontWeight, color: _textColor)),
          ),
          Center(
            child: Text(col4,
                textScaleFactor: _textScaleFactor,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: _fontWeight, color: _textColor)),
          ),
        ])
      ],
    );
  }

  goBack() {
    Navigator.pop(context);
  }

  Widget _getTopicsDropdown(
      List<String> list, Stream<String> stream, changed, bool addPadding,
      {String label = 'Label'}) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
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
                labelText: label,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // hintStyle: TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                    color: ColorConstants.ACCESS_MANAGEMENT_TITLE,
                    fontSize: 48.sp),
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
                      fontSize: 40.sp,
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

  Widget _dateTimePickerRow(String label, GenericBloc bloc, bool isStartDate) {
    var _pickedDate = isStartDate ? _fromDateTime : _toDateTime;
    debugPrint('_pickDate ---- $_pickedDate');
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: ColorConstants.ACCESS_MANAGEMENT_BUTTON)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: SizedBox(
          width: double.maxFinite,
          child: InkWell(
            onTap: () {
              _invokeDateTimePicker(bloc);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${label.toUpperCase()}: ',
                  style: TextStyle(
                      fontSize: 43.69.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.TOP_CLIPPER_START),
                ),
                Text(
                  _pickedDate == null || _pickedDate.length == 0
                      ? 'Tap to change'
                      : _pickedDate, //DateFormat('yMMMMd').format(_pickedDate),
                  style: TextStyle(
                      fontSize: 43.69.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.TOP_CLIPPER_START),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _invokeDateTimePicker(GenericBloc bloc) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        // minTime: DateTime.now(),
        //DateTime(2018, 3, 5),
        // maxTime: DateTime(2019, 12, 7),
        theme: DatePickerTheme(
            backgroundColor: Colors.white, //ColorConstants.PROFILE_BKG_1,
            // containerHeight: ScreenUtil().setHeight(512),
            cancelStyle: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstants.TOP_CLIPPER_START),
            itemStyle: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.w400,
                color: ColorConstants.TOP_CLIPPER_START),
            doneStyle: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstants.TOP_CLIPPER_START)), onChanged: (date) {
      // // print('change $date in time zone ' +
      // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      print('picked ${date.toUtc().toIso8601String()}');
      setState(() {
        bloc.controller.add(date.toUtc().toIso8601String());
        // bloc.controller.add(DateFormat('yMMMMd').format(date));
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
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
