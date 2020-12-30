import 'package:flutter/material.dart';
import 'package:ocean_builder/core/colorpicker/flutter_hsvcolor_picker.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class ColorPickerModal extends StatefulWidget {
  ColorPickerModal({Key key}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPickerModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      // color: CommonTheme.greyLightest,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CommonTheme.primaryLightest,
      ),
      child: _colorPickerWidget(),
    );
  }

  _colorPickerWidget() {
    // // debugPrint('Color picker widget rebuilding');
    return ColorPicker(
      color: Color(0xffffed27), //Color(0xFF2741D3),
      onChanged: (value) {
        debugPrint('Selected color -- ' + value.toString().substring(6, 16));
        setState(() {});
      },
      // onLightSwitchChanged: (value) {
      //   _onLightSwitchChanged();
      // },
    );
  }
}
