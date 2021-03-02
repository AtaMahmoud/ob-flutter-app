import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:rxdart/rxdart.dart';

Widget getDropdown(
    List<String> list, Observable<String> stream, changed, bool addPadding,
    {String label = 'Label', bool isEnabled = true}) {
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
                  onChanged: isEnabled ? changed : null,
                  disabledHint: Text(
                    snapshot.hasData ? snapshot.data : list[0],
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
                  ),
                  items: list.map((data) {
                    return DropdownMenuItem(
                        value: data,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(data),
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
