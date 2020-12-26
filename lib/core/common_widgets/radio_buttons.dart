import 'package:flutter/material.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class RadioButton extends StatefulWidget {
  /// customized radio button group with title
  ///
  /// set [RadioData] with label,values pairs [onChangedMethod] to pass callback method
  ///
  /// use [isHorizontallyAlligned] to align the items horizontally
  RadioButton(
      {this.radioData, this.isHorizontallyAlligned, this.onChangedMethod, key})
      : super(key: key);

  final RadioData? radioData;
  final bool? isHorizontallyAlligned;
  final Function? onChangedMethod;

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  String? _groupValue;
  @override
  Widget build(BuildContext context) {
    var _dataMap = widget.radioData?.labelVals;
    return Container(
        child: widget.isHorizontallyAlligned != null &&
                widget.isHorizontallyAlligned!
            ? Row(
                children: [
                  ..._dataMap!.keys
                      .map((k) => _radioButtonHorizontal(k, _dataMap[k]!))
                ],
              )
            : Column(
                children: [
                  ..._dataMap!.keys
                      .map((k) => _radioButtonHorizontal(k, _dataMap[k]!))
                ],
              ));
  }

  _radioButtonHorizontal(String label, String val, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          visualDensity: VisualDensity.comfortable,
          toggleable: true,
          value: val,
          groupValue: _groupValue,
          onChanged: (String? value) {
            setState(() {
              _groupValue = value;
            });
            widget.onChangedMethod?.call(value);
          },
          activeColor: CommonTheme.primary,
          hoverColor: CommonTheme.primaryLight,
        ),
        Text(label,
            style: CommonTheme.tsBodyDefault.apply(
                color:
                    val == _groupValue ? Colors.black : CommonTheme.greyDark)),
      ],
    );
  }
}

class RadioData {
  // radio button label and value
  Map<String, String>? labelVals;
  // currently selected value aka group value
  String? selectedValue;

  RadioData({this.labelVals, this.selectedValue});
}
