import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key key,
      this.label,
      this.onPressed,
      this.isEnabled,
      this.isOutlined,
      this.isDestructive})
      : super(key: key);

  final String label;
  final bool isEnabled;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    Color _color, _textColor, _disabledColor, _hoverColor;
    BorderSide _borderSide;

    if (isEnabled) {
      if (isOutlined) {
        _borderSide = BorderSide(color: CommonTheme.primary);
        _textColor = CommonTheme.primary;
        _color = CommonTheme.white;
      } else {
        _borderSide = BorderSide.none;
        _textColor = CommonTheme.white;
        _color = CommonTheme.primary;
      }
    } else {
      if (isOutlined) {
        _borderSide = BorderSide(color: CommonTheme.greyLight);
        _textColor = CommonTheme.greyLight;
        _color = CommonTheme.greyLightest;
      } else {
        _borderSide = BorderSide(color: CommonTheme.greyLight);
        _textColor = CommonTheme.greyLight;
        _color = CommonTheme.primary;
      }
    }

    if (isDestructive) {
      _color = CommonTheme.danger;
      _hoverColor = CommonTheme.dangerLight;
      _textColor = CommonTheme.white;
      _borderSide = BorderSide.none;
    } else {
      _hoverColor = _hoverColor = CommonTheme.primaryLight;
    }

    _disabledColor = CommonTheme.greyLight;

    return Container(
      child: MaterialButton(
        onPressed: isEnabled ? onPressed : null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), side: _borderSide),
        child: Text(
          label,
          //  textScaleFactor: 1.0,
          style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0),
        ),
        color: _color,
        disabledColor: _disabledColor,
        hoverColor: _hoverColor,
      ),
    );
  }
}

/*
class CommonButtons{

  static Widget getButton(String text, VoidCallback callback,
      {double w = 200,
      double h = 60,
      double fontSize = 22,
      bool isInactive = false,
      String iconPath,
      gradientColors = const [Color(0xFF01388B), Color(0xFF2C86AC)],
      double borderRadius = 24}) {
    return InkWell(
      onTap: callback,
      child: Container(
        // height: h,
        width: w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(borderRadius.w),
          gradient: isInactive
              ? LinearGradient(colors: [
                  ColorConstants.CONTROL_END,
                  ColorConstants.CONTROL_END
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              : LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            iconPath != null
                ? ImageIcon(
                    AssetImage(iconPath),
                    color: Colors.white,
                  )
                : Container(),
            iconPath != null ? SizedBox(width: 16.w) : Container(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ],
        )),
      ),
    );
  }

}
*/
