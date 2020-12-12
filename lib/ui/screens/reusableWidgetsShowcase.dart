import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/core/common_widgets/buttons.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/custom_checkbox.dart';
import 'package:ocean_builder/core/common_widgets/flutter_switch.dart';
import 'package:ocean_builder/core/common_widgets/radio_buttons.dart';
import 'package:ocean_builder/core/common_widgets/sliders.dart';

class WidgetShowCase extends StatefulWidget {
  static const String routeName = '/widgetShowCase';
  WidgetShowCase({Key key}) : super(key: key);

  @override
  _WidgetShowCaseState createState() => _WidgetShowCaseState();
}

class _WidgetShowCaseState extends State<WidgetShowCase> {
  bool _isChecked = false;

  bool isPublish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: _widgetTest(),
        ),
      ),
    );
  }

  _widgetTest() {
    RadioData _radioData = new RadioData(labelVals: {
      'radio button 1': 'one',
      'radio button 2': 'two',
      'radio button 3': 'three'
    }, selectedValue: 'one');

    RadioData _radioDataSet2 = new RadioData(labelVals: {
      'radio button 1': 'one',
      'radio button 2': 'two',
    }, selectedValue: 'one');

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      PrimaryButton(
        label: 'Primary Button',
        onPressed: () {},
        isEnabled: true,
        key: Key('primary_button'),
      ),
      PrimaryButton(
        label: 'Primary Button',
        onPressed: () {},
        key: Key('primary_button2'),
      ),
      PrimaryButton(
        label: 'Primary Outlined',
        onPressed: () {},
        isEnabled: true,
        isOutlined: true,
        key: Key('primary_outline_button'),
      ),
      PrimaryButton(
        label: 'Primary Outlined',
        onPressed: () {},
        isOutlined: true,
        key: Key('primary_outline_button2'),
      ),
      PrimaryButton(
        label: 'Primary Destructive',
        onPressed: () {},
        isEnabled: true,
        isDestructive: true,
        key: Key('primary_destructive_button'),
      ),
      PrimaryButton(
        label: 'Primary Destructive',
        onPressed: () {},
        isDestructive: true,
        key: Key('primary_destructive_button2'),
      ),
      PrimaryButton(
        label: 'Primary naked',
        onPressed: () {},
        isEnabled: true,
        isNaked: true,
        key: Key('primary_naked_button'),
      ),
      PrimaryButton(
        label: 'Primary naked',
        onPressed: () {},
        isNaked: true,
        key: Key('primary_naked_button2'),
      ),
      CommonSlider(
        key: Key('common slider'),
        sliderValue: 11.0,
        hasSliderLabel: false,
        onChangedMethod: (value) {
          debugPrint(
              'I wish to print the value from here as a delegate --- $value ');
        },
      ),
      CommonSlider(
        key: Key('common slider 2'),
        sliderValue: 11.0,
        hasSliderLabel: true,
        sliderLabel: 'Slider Label',
        onChangedMethod: (value) {
          debugPrint(
              'I wish to print the value from here as a delegate --- $value');
        },
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        color: Colors.black,
        child: CommonSlider(
          key: Key('common slider 3'),
          sliderValue: 11.0,
          hasSliderLabel: true,
          isDarkBg: true,
          sliderLabel: 'Slider Label',
          onChangedMethod: (value) {
            debugPrint(
                'I wish to print the value from here as a delegate --- $value');
          },
        ),
      ),
      RadioButton(
        radioData: _radioData,
        onChangedMethod: (value) {
          debugPrint('Do whatever .. with the changed group value $value');
        },
      ),
      RadioButton(
        radioData: _radioDataSet2,
        isHorizontallyAlligned: true,
        onChangedMethod: (value) {
          debugPrint('Do whatever .. with the changed group value $value');
        },
      ),
      // Container(
      //   child: CustomCheckbox(
      //       key: Key('cb without title'),
      //       value: _isChecked,
      //       onChanged: (value) {
      //         setState(() {
      //           _isChecked = !_isChecked;
      //         });
      //       }),
      // ),
      CustomCheckbox(value: true, onChanged: (value) {}),
      FlutterSwitch(
        // valueFontSize: 48,
        toggleColor: Colors.white,
        value: isPublish,
        // borderRadius: 24,
        padding: 0.0,
        showOnOff: false,
        activeColor: Colors.green,
        inactiveColor: CommonTheme.greyLighter,
        onToggle: (val) {
          setState(() {
            isPublish = val;
          });
        },
      ),
    ]);
  }

  bool isSelected = false;
}
