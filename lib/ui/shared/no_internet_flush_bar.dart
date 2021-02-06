import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:provider/provider.dart';

void displayInternetInfoBar(BuildContext context, String message) {
  if (GlobalContext.currentScreenContext == null) {
    return;
  }

  var textStyle = TextStyle(color: Colors.white, fontSize: 16);
  if (message.compareTo(AppStrings.internetConnection) == 0) {
    Flushbar<bool>(
      messageText: Text(
        message,
        style: textStyle,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      backgroundGradient: LinearGradient(colors: [
        ColorConstants.TOP_CLIPPER_START,
        ColorConstants.TOP_CLIPPER_END
      ]),
      isDismissible: true,
      duration: Duration(seconds: 3),
    )..show(GlobalContext.currentScreenContext);
  } else {
    Flushbar flush;
    flush = Flushbar<bool>(
      messageText: Text(
        message,
        style: textStyle,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      backgroundGradient: LinearGradient(colors: [
        ColorConstants.TOP_CLIPPER_START,
        ColorConstants.TOP_CLIPPER_END
      ]),
      isDismissible: true,
      duration: Duration(seconds: 3),
    )..show(GlobalContext.currentScreenContext);
  }
}
