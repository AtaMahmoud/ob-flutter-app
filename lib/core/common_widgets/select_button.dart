import 'package:flutter/material.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/disable_icon.dart';
import 'package:ocean_builder/core/common_widgets/error_icon.dart';
import 'package:rxdart/rxdart.dart';

class SelectButton extends StatefulWidget {
  /// create material textfield  button styled Select Button
  /// add generic bloc of type SelectItem and list of SelectItem
  const SelectButton({
    Key? key,
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
  final Observable<SelectItem>? stream;
  final List<SelectItem>? list;
  final Function? changed;
  final bool? addPadding;
  final String? label;
  final String? helperText;
  final String? placeHolder;
  final bool? hasLabel;
  final bool? hasPlaceHolder;
  final bool? hasHelperText;
  final bool? isEnabled;

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getDropdown(widget.list!, widget.stream!, widget.changed,
          widget.addPadding!, widget.label!),
    );
  }

  Widget _getDropdown(List<SelectItem> list, Observable<SelectItem> stream,
      changed, bool addPadding, String label) {
    return StreamBuilder<SelectItem>(
        stream: stream,
        // initialData: widget.list[0],

        builder: (context, snapshot) {
          return Padding(
            padding: addPadding
                ? EdgeInsets.symmetric(horizontal: 24)
                : EdgeInsets.symmetric(horizontal: 0),
            child: widget.isEnabled!
                ? _dropdownOutlined(snapshot, changed, list)
                : _wrapperWithinputDecoration(label, snapshot, changed,
                    list), //_dropdown(snapshot, changed, list)
          );
        });
  }

  InputDecorator _wrapperWithinputDecoration(String label,
      AsyncSnapshot<SelectItem> snapshot, changed, List<SelectItem> list) {
    return InputDecorator(
      decoration: InputDecoration(
          enabled: widget.isEnabled!,
          // hasFloatingPlaceholder: true,
          // alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
          fillColor:
              widget.isEnabled! ? CommonTheme.greyLightest : CommonTheme.white,
          // borders
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: new BorderSide(width: 2),
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
          // label,placeholder,helper and error text
          labelText: widget.hasLabel! ? '$label' : null,
          labelStyle: CommonTheme.tsBodyExtraSmall.apply(
              color: widget.isEnabled!
                  ? CommonTheme.primary
                  : CommonTheme.greyDark),
          hintText: widget.hasPlaceHolder! ? '${widget.placeHolder}' : null,
          hintStyle: CommonTheme.tsBodyDefault.apply(
              color:
                  widget.isEnabled! ? CommonTheme.greyDark : CommonTheme.grey),
          helperText: snapshot.hasError
              ? snapshot.error.toString()
              : widget.hasHelperText!
                  ? '${widget.helperText}'
                  : '',
          helperStyle:
              CommonTheme.tsBodyExtraSmall.apply(color: CommonTheme.greyDark),
          errorMaxLines: 4,
          errorText: snapshot.error.toString(),
          // suffix icon
          suffix: widget.isEnabled!
              ? snapshot.hasError
                  ? ErrorIcon(true)
                  : ErrorIcon(false)
              : DisableIcon(true)),
      child: _dropdown(snapshot, changed, list),
    );
  }

  DropdownButtonHideUnderline _dropdown(
      AsyncSnapshot<SelectItem> snapshot, changed, List<SelectItem> list) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<SelectItem>(
          autofocus: false,
          hint: Text(
            widget.placeHolder!,
            style: CommonTheme.tsBodySmall,
          ),
          isDense: true,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 32,
            color: widget.isEnabled!
                ? snapshot.hasData
                    ? CommonTheme.primary
                    : CommonTheme.grey
                : CommonTheme.grey,
          ),
          value: snapshot.data, // snapshot.hasData ? snapshot.data : list[0],
          isExpanded: true,
          underline: Container(),
          style: TextStyle(
            color:
                snapshot.hasData ? CommonTheme.primaryLight : CommonTheme.grey,
            fontSize: 32,
            fontWeight: FontWeight.w400,
            // letterSpacing: 1.2,
            // wordSpacing: 4
          ),
          onChanged: widget.isEnabled! ? changed : null,
          items: list.map((data) {
            return DropdownMenuItem(
                value: data,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      data.option!,
                      style: CommonTheme.tsBodyDefault.apply(
                          color: widget.isEnabled!
                              ? CommonTheme.greyDark
                              : CommonTheme.grey),
                    ),
                  ],
                ));
          }).toList(),
        ),
      ),
    );
  }

  DropdownButtonFormField _dropdownOutlined(
      AsyncSnapshot<SelectItem> snapshot, changed, List<SelectItem> list) {
    var inputDecoration = InputDecoration(
      filled: true,
      // label,placeholder,helper and error text
      labelText: widget.hasLabel!
          ? snapshot.hasData
              ? '${widget.label}'
              : ''
          : null,
      labelStyle: CommonTheme.tsBodyExtraSmall.apply(
          color:
              widget.isEnabled! ? CommonTheme.primary : CommonTheme.greyDark),
      hintText: widget.hasPlaceHolder! ? '${widget.placeHolder}' : null,
      hintStyle: CommonTheme.tsBodyDefault.apply(
          color: widget.isEnabled! ? CommonTheme.greyDark : CommonTheme.grey),
      helperText: snapshot.hasError
          ? snapshot.error.toString()
          : widget.hasHelperText!
              ? snapshot.hasData
                  ? snapshot.data!.helpText
                  : '${widget.helperText}'
              : null,
      helperStyle:
          CommonTheme.tsBodyExtraSmall.apply(color: CommonTheme.greyDark),

      errorMaxLines: 4,
      errorText: snapshot.error.toString(),
      // suffix icon
      suffix: widget.isEnabled!
          ? snapshot.hasError
              ? ErrorIcon(true)
              : ErrorIcon(false)
          : DisableIcon(true),

      border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(8.0),
        borderSide: new BorderSide(width: 2),
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
      enabled: widget.isEnabled!,
      // hasFloatingPlaceholder: true,
      alignLabelWithHint: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 16,
      ),
      fillColor:
          widget.isEnabled! ? CommonTheme.greyLightest : CommonTheme.white,
    );
    var menuItems = list.map((data) {
      return DropdownMenuItem(
          value: data,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                data.option!,
                style: CommonTheme.tsBodyDefault.apply(
                    color: widget.isEnabled!
                        ? CommonTheme.greyDark
                        : CommonTheme.grey),
              ),
            ],
          ));
    });
    return DropdownButtonFormField<SelectItem>(
      value: snapshot.hasData ? snapshot.data : null,
      decoration: inputDecoration,
      items: menuItems.toList(),
      onChanged: widget.isEnabled! ? changed : null,
    );
  }
}

/// create model for selcet button data;
/// needed for showing help text for individual options and a placeholder/hintext for the select button
class SelectItem {
  String? option;
  String? helpText;
  SelectItem({this.option, this.helpText});
}
