import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/core/providers/user_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:ocean_builder/ui/screens/designSteps/design_screen.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/request_access_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/your_obs_screen.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// FcmNotification fcmNotificationData
showInAppNotificationFirebase(
    String routeName, FcmNotification fcmNotificationData) async {
  MethodHelper.parseNotifications(GlobalContext.currentScreenContext);

  var textStyle = TextStyle(color: Colors.white, fontSize: 16);

  Flushbar flush;
  flush = Flushbar<bool>(
    messageText: Text(
      fcmNotificationData.data.message,
      style: textStyle,
    ),
    onTap: (Flushbar f) {
      f.dismiss();
      if (routeName.compareTo(GuestRequestResponseScreen.routeName) == 0) {
        locator<NavigationService>().fcmNavigateTo(
            GuestRequestResponseScreen.routeName,
            fcmNotification: fcmNotificationData);
      } else if (routeName.compareTo(YourObsScreen.routeName) == 0) {
        locator<NavigationService>().fcmNavigateTo(YourObsScreen.routeName,
            fcmNotification: fcmNotificationData);
      } else if (routeName.compareTo(InvitationResponseScreen.routeName) == 0) {
        locator<NavigationService>().fcmNavigateTo(
            InvitationResponseScreen.routeName,
            fcmNotification: fcmNotificationData);
      }
    },
    flushbarStyle: FlushbarStyle.FLOATING,
    // margin: EdgeInsets.all(8),
    // borderRadius: 8,
    icon: Icon(
      Icons.info_outline,
      color: Colors.white,
    ),
    backgroundGradient: LinearGradient(colors: [
      ColorConstants.TOP_CLIPPER_START,
      ColorConstants.TOP_CLIPPER_END
    ]),
    flushbarPosition: FlushbarPosition.TOP,
    isDismissible: false,
    mainButton: FlatButton(
      padding: EdgeInsets.zero,
      child: Text(
        AppStrings.dismiss,
        style: textStyle,
      ),
      onPressed: () async {
        await MethodHelper.selectOnlyOBasSelectedOB();
        flush.dismiss(true);
      },
    ),
  )..show(GlobalContext.currentScreenContext);
}

showInfoBar(String title, String msg, BuildContext context) {
  debugPrint('show infor bar ---------------$msg ');
  Flushbar(
    title: title,
    message: msg,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.white,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    isDismissible: true,
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.info_outline,
      color: Colors.white,
    ),
    backgroundGradient: new LinearGradient(
      begin: FractionalOffset.bottomCenter,
      end: FractionalOffset.topCenter,
      stops: <double>[0.2, 1.0],
      colors: <Color>[
        ColorConstants.TOP_CLIPPER_START,
        ColorConstants.TOP_CLIPPER_END
      ],
    ),
    // LinearGradient(colors: [
    //   ColorConstants.TOP_CLIPPER_START,
    //   ColorConstants.TOP_CLIPPER_END
    // ],
    // begin: Alignment.centerLeft,
    // end: Alignment.centerRight,

    // ),
  )..show(context);
}

showInfoBarWithDissmissCallback(
    String title, String msg, BuildContext context, callback) {
  Flushbar(
    title: title,
    message: msg,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.white,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    isDismissible: true,
    duration: Duration(seconds: 5),
    icon: Icon(
      Icons.info_outline,
      color: Colors.white,
    ),
    backgroundGradient: LinearGradient(colors: [
      ColorConstants.TOP_CLIPPER_START,
      ColorConstants.TOP_CLIPPER_END
    ]),
  )
    ..onStatusChanged = (FlushbarStatus status) {
      switch (status) {
        case FlushbarStatus.SHOWING:
          {
            //doSomething();
            break;
          }
        case FlushbarStatus.IS_APPEARING:
          {
            // doSomethingElse();
            break;
          }
        case FlushbarStatus.IS_HIDING:
          {
            // doSomethingElse();
            break;
          }
        case FlushbarStatus.DISMISSED:
          {
            //doSomethingElse();
            callback();
            break;
          }
      }
    }
    ..show(context);
}

String parseErrorTitle(String errorCode) {
  String trimmedString = '';
  trimmedString = errorCode.replaceAll('_', ' ');
  return trimmedString.replaceAll('ERROR ', '');
}

showAlertWithOneButton(
    {String title,
    String desc,
    String buttonText,
    Function buttonCallback,
    BuildContext context}) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    overlayColor: ColorConstants.TOP_CLIPPER_START.withOpacity(.1),
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.normal),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(
          color: ColorConstants.TOP_CLIPPER_START,
          style: BorderStyle.none,
          width: 4.0),
    ),
    backgroundColor: Colors.white,
    titleStyle: TextStyle(
        color: ColorConstants.TOP_CLIPPER_START, fontWeight: FontWeight.bold),
  );

  Alert(
    context: context,
    style: alertStyle,
    type: AlertType.none,
    title: title.toUpperCase(),
    desc: desc,
    buttons: buttonText != null
        ? [
            DialogButton(
              child: Text(
                buttonText.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: buttonCallback,
              // color: Color.fromRGBO(0, 179, 134, 1.0),
              gradient: LinearGradient(colors: [
                ColorConstants.BOTTOM_CLIPPER_START,
                ColorConstants.BOTTOM_CLIPPER_END
              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              radius: BorderRadius.circular(4.0),
            ),
          ]
        : null,
  ).show();
}

showAddOBDialog(UserProvider userProvider, BuildContext context) {
  UserDataProvider _userDataProvider = Provider.of<UserDataProvider>(context);

  Alert(
    context: context,
    title: '',
    style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: true),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UIHelper.imageTextColumn(
                ImagePaths.requestAccess, AppStrings.requestHomeAccess),
          ),
          onTap: () {
            _userDataProvider.user.firstName =
                userProvider.authenticatedUser.firstName;
            _userDataProvider.user.lastName =
                userProvider.authenticatedUser.lastName;
            _userDataProvider.user.email = userProvider.authenticatedUser.email;
            _userDataProvider.user.country =
                userProvider.authenticatedUser.country;
            _userDataProvider.user.phone = userProvider.authenticatedUser.phone;
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pushNamed(RequestAccessScreen.routeName);
          },
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: UIHelper.imageTextColumn(
                ImagePaths.svgSeapod, AppStrings.design),
          ),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pushNamed(DesignScreen.routeName);
          },
        ),
      ],
    ),
    buttons: [],
  ).show();
}

showEmergencyAlert(String alertMessage, BuildContext context) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    overlayColor: ColorConstants.TOP_CLIPPER_START.withOpacity(.1),
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.normal),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(
          color: ColorConstants.TOP_CLIPPER_START,
          style: BorderStyle.none,
          width: 4.0),
    ),
    backgroundColor: Colors.white,
    titleStyle: TextStyle(
        color: ColorConstants.TOP_CLIPPER_START, fontWeight: FontWeight.bold),
  );

  Alert(
    context: context,
    title: '',
    style: alertStyle,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: UIHelper.imageTextColumn(
            ImagePaths.svgUrgentNotification,
            AppStrings.urgentNotification,
            textSize: 48,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              alertMessage,
              style: TextStyle(
                  color: ColorConstants.TEXT_COLOR,
                  fontSize: ScreenUtil().setSp(36)),
            )),
      ],
    ),
    buttons: [],
  ).show();
}
