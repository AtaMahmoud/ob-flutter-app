import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/core/common_widgets/buttons.dart';
import 'package:ocean_builder/core/common_widgets/sliders.dart';

class WidgetShowCase extends StatefulWidget {
  static const String routeName = '/widgetShowCase';
  WidgetShowCase({Key key}) : super(key: key);

  @override
  _WidgetShowCaseState createState() => _WidgetShowCaseState();
}

class _WidgetShowCaseState extends State<WidgetShowCase> {
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
      )
    ]);
  }
}
