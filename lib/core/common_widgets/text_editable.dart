import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/disable_icon.dart';
import 'package:ocean_builder/core/common_widgets/error_icon.dart';
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
                      : DisableIcon(true)),
              style: CommonTheme.tsBodyDefault.apply(
                  color: isEnabled ? CommonTheme.black : CommonTheme.grey),
              inputFormatters: [
                new LengthLimitingTextInputFormatter(maxLength),
              ],
            ),
          );
        });
  }
}
