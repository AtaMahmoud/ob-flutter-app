import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:device_info/device_info.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeadersManager {
  static final HeadersManager _headersManagerSingleton =
      HeadersManager._internal();
  HeadersManager._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static HeadersManager getInstance() => _headersManagerSingleton;

  Map<String, String> _headers = {};
  Map<String, String> _basicHeaders = {};
  Map<String, String> _essentialHeaders = {};
  Map<String, String> _authUserHeaders = {};

  Map<String, String> get headers {
    if (_basicHeaders.isNotEmpty) _headers.addAll(_basicHeaders);

    if (_essentialHeaders.isNotEmpty) _headers.addAll(_essentialHeaders);

    if (_authUserHeaders.isNotEmpty) _headers.addAll(_authUserHeaders);


    // debugPrint('returnning header ----------------  $_headers');

    return _headers;
  }

  Map<String, dynamic> get basicHeaders {
    return _basicHeaders;
  }

  Map<String, dynamic> get essentialHeaders {
    return _essentialHeaders;
  }

  Map<String, dynamic> get authUserHeaders {
    return _authUserHeaders;
  }

  void initializeEssentialHeaders() async {
    String fcmToken = await _fcm.getToken();
    _essentialHeaders = {
      "notificationToken": fcmToken
      // "X-Application-Key": Config.BRAND_KEY,
      // "X-Brand-Name": Config.BRAND_NAME,
      // "X-Api-CurrentApi": Config.CURRENT_API,
      // "X-Api-CurrentVersion": Config.CURRENT_VERSION,
    };
    // debugPrint('esseltial headers ---  $_essentialHeaders');
  }
  
  //TODO : initalize this after login or registration
  void initalizeBasicHeaders(BuildContext context)async{
     _basicHeaders = await _getHeadersFromSharedPrefs();
    if (_basicHeaders.isEmpty || _basicHeaders.length != 2) {
      String language = Localizations.localeOf(context).languageCode;
      _basicHeaders = await _getBasicHeaders(language);
      _saveHeadersToSharedPrefs(_basicHeaders);
    }

     // debugPrint('basic headers ---  $_basicHeaders');
  }
  Future<void> initalizeAuthenticatedUserHeaders() async {
    String authToken = await SharedPrefHelper.getAuthKey();
    if(authToken!=null){
      _authUserHeaders.addAll({
      "x-auth-token": authToken,
    });
    }

SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.containsKey("hardwareId")) {

                _authUserHeaders.addAll({
      "hardwareId": sharedPreferences.getString('hardwareId'),
    });
          
          }

      // debugPrint('auth headers ---  $_authUserHeaders');
  }

  void _saveHeadersToSharedPrefs(Map<String, dynamic> deviceData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (var key in deviceData.keys) {
      sharedPreferences.setString(key, deviceData[key]);
    }
  }

  Future<Map<String, String>> _getHeadersFromSharedPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> resultMap = {};
    if (sharedPreferences.containsKey("hardwareId")) {
      resultMap['hardwareId'] =
          sharedPreferences.getString('hardwareId');
      resultMap["model"] =
          sharedPreferences.getString("model");
    }

    return resultMap;
  }

  Future<Map<String, String>> _getBasicHeaders(String languageCode) async {
    Map<String, String> deviceData = {};
    // deviceData["X-Api-Language"] = languageCode;

    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidDeviceInfo =
          await deviceInfoPlugin.androidInfo;
      deviceData['hardwareId'] = androidDeviceInfo.androidId;
      deviceData['model'] = 'Android';
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceData['hardwareId'] = iosDeviceInfo.identifierForVendor;
      deviceData['model'] = 'IOS';
    }

    return deviceData;
  }
}
