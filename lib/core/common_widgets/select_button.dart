import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/disable_icon.dart';
import 'package:ocean_builder/core/common_widgets/error_icon.dart';
import 'package:rxdart/rxdart.dart';

class SelectButton extends StatelessWidget {
  const SelectButton({
    Key key,
    this.stream,
    this.list,
    this.changed,
    this.addPadding,
    this.label,
    this.isEnabled,
    this.helperText,
    this.placeHolder,
    this.hasLabel,
    this.hasPlaceHolder,
    this.hasHelperText,
  }) : super(key: key);
  final Observable<String> stream;
  final List<String> list;
  final Function changed;
  final bool addPadding;
  final String label;
  final String helperText;
  final String placeHolder;
  final bool hasLabel;
  final bool hasPlaceHolder;
  final bool hasHelperText;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getDropdown(list, stream, changed, addPadding, label),
    );
  }

  Widget _getDropdown(List<String> list, Observable<String> stream, changed,
      bool addPadding, String label) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 24)
                : EdgeInsets.symmetric(horizontal: 0),
            child: InputDecorator(
              decoration: InputDecoration(
                  enabled: isEnabled,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                    borderSide: new BorderSide(width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonTheme.primaryLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonTheme.primary),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonTheme.grey),
                  ),
                  contentPadding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
                  // alignLabelWithHint: true,
                  fillColor:
                      isEnabled ? CommonTheme.greyLightest : CommonTheme.white,
                  labelText: hasLabel ? '$label' : null,
                  labelStyle: CommonTheme.tsBodyExtraSmall.apply(
                      color: isEnabled
                          ? CommonTheme.primary
                          : CommonTheme.greyDark),
                  hintText: hasPlaceHolder ? '$placeHolder' : null,
                  hintStyle: CommonTheme.tsBodyDefault.apply(
                      color:
                          isEnabled ? CommonTheme.greyDark : CommonTheme.grey),
                  helperText: snapshot.hasError
                      ? snapshot.error
                      : hasHelperText ? '$helperText' : null,
                  helperStyle: CommonTheme.tsBodyExtraSmall
                      .apply(color: CommonTheme.greyDark),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorMaxLines: 4,
                  errorText: snapshot.error,
                  suffix: isEnabled
                      ? snapshot.hasError ? ErrorIcon(true) : ErrorIcon(false)
                      : DisableIcon(true)),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down,
                        size: 32,
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
                      fontSize: 32,
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
                              Text(
                                data,
                                style: CommonTheme.tsBodyDefault.apply(
                                    color: isEnabled
                                        ? CommonTheme.greyDark
                                        : CommonTheme.grey),
                              ),
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
