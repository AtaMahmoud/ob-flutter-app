import 'dart:io';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/local_noti_data.dart';
import 'package:ocean_builder/core/models/notification.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/providers/current_ob_id_provider.dart';
import 'package:ocean_builder/core/providers/local_noti_data_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:provider/provider.dart';

class MethodHelper {
  static String remainingAccessTime(Duration duration) {
    // int remainingHours = (timestamp.millisecondsSinceEpoch -
    //         DateTime.now().millisecondsSinceEpoch) ~/
    //     (1000 * 60 * 60);
    // int days = remainingHours ~/ 24;
    // int hours = remainingHours - (days * 24);

    return '${duration.inDays} days and ${duration.inHours} hours remaining';
  }

  static bool isEmailValid(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.+]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  static bool isPasswordValid(String password) {
    bool passValid = RegExp(
            r"^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$")
        .hasMatch(password);
    return passValid;
  }

  // phome number validation    /^(\+\d{1,3}[- ]?)?\d{10}$/

  static bool isPhoneValid(String phone) {
    bool phoneValid = RegExp(r"^(\+\d{1,3}[- ]?)?\d{10}$").hasMatch(phone);
    return phoneValid;
  }

  static String getVesselCode(String oceanBuilderId) {
    if (oceanBuilderId == null) return '';

    String prefix = 'OB2';
    String trimmedString =
        oceanBuilderId.replaceAll(new RegExp(r"[^\s\w\d]|i|l|L|5|S|0|O"), '');
    String _vesselCode = prefix + trimmedString.substring(3, 7);
    // debugPrint(trimmedString);
    return _vesselCode;
  }

  static parseNotifications(BuildContext context) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(GlobalContext.currentScreenContext);

    final LocalNotiDataProvider localNotiDataProvider =
        Provider.of<LocalNotiDataProvider>(GlobalContext.currentScreenContext);

    List<ServerNotification> notiList = [];
    List<ServerNotification> unreadRequestAccessNotiList = [];
    int totalNotiNo = 0;
    int notiNo = 0;
    int unReadRequestAccessNotiNo = 0;
    bool isUnread;

    if (userProvider.authenticatedUser != null) {
      await userProvider.autoLogin();
      isUnread = false;
      if (userProvider.authenticatedUser.notifications != null &&
          userProvider.authenticatedUser.notifications.length > 0) {
        totalNotiNo = userProvider.authenticatedUser.notifications.length;
        notiList = new List<ServerNotification>.from(
            userProvider.authenticatedUser.notifications);
        unreadRequestAccessNotiList = new List<ServerNotification>.from(
            userProvider.authenticatedUser.notifications);
      }
      if (notiList != null) {
        notiList.retainWhere((item) {
          return item.seen == null || item.seen == false;
        });
        notiNo = notiList.length;
      }
      //userProvider.resetAuthenticatedUser(userProvider.authenticatedUser.userID);
    } else {
      // print('user is not authenticated yet');
    }
    isUnread = notiList != null && notiList.length > 0;

    if (unreadRequestAccessNotiList != null) {
      String currentUserID = userProvider.authenticatedUser.userID;

      unreadRequestAccessNotiList.retainWhere((item) {
        // debugPrint('notification read status --- ${item.seen} ');
        // debugPrint('notification data -- ${item.data.toJson()}');
        // debugPrint(
        //     'notificationType ---- ${item.data.type} -------------requestStatus ------------- ${item.data.status}');
        return (item.seen == null || item.seen == false) &&
          item.data.type != null &&  item.data.type.compareTo(NotificationConstants.request) == 0 &&
          item.data.status != null &&  item.data.status.compareTo(NotificationConstants.initiated) == 0 &&
          item.data.id != null &&  item.data.id.compareTo(currentUserID) == 0;
      });
      unReadRequestAccessNotiNo = unreadRequestAccessNotiList.length;
    } else {
      // print('user is not authenticated yet');
    }

    LocalNotification localNotification = LocalNotification();
    localNotification.totalNotificationCount = totalNotiNo;
    localNotification.unreadNotificationCount = notiNo;
    localNotification.unreadAccessRequestCount = unReadRequestAccessNotiNo;
    localNotification.isUnread = isUnread;

    localNotiDataProvider.localNotification = localNotification;

    // // debugPrint("Method helper Total noti: ${localNotiDataProvider.localNotification.totalNotificationCount} Method helper unread noti: ${localNotiDataProvider.localNotification.unreadNotificationCount} ---  Method helper unread request access noti: ${localNotiDataProvider.localNotification.unreadAccessRequestCount} ------ isUnread -- ${localNotiDataProvider.localNotification.isUnread}");
  }

  static selectOnlyOBasSelectedOB() async {
    print(
        '--GlobalContext.currentScreenContext----------------  ${GlobalContext.currentScreenContext}');
    print(
        '--------------------------------------  #_# selectOnlyOBasSelectedOB  ---------------------------------------------');

    UserProvider userProvider =
        Provider.of<UserProvider>(GlobalContext.currentScreenContext);
    SelectedOBIdProvider selectedOBIdProvider =
        Provider.of<SelectedOBIdProvider>(GlobalContext.currentScreenContext);

    // List<UserOceanBuilder> pendigOceanBuilderList = [];
    List<UserOceanBuilder> myOceanBuilderList = [];

    int len = userProvider?.authenticatedUser?.userOceanBuilder?.length ?? 0;
    debugPrint(
        '------------------userOceanBuilder----------------length --------------------$len');
    if (len > 0) {
      // pendigOceanBuilderList = new List<UserOceanBuilder>.from(
      //     userProvider?.authenticatedUser?.userOceanBuilder);
      // pendigOceanBuilderList.retainWhere((uob) {
      //   return uob.reqStatus != null &&
      //       uob.reqStatus.contains(NotificationConstants.initiated) &&
      //       !uob.userType.toLowerCase().contains('owner');
      // });

      myOceanBuilderList = new List<UserOceanBuilder>.from(
          userProvider?.authenticatedUser?.userOceanBuilder);

      myOceanBuilderList.retainWhere((uob) {
        debugPrint(
            '========== uob.reqStatus ==========${uob.reqStatus}-----------------');
        return uob.reqStatus != null &&
            (uob.reqStatus.contains('NA') ||
                !uob.reqStatus.contains(NotificationConstants.initiated));
      });
    }

    if (myOceanBuilderList != null &&
        myOceanBuilderList.length >= 1 &&
        selectedOBIdProvider.selectedObId
                .compareTo(AppStrings.selectOceanBuilder) ==
            0) {
      selectedOBIdProvider.selectedObId = myOceanBuilderList[0].oceanBuilderId;
      debugPrint(
          'selectedOBIdProvider.selectedObId ----method helper ------  ${selectedOBIdProvider.selectedObId}');
      SharedPrefHelper.setCurrentOB(selectedOBIdProvider.selectedObId);
    } else {
      debugPrint(
          'myOceanBuilderList length is 0 OR ----------------${selectedOBIdProvider.selectedObId}');
    }
  }

  static Future<File> getProfilePicture() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String path = prefs.getString(SharedPreferanceKeys.KEY_PROFILE_PIC);

    String path = await SharedPrefHelper.getProfilePicFilePath();

    if (path != null) {
      final File imageFile = File(path);
      if (await imageFile.exists()) {
        // Use the cached images if it exists
        return imageFile;
      }
    }
  }

// convert network image to bytes
  static Future<Uint8List> networkImageToByte(String path) async {
    HttpClient httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(path));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  }

  static bool isSeaPodNameAvailable(String seaPodName) {
    return true;
  }
}
