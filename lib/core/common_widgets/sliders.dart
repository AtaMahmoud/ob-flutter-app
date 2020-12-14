import 'package:flutter/material.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class CommonSlider extends StatefulWidget {
  /// comon sliders
  ///
  /// [sliderValue] and [onChangedMethod] are required
  ///
  /// to enable on dark bg use [isDarkBg]
  ///
  /// to show or hide label and value information use [hasSliderLabel]
  ///
  const CommonSlider(
      {@required this.sliderValue,
      this.sliderLabel,
      @required this.onChangedMethod,
      this.hasSliderLabel,
      this.isDarkBg,
      key})
      : super(key: key);

  final String sliderLabel;
  final bool isDarkBg;
  final bool hasSliderLabel;
  final double sliderValue;
  final Function onChangedMethod;

  @override
  _CommonSliderState createState() => _CommonSliderState();
}

class _CommonSliderState extends State<CommonSlider> {
  double _sliderValue = 0.0;
  Color _activeTrackColor,
      _inactiveTrackColor,
      _thumbColor,
      _labelColor,
      _valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _sliderNative(),
    );
  }

  _sliderNative() {
    if (widget.isDarkBg != null && widget.isDarkBg) {
      _activeTrackColor = CommonTheme.primaryLighter;
      _inactiveTrackColor = CommonTheme.primaryDark;
      _thumbColor = CommonTheme.primaryLight;
      _labelColor = CommonTheme.grey;
      _valueColor = CommonTheme.primaryLight;
    } else {
      _activeTrackColor = CommonTheme.primaryLight;
      _inactiveTrackColor = CommonTheme.primaryLightest;
      _thumbColor = CommonTheme.primary;
      _labelColor = CommonTheme.greyDark;
      _valueColor = CommonTheme.primary;
    }
    return Stack(
      children: <Widget>[
        _slider(),
        widget.hasSliderLabel != null && widget.hasSliderLabel
            ? _sliderLabels()
            : Container()
      ],
    );
  }

  SliderTheme _slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: _activeTrackColor,
        inactiveTrackColor: _inactiveTrackColor,
        thumbColor: _thumbColor,
      ),
      child: Slider(
          min: 0.0,
          max: 100.0,
          divisions: 100,
          value: _sliderValue,
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
              widget.onChangedMethod.call(value);
            });
          }),
    );
  }

  Align _sliderLabels() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.sliderLabel ?? ' '}',
              style: CommonTheme.tsBodySmall.apply(color: _labelColor),
            ),
            Text(
              '${_sliderValue.toInt() ?? ' '}%',
              style: CommonTheme.tsBodySmall.apply(color: _valueColor),
            ),
          ],
        ),
      ),
    );
  }
}
