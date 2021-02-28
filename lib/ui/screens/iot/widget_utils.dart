import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/mqtt_setting_item.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/ui/screens/iot/add_new_config_widget.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:rxdart/rxdart.dart';

Widget getServerDropdown(List<MqttSettingsItem> list,
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
                  value: snapshot.hasData ? snapshot.data : list.reversed.first,
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

newConfigurationPopUp() {
  return Navigator.push(
    locator<NavigationService>().navigatorKey.currentContext,
    PopupLayout(
      top: 128.h,
      left: 48.w,
      right: 48.w,
      bottom: 32.h,
      child: AddMqttConfig(),
    ),
  );
}
