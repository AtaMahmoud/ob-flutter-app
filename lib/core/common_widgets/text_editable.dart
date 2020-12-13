import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:rxdart/rxdart.dart';

class TextEditable extends StatefulWidget {
  TextEditable(
      {Key key,
      this.stream,
      this.title,
      this.textChanged,
      this.controller,
      this.inputType,
      this.node,
      this.nextNode,
      this.maxLength,
      this.isEnabled,
      this.isDense,
      this.hasValue,
      this.hasHelperText,
      this.helperText,
      this.placeHolder,
      this.value,
      this.hasLabel,
      this.hasPlaceHolder,
      this.hasPadding})
      : super(key: key);

  final Observable<String> stream;
  final Function textChanged;
  final String title;
  final String placeHolder; // hint text
  final String value;
  final String helperText;
  final TextEditingController controller;
  final TextInputType inputType;
  final FocusNode node;
  final FocusNode nextNode;
  final bool isEnabled;
  final bool isDense;
  final bool hasValue;
  final bool hasLabel;
  final bool hasPlaceHolder; // hintText
  final bool hasHelperText;
  final bool hasPadding;
  final int maxLength;

  @override
  _TextEditableState createState() => _TextEditableState();
}

class _TextEditableState extends State<TextEditable> {
  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.value;
    return Container(
      child: _getEditText(
          stream: widget.stream,
          changed: widget.textChanged,
          label: widget.title,
          helperText: widget.helperText,
          placeHolder: widget.placeHolder,
          controller: widget.controller,
          inputType: widget.inputType,
          focusNode: widget.node,
          nextNode: widget.nextNode,
          isEnabled: widget.isEnabled,
          isDense: widget.isDense,
          hasLabel: widget.hasLabel,
          hasPlaceHolder: widget.hasPlaceHolder,
          hasValue: widget.hasValue,
          hasHelperText: widget.hasHelperText,
          hasPadding: widget.hasPadding,
          maxLength: widget.maxLength),
    );
  }

  Widget _getEditText(
      {Observable<String> stream,
      Function changed,
      String label,
      String helperText,
      String placeHolder,
      TextEditingController controller,
      TextInputType inputType = TextInputType.text,
      FocusNode focusNode,
      FocusNode nextNode,
      bool isEnabled = true,
      bool isDense = true,
      bool hasValue = true,
      bool hasLabel = true,
      bool hasPlaceHolder = true,
      bool hasHelperText = true,
      bool hasPadding = false,
      int maxLength = 50}) {
    return StreamBuilder<String>(
        stream: widget.stream,
        builder: (context, snapshot) {
          return Padding(
            padding: hasPadding
                ? EdgeInsets.symmetric(horizontal: 24)
                : EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              enabled: isEnabled,
              autofocus: false,
              controller: controller,
              onChanged: (text) {
                changed.call(text);
                // DEFINE YOUR RULES HERE
              },
              keyboardType: inputType,
              keyboardAppearance: Brightness.light,
              textAlign: TextAlign.start,
              scrollPadding: EdgeInsets.only(bottom: 100),
              textInputAction: nextNode != null
                  ? TextInputAction.next
                  : TextInputAction.done,
              focusNode: focusNode,
              onEditingComplete: () => nextNode != null
                  ? FocusScope.of(context).requestFocus(nextNode)
                  : FocusScope.of(context).unfocus(),
              // decoration: InputDecoration.collapsed(hintText: null),
              decoration: InputDecoration(
                  labelText: hasLabel ? '$label' : null,
                  labelStyle: TextStyle(
                      color: isEnabled
                          ? CommonTheme.primary
                          : CommonTheme.greyDark),
                  hintText: hasPlaceHolder ? '$placeHolder' : null,
                  hintStyle: TextStyle(
                      color:
                          isEnabled ? CommonTheme.greyDark : CommonTheme.grey),
                  helperText: snapshot.hasError
                      ? snapshot.error
                      : hasHelperText ? '$helperText' : null,
                  helperStyle: TextStyle(color: CommonTheme.greyDark),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                    borderSide: new BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonTheme.primary),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CommonTheme.grey),
                  ),
                  fillColor:
                      isEnabled ? CommonTheme.greyLightest : CommonTheme.white,
                  errorMaxLines: 4,
                  errorText: snapshot.error,
                  suffix: isEnabled
                      ? snapshot.hasError ? ErrorIcon(true) : ErrorIcon(false)
                      : DisableIcon(true)
                  // suffixIcon:

                  // enabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: CommonTheme.primaryLighter),
                  // ),
                  // contentPadding:
                  //     EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                  //fillColor: Colors.green
                  // border: UnderlineInputBorder(
                  //   borderSide: BorderSide.none,
                  // ),
                  // disabledBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide.none,
                  // ),
                  // suffixIcon: SvgPicture.asset(
                  //   ImagePaths.svgEdit,
                  //   fit: BoxFit.scaleDown,
                  //   color: CommonTheme.primaryLighter,
                  // ),
                  ),
              style: TextStyle(
                // fontSize: 32,
                fontWeight: FontWeight.w400,
                color: isEnabled ? CommonTheme.black : CommonTheme.grey,
              ),
              inputFormatters: [
                new LengthLimitingTextInputFormatter(maxLength),
              ],
            ),
          );
        });
  }
}

class ErrorIcon extends StatelessWidget {
  bool _isError;

  ErrorIcon(this._isError);

  bool get isError => _isError;

  @override
  Widget build(BuildContext context) {
    Widget out;

    debugPrint("Rebuilding ErrorWidget");
    isError
        ? out = new ImageIcon(
            AssetImage(ImagePaths.icEditError),
            color: Color(CommonTheme.danger.value),
          )
        : out = new Icon(null);

    return out;
  }
}

class DisableIcon extends StatelessWidget {
  bool _isDisable;

  DisableIcon(this._isDisable);

  bool get isError => _isDisable;

  @override
  Widget build(BuildContext context) {
    Widget out;

    debugPrint("Rebuilding DisabledWidget");
    isError
        ? out = new ImageIcon(
            AssetImage(ImagePaths.icEditDisable),
            color: Color(CommonTheme.grey.value),
          )
        : out = new Icon(null);

    return out;
  }
}
