import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/ui/screens/menu/landing_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/recover_password_verification_screen.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> fcmNavigateTo(String routeName,
      {FcmNotification fcmNotification}) async {
    if (AppLaunchState.LAUNCH_FROM_NOTIFICATION_TRAY) {
      await Future.delayed(Duration(seconds: 3));
    }

    // debugPrint('navigating to ----- $routeName ');

    navigatorKey.currentState
        .popUntil((Route<dynamic> route) => route is PageRoute);

    return navigatorKey.currentState
        .pushNamed(routeName, arguments: fcmNotification);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToCurrentScreen() {
    // String routeName = ModalRoute.of(navigatorKey.currentContext).settings.name;
    // print(
    //     'Current root is -------------------------------------------------------- $routeName');
    // if (routeName == null) {
    //   return navigatorKey.currentState.pushNamed(LandingScreen.routeName);
    // }
    // return navigatorKey.currentState.pushNamed(routeName);
    // navigatorKey.currentState.setState(() {});
    showAlertWithOneButton(
        context: navigatorKey.currentState.context,
        buttonText: "OK",
        desc: "You have one ontification",
        title: "In App Notification",
        buttonCallback: () {
          print('Button tapped');
        });
    return navigatorKey.currentState.maybePop();
  }

  Future<dynamic> dpNavigateToEmailVeriScreen(
      EmailVerificationData data) async {
    await Future.delayed(Duration(seconds: 3));
    navigatorKey.currentState
        .popUntil((Route<dynamic> route) => route is PageRoute);

    return navigatorKey.currentState
        .pushNamed(EmailVerificationScreen.routeName, arguments: data);
  }

  Future<dynamic> dpNavigateToRecoverPassScreen(
      EmailVerificationData data) async {
    await Future.delayed(Duration(seconds: 3));
    navigatorKey.currentState
        .popUntil((Route<dynamic> route) => route is PageRoute);

    return navigatorKey.currentState.pushNamed(
        RecoverPasswordVerificationScreen.routeName,
        arguments: data);
  }
}
