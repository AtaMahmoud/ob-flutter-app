import 'package:flutter/material.dart';
import 'package:ocean_builder/bloc/generic_bloc.dart';
import 'package:ocean_builder/core/colorpicker/flutter_hsvcolor_picker.dart';
import 'package:ocean_builder/core/common_widgets/buttons.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/text_editable.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';

class ColorPickerModal extends StatefulWidget {
  ColorPickerModal({Key key}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPickerModal> {
  TextEditingController _colorNameController;
  GenericBloc<String> _blocColorName;

  @override
  void initState() {
    super.initState();
    _colorNameController = TextEditingController();
    _blocColorName = GenericBloc.private();
  }

  @override
  void dispose() {
    _colorNameController.dispose();
    _blocColorName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        // color: CommonTheme.greyLightest,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CommonTheme.primaryLightest,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              TextEditable(
                stream: _blocColorName.stream,
                textChanged: _blocColorName.changed,
                controller: _colorNameController,
                title: 'New Color Name',
                placeHolder: 'Color name',
                hasHelperText: false,
                hasPadding: false,
                hasPlaceHolder: true,
                hasLabel: true,
                isEnabled: true,
              ),
              SpaceV24(),
              _colorPickerHeader(),
              _colorPickerWidget(),
              SpaceV24(),
              _bottomButtons(),
            ],
          ),
        ));
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

  _bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          isDestructive: false,
          isEnabled: true,
          isNaked: false,
          isOutlined: true,
          label: 'Cancel',
          onPressed: () {
            print('Cancel button pressed');
            Navigator.pop(context);
          },
        ),
        SpaceW16(),
        PrimaryButton(
          isDestructive: false,
          isEnabled: true,
          isNaked: false,
          isOutlined: false,
          label: 'Save',
          onPressed: () {
            print('save button pressed');
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _colorPickerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SpaceW32(),
        Text(
          'Manage Colors',
          style: CommonTheme.tsBodyDefault.apply(color: CommonTheme.primary),
        ),
      ],
    );
  }
}
