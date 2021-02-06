import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/email_verification_screen.dart';

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

  Future<dynamic> dpNavigateToEmailVeriScreen(EmailVerificationData data) async {
      await Future.delayed(Duration(seconds: 3));
    navigatorKey.currentState
        .popUntil((Route<dynamic> route) => route is PageRoute);

    return navigatorKey.currentState
        .pushNamed(EmailVerificationScreen.routeName, arguments: data);
  }  
}
