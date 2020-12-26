import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

/*
This class serves the following types of buttons
  - primary
  - primary outlined
  - destructive
  - naked
  To change or tweak the color  check common_theme.dart
*/
class PrimaryButton extends StatelessWidget {
  /// create an specific button among primary, outlined,destructive and naked buttons
  /// [isEnabled] variable must not be null
  ///
  /// set [isOutlined] for outlined button,[isDestructive] for destructive buttons, [isNaked] for naked buttons and without any is for the primary button

  PrimaryButton(
      {Key? key,
      this.label,
      this.onPressed,
      this.isEnabled,
      this.isOutlined,
      this.isDestructive,
      this.isNaked})
      : super(key: key);

  final String? label;
  final bool? isEnabled;
  final VoidCallback? onPressed;
  final bool? isOutlined;
  final bool? isDestructive;
  final bool? isNaked;

  @override
  Widget build(BuildContext context) {
    Color? _color, _textColor, _disabledColor, _hoverColor;
    BorderSide _borderSide;

    if (isEnabled != null && isEnabled!) {
      if (isOutlined != null && isOutlined!) {
        _borderSide = BorderSide(color: CommonTheme.primary);
        _textColor = CommonTheme.primary;
        _color = CommonTheme.white;
      } else {
        _borderSide = BorderSide.none;
        _textColor = CommonTheme.white;
        _color = CommonTheme.primary;
      }

      if (isDestructive != null && isDestructive!) {
        _color = CommonTheme.danger;
        _hoverColor = CommonTheme.dangerLight;
        _textColor = CommonTheme.white;
        _borderSide = BorderSide.none;
      } else {
        _hoverColor = CommonTheme.primaryLight;
      }
    } else {
      if (isOutlined != null && isOutlined!) {
        _borderSide = BorderSide(color: CommonTheme.greyLight);
        _textColor = CommonTheme.greyLight;
        _color = CommonTheme.greyLightest;
      } else {
        _borderSide = BorderSide(color: CommonTheme.greyLight);
        _textColor = CommonTheme.greyLight;
        _color = CommonTheme.primary;
      }
    }

    if (isNaked != null && isNaked!) {
      _color = Colors.transparent;
      _borderSide = BorderSide.none;
      _hoverColor = CommonTheme.primaryLight;

      if (isEnabled != null && isEnabled!)
        _textColor = CommonTheme.primary;
      else
        _textColor = CommonTheme.greyLight;
    }

    _disabledColor = CommonTheme.greyLightest;

    if (isNaked != null && isNaked!) {
      return OutlineButton(
        onPressed: isEnabled != null && isEnabled! ? onPressed : null,
        borderSide: _borderSide,
        textColor: _textColor,
        hoverColor: _hoverColor,
        disabledTextColor: CommonTheme.greyLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), side: _borderSide),
        child: Text(label!,
            style: CommonTheme.tsBodySmall.apply(
              color: _textColor,
            )),
      );
    }

    return Container(
      child: MaterialButton(
        onPressed: isEnabled != null && isEnabled! ? onPressed : null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), side: _borderSide),
        child: Text(
          label!,
          //  textScaleFactor: 1.0,
          style: CommonTheme.tsBodySmall.apply(
            color: _textColor,
          ),
        ),
        color: _color,
        disabledColor: _disabledColor,
        hoverColor: _hoverColor,
      ),
    );
  }
}
