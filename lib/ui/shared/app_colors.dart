import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';

const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
const Color masterColor = Color.fromARGB(255, 211, 17, 69);
const Color masterColorDark = Color.fromARGB(255, 211, 17, 69);
const Color greyColor = Color.fromARGB(255, 210, 210, 210);
const Color greyColorDark = Color.fromARGB(255, 162, 162, 162);

const LinearGradient blueBackgroundGradient =
    LinearGradient(colors: <Color>[Colors.lightBlue, Colors.lightBlueAccent]);

const LinearGradient profileGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ColorConstants.TOP_CLIPPER_START, Color(0xFF1F70C9)]);
const LinearGradient controlGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ColorConstants.CONTROL_BKG, ColorConstants.CONTROL_LIST_BKG]);

const LinearGradient topGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ColorConstants.TOP_CLIPPER_START_DARK, ColorConstants.TOP_CLIPPER_END_DARK]);

 const LinearGradient weatherChartGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[ColorConstants.TEMP_BY_HOUR_START, ColorConstants.TEMP_BY_HOUR_START]);   


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}    