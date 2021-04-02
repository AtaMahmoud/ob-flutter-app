import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/custom_drawer/appTheme.dart';
import 'package:ocean_builder/ui/shared/popup.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_svg/svg.dart';

import 'dropdown_with_filter.dart';

class UIHelper {
  static getBackLayout(String text,
      {double iconSize = 87.3,
      Color iconColor = Colors.white,
      double textSize = 42,
      textColor = Colors.white,
      bool showText = true,
      IconData icon = Icons.arrow_left}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 16.w,
        ),
        SvgPicture.asset(
          ImagePaths.svgBack,
          width: 38.w,
          height: 46.h,
          color: iconColor,
        ),
        SizedBox(
          width: 24.w,
        ),
        showText
            ? Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    fontSize: textSize.sp),
              )
            : Container()
      ],
    );
  }

  static getNextLayout(String text,
      {bool partiallyTransparent = false,
      double iconSize = 87.3,
      Color iconColor = Colors.white,
      double textSize = 42,
      textColor = Colors.white,
      bool showText = true,
      IconData icon = Icons.arrow_right}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        showText
            ? Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: textSize.sp,
                    color: partiallyTransparent ? Colors.grey : textColor),
              )
            : Container(),
        SizedBox(
          width: 24.w,
        ),
        SvgPicture.asset(
          ImagePaths.svgNext,
          width: 38.w,
          height: 46.h,
          color: partiallyTransparent ? Colors.grey : iconColor,
        ),
        SizedBox(
          width: 16.w,
        ),
      ],
    );
  }

  static getInvertedNextLayout(String text,
      {bool partiallyTransparent = false,
      double iconSize = 30,
      Color iconColor = Colors.white,
      double textSize = 14,
      textColor = Colors.white,
      IconData icon = Icons.arrow_right}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          color: partiallyTransparent ? Colors.grey : iconColor,
          size: iconSize,
        ),
        SizedBox(
          width: 16.w,
        ),
        Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: textSize,
              color: partiallyTransparent ? Colors.grey : textColor),
        ),
      ],
    );
  }

  static getDisabledTextField(String label, TextEditingController controller) {
    return TextField(
      autofocus: false,
      controller: controller,
      enabled: false,
      scrollPadding: EdgeInsets.only(bottom: 241.3.h),
      textDirection: TextDirection.ltr,
      keyboardAppearance: Brightness.light,
      style: TextStyle(
          fontSize: 43.69.sp,
          fontWeight: FontWeight.w400,
          color: ColorConstants.TOP_CLIPPER_START),
      decoration: InputDecoration(
          // hintText: label,
          errorMaxLines: 4,
          contentPadding: EdgeInsets.only(
            top: 16.h,
            bottom: 16.h,
            left: 48.w,
            // right: 32.w
          ),
          // enabledBorder: new UnderlineInputBorder(
          //     borderSide: new BorderSide(
          //         color: ColorConstants.TOP_CLIPPER_START)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.w),
            borderSide: BorderSide(
                color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.w),
            borderSide: BorderSide(
                color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER, width: 1),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 43.69.sp,
              fontWeight: FontWeight.w400,
              color: ColorConstants.TOP_CLIPPER_START),
          hintStyle: TextStyle(
              fontSize: 43.69.sp,
              fontWeight: FontWeight.w400,
              color: ColorConstants.TOP_CLIPPER_START)),
    );
  }

  static Widget getBorderedTextField(
      BuildContext context,
      Stream<String> stream,
      changed,
      String label,
      TextEditingController controller,
      TextInputType inputType,
      int maxLength,
      bool addPadding,
      TextInputAction action,
      FocusNode focusNode,
      VoidCallback callback) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 65.535.w)
                : EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              focusNode: focusNode,
              autofocus: false,
              maxLength: maxLength,
              controller: controller,
              onChanged: changed,
              keyboardType: inputType,
              scrollPadding: EdgeInsets.only(bottom: 241.3.h),
              onEditingComplete:
                  action != TextInputAction.done ? callback : null,
              textInputAction: action,
              textDirection: TextDirection.ltr,
              keyboardAppearance: Brightness.light,
              style: TextStyle(
                  fontSize: 43.69.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.TOP_CLIPPER_START),
              decoration: InputDecoration(
                  hintText: label,
                  errorMaxLines: 4,
                  errorText: snapshot.error,
                  helperText: snapshot.error,
                  contentPadding: EdgeInsets.only(
                    top: 16.h,
                    bottom: 16.h,
                    left: 48.w,
                    // right: 32.w
                  ),
                  // enabledBorder: new UnderlineInputBorder(
                  //     borderSide: new BorderSide(
                  //         color: ColorConstants.TOP_CLIPPER_START)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.w),
                    borderSide: BorderSide(
                        color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                        width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.w),
                    borderSide: BorderSide(
                        color: ColorConstants.ACCESS_MANAGEMENT_INPUT_BORDER,
                        width: 1),
                  ),
                  labelText: label,
                  hintStyle: TextStyle(
                      fontSize: 43.69.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.INVALID_TEXTFIELD)),
            ),
          );
        });
  }

  static Widget getRegistrationTextField(
      BuildContext context,
      Stream<String> stream,
      changed,
      String label,
      TextEditingController controller,
      TextInputType inputType,
      int maxLength,
      bool addPadding,
      TextInputAction action,
      FocusNode focusNode,
      VoidCallback callback,
      {bool addContentPadding = false}) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 65.535.w)
                : EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              focusNode: focusNode,
              autofocus: false,
              maxLength: maxLength,
              controller: controller,
              onChanged: changed,
              keyboardType: inputType,
              scrollPadding: EdgeInsets.only(bottom: 241.3.h),
              onEditingComplete:
                  action != TextInputAction.done ? callback : null,
              textInputAction: action,
              textDirection: TextDirection.ltr,
              keyboardAppearance: Brightness.light,
              style: TextStyle(
                  fontSize: 43.69.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.TOP_CLIPPER_START),
              decoration: InputDecoration(
                  hintText: label,
                  errorMaxLines: 4,
                  errorText: snapshot.error,
                  helperText: snapshot.error,
                  contentPadding:
                      EdgeInsets.only(left: addContentPadding ? 48.w : 0),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: ColorConstants.TOP_CLIPPER_START)),
                  hintStyle: TextStyle(
                      fontSize: 43.69.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.INVALID_TEXTFIELD)),
            ),
          );
        });
  }

  static Widget getPasswordTextField(
      BuildContext context,
      Stream<String> stream,
      Stream<bool> showStream,
      String label,
      TextEditingController controller,
      TextInputType inputType,
      int maxLength,
      bool addPadding,
      TextInputAction action,
      FocusNode node,
      VoidCallback stringCallback(String data),
      VoidCallback callback(bool show),
      VoidCallback onCompleteCallback,
      {bool shorErrorText = true}) {
    return StreamBuilder<bool>(
      stream: showStream,
      builder: (context, snap) {
        return snap.hasData
            ? StreamBuilder<String>(
                stream: stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: addPadding
                        ? EdgeInsets.symmetric(horizontal: 65.535.w)
                        : EdgeInsets.symmetric(horizontal: 0),
                    child: Stack(
                      children: <Widget>[
                        TextField(
                          autofocus: false,
                          focusNode: node,
                          maxLength: maxLength,
                          onEditingComplete: onCompleteCallback,
                          controller: controller,
                          onChanged: (str) => stringCallback(str),
                          keyboardType: inputType,
                          obscureText: !snap.data,
                          textInputAction: action,
                          scrollPadding: EdgeInsets.only(bottom: 241.3.h),
                          keyboardAppearance: Brightness.light,
                          style: TextStyle(
                              fontSize: 43.69.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.TOP_CLIPPER_START),
                          decoration: InputDecoration(
                              hintText: label,
                              errorMaxLines: 16,
                              errorText: shorErrorText ? snapshot.error : '',
                              errorStyle: TextStyle(color: Colors.red),
                              suffixIcon: IconButton(
                                onPressed: () => callback(!snap.data),
                                icon: Icon(Icons.remove_red_eye,
                                    color:
                                        snap.data ? Colors.blue : Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstants.TOP_CLIPPER_START)),
                              hintStyle: TextStyle(
                                  fontSize: 43.69.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.INVALID_TEXTFIELD)),
                        ),
                      ],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  static Widget getRegistrationDropdown(
      List<String> list, Stream<String> stream, changed, bool addPadding) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 24.w)
                : EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
              width: double.maxFinite,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 98.3.w,
                      color: snapshot.hasData
                          ? ColorConstants.TOP_CLIPPER_START
                          : ColorConstants.INVALID_TEXTFIELD,
                    ),
                    value: snapshot.hasData ? snapshot.data : list[0],
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(
                        color: snapshot.hasData
                            ? ColorConstants.TOP_CLIPPER_START
                            : ColorConstants.INVALID_TEXTFIELD,
                        fontSize: 43.69.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                        wordSpacing: 4),
                    onChanged: changed,
                    items: list.map((data) {
                      return DropdownMenuItem(value: data, child: Text(data));
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Widget getUnderlinedDropdown(
      List<String> list, Stream<String> stream, changed, bool addPadding) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 24.w)
                : EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
              width: double.maxFinite,
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 98.30.w,
                    color: snapshot.hasData
                        ? ColorConstants.TOP_CLIPPER_START
                        : ColorConstants.INVALID_TEXTFIELD,
                  ),
                  value: snapshot.hasData ? snapshot.data : list[0],
                  isExpanded: true,
                  isDense: false,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorConstants.TOP_CLIPPER_START,
                              width: 1)),
                      contentPadding: EdgeInsets.only(left: 0, bottom: 0)),
                  // underline: Container(
                  //     color: ColorConstants.TOP_CLIPPER_START, height: 2.h),
                  style: TextStyle(
                      color: snapshot.hasData
                          ? ColorConstants.TOP_CLIPPER_START
                          : ColorConstants.INVALID_TEXTFIELD,
                      fontSize: 43.69.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                      wordSpacing: 4),
                  onChanged: changed,
                  items: list.map((data) {
                    return DropdownMenuItem(value: data, child: Text(data));
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }

  static Widget getCountryDropdown(
      List<String> list, Stream<String> stream, changed, bool addPadding) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 65.535.w)
                : EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
              width: double.maxFinite,
              child: InkWell(
                onTap: () {
                  PopUpHelpers.showPopup(
                    context,
                    FilterDropDown(
                      list: list,
                      changed: changed,
                    ),
                    'SELECT A COUNTRY',
                    paddingTop: 96.h,
                    paddingBottom: 96.h,
                    paddingLeft: 96.w,
                    paddingright: 96.w,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      snapshot.hasData ? snapshot.data : 'SELECT A COUNTRY',
                      style: TextStyle(
                          color: snapshot.hasData
                              ? ColorConstants.TOP_CLIPPER_START
                              : ColorConstants.INVALID_TEXTFIELD,
                          fontSize: 43.69.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.2,
                          wordSpacing: 4),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 98.30.w,
                      color: snapshot.hasData
                          ? ColorConstants.TOP_CLIPPER_START
                          : ColorConstants.INVALID_TEXTFIELD,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Widget getProfileOBUnitPhone(
      BuildContext context,
      String title,
      Stream<String> stream,
      changed,
      TextEditingController controller,
      TextInputType inputType,
      bool includePadding,
      FocusNode node,
      FocusNode nextNode,
      {maxLength = 50}) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        controller: controller,
                        onChanged: changed,
                        keyboardType: inputType,
                        keyboardAppearance: Brightness.light,
                        textAlign: TextAlign.end,
                        scrollPadding: EdgeInsets.only(bottom: 100),
                        textInputAction: nextNode != null
                            ? TextInputAction.next
                            : TextInputAction.done,
                        focusNode: node,
                        onEditingComplete: () => nextNode != null
                            ? FocusScope.of(context).requestFocus(nextNode)
                            : FocusScope.of(context).unfocus(),
                        // decoration: InputDecoration.collapsed(hintText: null),
                        decoration: InputDecoration(
                          hintText: null,
                          errorMaxLines: 2,
                          errorText: snapshot.error,
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors
                                      .transparent //ColorConstants.TOP_CLIPPER_START
                                  )),
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors
                                      .transparent //ColorConstants.TOP_CLIPPER_START
                                  )),
                          errorBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors
                                      .transparent //ColorConstants.TOP_CLIPPER_START
                                  )),
                          focusedErrorBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors
                                      .transparent //ColorConstants.TOP_CLIPPER_START
                                  )),
                          hintStyle: TextStyle(
                              fontSize: 43.69.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.INVALID_TEXTFIELD),
                          errorStyle: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        style: TextStyle(
                          fontSize: 40.9599.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(maxLength),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width - 54,
                  height: 1,
                  color: Colors.white70,
                )
              ],
            ),
          );
        });
  }

  static Widget getProfileOBUnit(
      BuildContext context,
      String title,
      Stream<String> stream,
      changed,
      TextEditingController controller,
      TextInputType inputType,
      bool includePadding,
      FocusNode node,
      FocusNode nextNode,
      {maxLength = 50}) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          autofocus: false,
                          controller: controller,
                          onChanged: changed,
                          keyboardType: inputType,
                          keyboardAppearance: Brightness.light,
                          textAlign: TextAlign.start,
                          scrollPadding: EdgeInsets.only(bottom: 100),
                          textInputAction: nextNode != null
                              ? TextInputAction.next
                              : TextInputAction.done,
                          focusNode: node,
                          onEditingComplete: () => nextNode != null
                              ? FocusScope.of(context).requestFocus(nextNode)
                              : FocusScope.of(context).unfocus(),
                          // decoration: InputDecoration.collapsed(hintText: null),
                          decoration: InputDecoration(
                            hintText: null,
                            errorMaxLines: 2,
                            errorText: snapshot.error,
                            enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors
                                        .transparent //ColorConstants.TOP_CLIPPER_START
                                    )),
                            focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors
                                        .transparent //ColorConstants.TOP_CLIPPER_START
                                    )),
                            errorBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors
                                        .transparent //ColorConstants.TOP_CLIPPER_START
                                    )),
                            focusedErrorBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors
                                        .transparent //ColorConstants.TOP_CLIPPER_START
                                    )),
                            hintStyle: TextStyle(
                                fontSize: 43.69.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.INVALID_TEXTFIELD),
                            errorStyle: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                          style: TextStyle(
                            fontSize: 40.9599.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(maxLength),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width - 54,
                  height: 1,
                  color: Colors.white70,
                )
              ],
            ),
          );
        });
  }

  static Widget getProfileEmergencyUnit(
      BuildContext context,
      String hint,
      Stream<String> stream,
      changed,
      TextEditingController controller,
      TextInputType inputType,
      bool includePadding,
      FocusNode node,
      FocusNode nextNode) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: false,
                  controller: controller,
                  onChanged: changed,
                  keyboardType: inputType,
                  keyboardAppearance: Brightness.light,
                  scrollPadding: EdgeInsets.only(bottom: 100),
                  textInputAction: nextNode != null
                      ? TextInputAction.next
                      : TextInputAction.done,
                  focusNode: node,
                  onEditingComplete: () => nextNode != null
                      ? FocusScope.of(context).requestFocus(nextNode)
                      : FocusScope.of(context).unfocus(),
                  decoration: InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width - 54,
                  height: 1,
                  color: Colors.white70,
                )
              ],
            ),
          );
        });
  }

  static Widget getImageTextColumn(
      String path, String text, double height, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: <Widget>[
          Image.asset(path, height: height, width: height),
          SizedBox(height: 16.0),
          Text(
            text,
            style: TextStyle(
                color: ColorConstants.TOP_CLIPPER_START, fontSize: 20),
          )
        ],
      ),
    );
  }

  static Widget getButton(String text, VoidCallback callback,
      {double w = 200,
      double h = 60,
      double fontSize = 22,
      bool isInactive = false,
      String iconPath,
      gradientColors = const [Color(0xFF01388B), Color(0xFF2C86AC)],
      double borderRadius = 24}) {
    return InkWell(
      onTap: callback,
      child: Container(
        // height: h,
        width: w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(borderRadius.w),
          gradient: isInactive
              ? LinearGradient(colors: [
                  ColorConstants.CONTROL_END,
                  ColorConstants.CONTROL_END
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              : LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            iconPath != null
                ? ImageIcon(
                    AssetImage(iconPath),
                    color: Colors.white,
                  )
                : Container(),
            iconPath != null ? SizedBox(width: 16.w) : Container(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ],
        )),
      ),
    );
  }

  static Widget getQRCodeButton(String text, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 60,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          gradient: LinearGradient(colors: [
            ColorConstants.TOP_CLIPPER_START,
            ColorConstants.TOP_CLIPPER_END
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        )),
      ),
    );
  }

  static Widget getCustomRadioButtonVertical(Stream<String> stream, String text,
      {String price = ''}) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          bool isSelected = snapshot.data == text;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 65.5.w,
                height: 65.5.w,
                decoration: BoxDecoration(
                    color: isSelected
                        ? ColorConstants.TOP_CLIPPER_END
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: ColorConstants.TOP_CLIPPER_END, width: 5.46.w)),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 43.7.w)
                    : Container(),
              ),
              SizedBox(height: 19.3103448.h),
              Text(
                '$text$price',
                style: TextStyle(
                    fontSize: 49.15.sp,
                    color: ColorConstants.TOP_CLIPPER_START),
              )
            ],
          );
        });
  }

  static Widget getCustomRadioButtonHorizontal(
      Stream<String> stream, String text, String price,
      {String subtitle}) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          bool isSelected = snapshot.data == text;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 65.5.w,
                height: 65.5.w,
                decoration: BoxDecoration(
                    color: isSelected
                        ? ColorConstants.TOP_CLIPPER_END
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstants.TOP_CLIPPER_END,
                      width: 5.46.w,
                    )),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 43.7.sp)
                    : Container(),
              ),
              SizedBox(width: 19.3103448.h),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 49.15.sp,
                          color: ColorConstants.TOP_CLIPPER_START),
                    ),
                    subtitle != null
                        ? Text(
                            subtitle,
                            style: TextStyle(
                                fontSize: 49.15.sp,
                                color: ColorConstants.TOP_CLIPPER_END),
                          )
                        : Container()
                  ],
                ),
              ),
              SizedBox(width: 19.3103448.w),
              Expanded(
                flex: 2,
                child: Text(
                  price,
                  style: TextStyle(
                      fontSize: 49.15.sp,
                      color: ColorConstants.TOP_CLIPPER_START),
                ),
              ),
            ],
          );
        });
  }

  static Widget getCustomCheckbox(
      Stream<List<String>> stream, String text, String price,
      {bool isVertical = false, String subtitle}) {
    return StreamBuilder<List<String>>(
        stream: stream,
        builder: (context, snapshot) {
          bool isSelected = snapshot.data?.contains(text) ?? false;
          return isVertical
              ? Column(
                  children: <Widget>[
                    Container(
                      width: 65.5.w,
                      height: 65.5.w,
                      decoration: BoxDecoration(
                          color: isSelected
                              ? ColorConstants.TOP_CLIPPER_END
                              : Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: ColorConstants.TOP_CLIPPER_END,
                              width: 5.46.w)),
                      child: isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 43.7.w)
                          : Container(),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 49.15.sp,
                          color: ColorConstants.TOP_CLIPPER_START),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                          fontSize: 49.15.sp,
                          color: ColorConstants.TOP_CLIPPER_START),
                    ),
                    SizedBox(height: 38.62.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 43.69.w),
                      child: Text(
                        subtitle ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 49.15.sp,
                            color: ColorConstants.TOP_CLIPPER_END),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 65.5.w,
                      height: 65.5.w,
                      decoration: BoxDecoration(
                          color: isSelected
                              ? ColorConstants.TOP_CLIPPER_END
                              : Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                              color: ColorConstants.TOP_CLIPPER_END,
                              width: 5.46.w)),
                      child: isSelected
                          ? Icon(Icons.check,
                              size: 43.69.w, color: Colors.white)
                          : Container(),
                    ),
                    SizedBox(width: 19.3103448.w),
                    Expanded(
                        flex: 7,
                        child: Text(
                          text,
                          style: TextStyle(
                              fontSize: 49.15.sp,
                              color: ColorConstants.TOP_CLIPPER_START),
                        )),
                    SizedBox(width: 19.3103448.h),
                    Expanded(
                      flex: 2,
                      child: Text(
                        price,
                        style: TextStyle(
                            fontSize: 49.15.sp,
                            color: ColorConstants.TOP_CLIPPER_START),
                      ),
                    ),
                  ],
                );
        });
  }

  static Widget getSliverGridColor(Stream<int> maxCountStream,
      Stream<int> colorStream, VoidCallback callback(int data)) {
    return StreamBuilder<int>(
      stream: maxCountStream,
      builder: (context, snap) {
        return StreamBuilder<int>(
            stream: colorStream,
            builder: (context, snapshot) {
              return snap.hasData
                  ? SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                return callback(ListHelper.colorList()[index]);
                              },
                              child: Container(
                                height: 10,
                                color: Color(ListHelper.colorList()[index]),
                                child: snapshot.data ==
                                        ListHelper.colorList()[index]
                                    ? Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                              ),
                            );
                          },
                          childCount: snap.data,
                        ),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100.0,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 2,
                        ),
                      ),
                    )
                  : SliverPadding(padding: EdgeInsets.all(0.0));
            });
      },
    );
  }

  static getTopEmptyContainer(double height, bool showBackgroundColor) {
    return SliverToBoxAdapter(
      child: Container(
        height: height,
        color: showBackgroundColor
            ? ColorConstants.CLIPPER_BACKGROUND
            : Colors.transparent,
      ),
    );
  }

  static getTopEmptyContainerWithColor(double height, Color backgroundColor) {
    return SliverToBoxAdapter(
      child: Container(
        height: height,
        color: backgroundColor,
      ),
    );
  }

  static getImageContainer(double height, double width) {
    return Container(
      height: height,
      width: width,
      child:
          Image.asset(ImagePaths.containerBackgroundImage, fit: BoxFit.cover),
    );
  }

  static getTitleSubtitleWidget(String title, String message,
      {double subTitlePadding = 0.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  color: ColorConstants.TOP_CLIPPER_START,
                  fontWeight: FontWeight.w500,
                  fontSize: 43.69.sp)),
          SizedBox(height: 4.0),
          Padding(
            padding: EdgeInsets.only(left: subTitlePadding),
            child: Text(message,
                style: TextStyle(
                    color: ColorConstants.TOP_CLIPPER_END, fontSize: 43.69.sp)),
          )
        ],
      ),
    );
  }

  static Widget imageTextColumn(String imagePath, String text,
      {double textSize = 32}) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          imagePath,
          color: ColorConstants.SVG_ICON_COLOR,
          width: 196.w,
          height: 196.w,
        ),
        SizedBox(height: 32.h),
        Text(
          text,
          style: TextStyle(
              color: ColorConstants.TEXT_COLOR, fontSize: textSize.sp),
        ),
      ],
    );
  }

  static customDecoration(double width, double radius, Color borderColor,
      {Color bkgColor = Colors.white}) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        shape: BoxShape.rectangle,
        border: Border.all(color: borderColor, width: width),
        color: bkgColor);
  }

  static double statusBarHeight;

  static setStatusBarColor({Color color}) async {
    Color _color = color != null ? color : ColorConstants.TOP_CLIPPER_START;

    await FlutterStatusbarcolor.setStatusBarColor(_color);
    if (useWhiteForeground(_color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }

    // await FlutterStatusbarManager.setColor(_color, animated:true);

    //   statusBarHeight = await FlutterStatusbarManager.getHeight;

    //   await FlutterStatusbarManager.setHidden(true, animation:StatusBarAnimation.SLIDE);
  }

  static defaultSliverAppbar(_scaffoldKey, goBack,
      {screnTitle, isDrawer = true}) {
    return SliverAppBar(
      title: //_topAppBarContent(),
          Text(
        screnTitle,
        style: TextStyle(
            color: ColorConstants.WEATHER_MORE_ICON_COLOR,
            fontSize: 60.sp,
            fontWeight: FontWeight.w400),
      ),
      centerTitle: false,
      leading: isDrawer //_leadingDrawerButton(),
          ? IconButton(
              icon: //Icon(Icons.close),
                  ImageIcon(
                AssetImage(ImagePaths.icHamburger),
                color: Color(0xFF3A5A98),
              ),
              tooltip: 'Drawer',
              onPressed: () {
                // handle the press
                if (_scaffoldKey != null)
                  _scaffoldKey.currentState.openDrawer();
              },
              color: ColorConstants.TOP_CLIPPER_END_DARK,
            )
          : Container(),
      backgroundColor: AppTheme.nearlyWhite,
      pinned: true,
      iconTheme: IconThemeData(color: ColorConstants.TOP_CLIPPER_END_DARK),
      actions: <Widget>[
        // _topBarBackButton()
        IconButton(
          icon: Icon(Icons.close),
          tooltip: 'Back',
          onPressed: goBack,
          color: ColorConstants.TOP_CLIPPER_END_DARK,
          iconSize: 72.sp,
        ),
      ],
    );
  }

  static sourceSelectorButtons(dynamic stream, dynamic onTap) {
    return StreamBuilder<String>(
      stream: stream,
      initialData:
          ApplicationStatics.selectedWeatherProvider.compareTo('external') == 0
              ? 'external'
              : 'local',
      builder: (context, snapshot) {
        // debugPrint('sourceSelectorButtons ---------- ${snapshot.data} ');
        List<Widget> list = [
          Column(
            children: <Widget>[
              SvgPicture.asset(
                ImagePaths.svgSourceExternal,
                height: 40.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text('External',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                  ))
            ],
          ),
          Column(
            children: <Widget>[
              SvgPicture.asset(
                ImagePaths.svgSourceLocalDisc,
                height: 40.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text('Local',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                  ))
            ],
          )
        ];
        return InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(
                  top: 12.h, bottom: 12.h, left: 48.w, right: 48.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64.w),
                color: ColorConstants.WEATHER_TEMP_CIRCLE,
              ),
              child: Row(
                children: <Widget>[
                  snapshot.data.compareTo('external') == 0 ? list[0] : list[1],
                  SizedBox(
                    width: 32.w,
                  ),
                  snapshot.data.compareTo('external') == 0 ? list[1] : list[0],
                ],
              ),
            ));
      },
    );
  }
}
