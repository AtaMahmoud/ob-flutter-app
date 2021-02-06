import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/core/services/locator.dart';
import 'package:ocean_builder/core/services/navigation_service.dart';
import 'package:ocean_builder/ui/screens/notification/guest_request_response_screen.dart';
import 'package:ocean_builder/ui/screens/notification/invitation_response_screen.dart';
import 'package:ocean_builder/ui/screens/sign_in_up/your_obs_screen.dart';
import 'package:ocean_builder/ui/shared/toasts_and_alerts.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
int  counter = 0;
  void setUpFirebase() {
    print('setup firebase message caleed $counter++');
    _firebaseMessaging = FirebaseMessaging();
    _firebaseCloudMessagingListeners();
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("triggerd");

  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // return null;
  // Or do other work.

    {

        print(
            'on backgroundMessage--------------------------------------------  $message');

        Map<String, dynamic> message_notificationData =
            message['data']['notificationData'];
        print('message_notificationData   -------- $message_notificationData');
        // print('notification data ## -------------- ${message_notificationData['_id']}');

        FcmNotification fcmNotificationData = FcmNotification.fromJson(message);

        if (Platform.isIOS) {
          NotificationData notificationData =
              NotificationData.fromJson(message);
          fcmNotificationData.data = notificationData;
        }

        debugPrint('notification data -----' +
        fcmNotificationData.toJson().toString());




      }
}


  void _firebaseCloudMessagingListeners() {
    if (Platform.isIOS) _iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print('fcm token----------------------------------');
      print(token);
      print('fcm token----------------------------------');
    });

    _firebaseMessaging.configure(
      
      onBackgroundMessage: myBackgroundMessageHandler,
      
      // ----------------------------------------------- onMessage -----------------------------------------------------
      
      onMessage: (Map<String, dynamic> message) async {
        print(
            'on message--------------------------------------------  $message');

        Map<String, dynamic> message_notificationData =
            message['data']['notificationData'];
        print('message_notificationData   -------- $message_notificationData');
        // print('notification data ## -------------- ${message_notificationData['_id']}');

        FcmNotification fcmNotificationData = FcmNotification.fromJson(message);

        if (Platform.isIOS) {
          NotificationData notificationData =
              NotificationData.fromJson(message);
          fcmNotificationData.data = notificationData;
        }

        debugPrint('notification data -----' +
        fcmNotificationData.toJson().toString());

        if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.request) ==
            0) {
          showInAppNotificationFirebase(
              GuestRequestResponseScreen.routeName, fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.response) ==
            0) {
          showInAppNotificationFirebase(
              YourObsScreen.routeName, fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.invitation) ==
            0) {
          showInAppNotificationFirebase(
              InvitationResponseScreen.routeName, fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.invitationResponse) ==
            0) {
          showInAppNotificationFirebase(
              YourObsScreen.routeName, fcmNotificationData);
        }
      },

      // ----------------------------------------------- onResume -----------------------------------------------------

      onResume: (Map<String, dynamic> message) async {
        print(
            'on resume--------------------------------------------- $message');

        FcmNotification fcmNotificationData = FcmNotification.fromJson(message);

        if (Platform.isIOS) {
          NotificationData notificationData =
              NotificationData.fromJson(message);
          fcmNotificationData.data = notificationData;
        }

        // debugPrint('notification data -----' +
        // fcmNotificationData.toJson().toString());

        AppLaunchState.RESUME_FROM_NOTIFICATION_TRAY = true;

        if (fcmNotificationData.data.notificationType
                .compareTo(NotificationConstants.request) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(
              GuestRequestResponseScreen.routeName,
              fcmNotification: fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .compareTo(NotificationConstants.response) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(YourObsScreen.routeName,
              fcmNotification: fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.invitation) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(
              InvitationResponseScreen.routeName,
              fcmNotification: fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.invitationResponse) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(YourObsScreen.routeName,
              fcmNotification: fcmNotificationData);
        }
      },

      // ----------------------------------------------- onLaunch -----------------------------------------------------
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch ------------------- ${message.toString()}');
        /*
        on launch {data: {
          click_action: FLUTTER_NOTIFICATION_CLICK, google.original_priority: high, google.delivered_priority: high, email: r@d.c, from: 889155952746, google.sent_time: 1561783459621, contactNo: 1234, status: done, collapse_key: com.ss.oceanbuilders, id: 1, accessAs: GUEST, name: r, accessFor: 3 DAYS, google.message_id: 0:1561783459664929%d1f47f29d1f47f29, google.ttl: 2419200
          },
           notification: {}
           }
        */
        FcmNotification fcmNotificationData = FcmNotification.fromJson(message);

        if (Platform.isIOS) {
          NotificationData notificationData =
              NotificationData.fromJson(message);
          fcmNotificationData.data = notificationData;
        }

        // debugPrint('notification data -----' +
        // fcmNotificationData.toJson().toString());

        AppLaunchState.LAUNCH_FROM_NOTIFICATION_TRAY = true;

        if (fcmNotificationData.data.notificationType
                .compareTo(NotificationConstants.request) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(
              GuestRequestResponseScreen.routeName,
              fcmNotification: fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .compareTo(NotificationConstants.response) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(YourObsScreen.routeName,
              fcmNotification: fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.invitation) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(
              InvitationResponseScreen.routeName,
              fcmNotification: fcmNotificationData);
        } else if (fcmNotificationData.data.notificationType
                .toUpperCase()
                .compareTo(NotificationConstants.invitationResponse) ==
            0) {
          locator<NavigationService>().fcmNavigateTo(YourObsScreen.routeName,
              fcmNotification: fcmNotificationData);
        }
      },
    );
  }

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      // print("Settings registered: $settings");
    });
  }
}
