import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/models/access_events.dart';
import 'package:ocean_builder/core/models/access_request.dart';
import 'package:ocean_builder/core/models/emergency_contact.dart';
import 'package:ocean_builder/core/models/lighting.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/models/reg_with_seapod.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/models/user_ocean_builder.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:ocean_builder/helper/file_utils.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
// import 'package:fcm_push/fcm_push.dart';
import 'package:ocean_builder/configs/app_configurations.dart' as APP_CONFIG;
import 'package:ocean_builder/helper/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_provider.dart';

const String FCM_SERVER_KEY =
    'AAAAzwXTIGo:APA91bH89Ggi2DoEy7w56Y2LiWWqbisy6kzIAw3fbwphMc9cUgdeSGRy66RLhosAMynQwzK7nUxNFMfEI6HlKGvNCaDD-q8fhtoBuIvdU_tbDnswz8o5_82Bd395_Mh9RQqi0wtGwdS6';
const String FCM_API = "https://fcm.googleapis.com/fcm/send";
final String contentType = "application/json";

class UserProvider extends BaseProvider {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  bool _isUserAuthenticated = false;

  HeadersManager _headerManager = HeadersManager.getInstance();

  bool get isAuthenticatedUser {
    return _isUserAuthenticated;
  }

  Future<String> get fcmToken async {
    String fcmToken = await _fcm.getToken();
    return fcmToken;
  }

  // ------------------------------------------------------- Login ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> logIn(String email, String password) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    Map<String, dynamic> loginCredentials = {
      "email": email,
      "password": password
    };

    try {
      final Response loginResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.LOGIN,
          data: loginCredentials,
          headers: _headerManager.headers);

      // User userData;

      debugPrint('loginResponse ~~~~~~~~~~~~~~~~~~~~~~~ -- ${loginResponse}');

      if (loginResponse != null && loginResponse.statusCode == 200) {
        User userData = User.fromJson(loginResponse.data);

        // // print(userData.seaPods[0].users[0].toJson());

        // temporary fix for userOceanbuilder
        List<UserOceanBuilder> userOceanBuilderList = [];
        userData.seaPods.map((f) {
          f.users.map((seapodUser) {
            UserOceanBuilder userOceanBuilder = UserOceanBuilder();
            userOceanBuilder.oceanBuilderName = f.obName;
            userOceanBuilder.oceanBuilderId = f.id;
            userOceanBuilder.userType = seapodUser.userType;
            userOceanBuilder.accessTime =
                seapodUser.accessTime; //Duration(hours: 48);
            userOceanBuilder.checkInDate = seapodUser.checkInDate;
            userOceanBuilder.reqStatus = 'NA';
            userOceanBuilder.vessleCode = f.vessleCode;
            userOceanBuilderList.add(userOceanBuilder);
          }).toList();
        }).toList();
/*
    user --> n seapod --> seapodUser ( OceanBuilderUser ) 
        --> UserOfSeapod ( UserOceanBuilder )
*/

        userData.accessRequests.map((f) {
          // debugPrint('accessRequests --------  ${f.toJson()}');
          UserOceanBuilder userOceanBuilder = UserOceanBuilder();
          userOceanBuilder.accessRequestID = f.id;
          userOceanBuilder.oceanBuilderName = f.seaPod.name;
          userOceanBuilder.vessleCode = f.seaPod.vessleCode;
          userOceanBuilder.oceanBuilderId = f.seaPod.id;
          userOceanBuilder.userType = f.type;
          userOceanBuilder.accessTime = Duration(milliseconds: f.period);
          userOceanBuilder.checkInDate =
              DateTime.fromMicrosecondsSinceEpoch(f.checkIn);
          userOceanBuilder.reqStatus = f.status;
          if (userOceanBuilder.reqStatus
                  .compareTo(NotificationConstants.pending) ==
              0) userOceanBuilderList.add(userOceanBuilder);
        }).toList();

        userOceanBuilderList.map((f) {
          // debugPrint('LOGIN -- userOceanBuilder --------  ${f.oceanBuilderName}');
        }).toList();

        userData.userOceanBuilder = userOceanBuilderList;

        if (userData.emergencyContacts != null &&
            userData.emergencyContacts.length > 0) {
          userData.emergencyContact = userData.emergencyContacts[0];
        }

        if (loginResponse.headers.value("X-Auth-Token") != null) {
          userData.xAuthToken = loginResponse.headers.value("X-Auth-Token");

          authenticatedUser = userData;
          _isUserAuthenticated = true;

          SharedPrefHelper.setAuthKey(
              loginResponse.headers.value("X-Auth-Token"));

          // // debugPrint(
          //     'loginResponse ~~~~~~~~~~~~~~~~~~~~~~~ -- ${authenticatedUser.toJson()}');
        } else {
          // debugPrint('error code ');
          responseStatus.code = 'Login Failed';
          responseStatus.message = loginResponse.statusMessage;
          responseStatus.status = loginResponse.statusCode;
        }
      } else {
        // debugPrint('error code ');
        responseStatus.code = 'Login Failed';
        responseStatus.message = loginResponse.statusMessage;
        responseStatus.status = loginResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Login Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint('logIn  error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Login Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    if (authenticatedUser != null) {
      _isUserAuthenticated = true;
      responseStatus.status = 200;
    }

    isLoading = false;
    notifyListeners();
    return responseStatus;
  }

  // ------------------------------------------------------- Confirm Email ( GET ) --------------------------------------------------------------------

  Future<ResponseStatus> confirmEmail(String token) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    try {
      final Response _response = await _apiBaseHelper.getForResponse(
          url: APP_CONFIG.Config.EMAIL_CONFIRMATION(token),
          headers: _headerManager.headers);

      debugPrint(
          'email confirmation _response ~~~~~~~~~~~~~~~~~~~~~~~ -- ${_response}');

      if (_response != null && _response.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        // debugPrint('error code ');
        responseStatus.code = 'Invalid Token';
        responseStatus.message = _response.statusMessage;
        responseStatus.status = _response.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Invalid Token';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint('logIn  error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Invalid Token';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();
    return responseStatus;
  }

  // ------------------------------------------------------- Resend Email Code ( GET ) --------------------------------------------------------------------

  Future<ResponseStatus> resendCode(String email) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    Map<String, dynamic> reqBody = {
      "email": email,
    };
    debugPrint('resending code -- $email');
    try {
      final Response _response = await _apiBaseHelper.postForResponse(
          url: APP_CONFIG.Config.RESEND_CONFIRMATION_CODE,
          headers: _headerManager.headers,
          data: reqBody
          );

      debugPrint(
          'email resend _response ~~~~~~~~~~~~~~~~~~~~~~~----- ${_response.statusCode}');

      if (_response != null && _response.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        debugPrint('error code ' + _response.statusCode.toString());
        responseStatus.code = 'Couldn\'t send token';
        responseStatus.message = _response.statusMessage;
        responseStatus.status = _response.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Couldn\'t send token';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      debugPrint('logIn  error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Couldn\'t send token';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();
    return responseStatus;
  }

  // ------------------------------------------------------- Auto Login ( GET ) --------------------------------------------------------------------

  Future<void> autoLogin() async {
    // notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    User userData;
    Map<String, String> _authUserHeaders = {};
    String authToken = await SharedPrefHelper.getAuthKey();
    _authUserHeaders.addAll({
      "X-Auth-Token": authToken,
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("hardwareId")) {
      _authUserHeaders.addAll({
        "hardwareId": sharedPreferences.getString('hardwareId'),
      });
    }

    try {
      var loginResponse = await _apiBaseHelper.get(
          url: APP_CONFIG.Config.AUTO_LOGIN, headers: _authUserHeaders);

      userData = User.fromJson(loginResponse);
      // // debugPrint('auto log in user data ----------- ${userData.toJson()}');

      List<UserOceanBuilder> userOceanBuilderList = [];
      userData.seaPods.map((f) {
        UserOceanBuilder userOceanBuilder = UserOceanBuilder();
        userOceanBuilder.oceanBuilderName = f.obName;
        userOceanBuilder.oceanBuilderId = f.id;
        userOceanBuilder.userType = f.users[0].userType;
        userOceanBuilder.accessTime = Duration(hours: 48);
        userOceanBuilder.reqStatus = 'NA';
        userOceanBuilder.vessleCode = f.vessleCode;
        userOceanBuilder.checkInDate = null;
        userOceanBuilderList.add(userOceanBuilder);
      }).toList();

      userData.accessRequests.map((f) {
        // debugPrint('accessRequests --------  ${f.toJson()}');
        UserOceanBuilder userOceanBuilder = UserOceanBuilder();
        userOceanBuilder.accessRequestID = f.id;
        userOceanBuilder.oceanBuilderName = f.seaPod.name;
        userOceanBuilder.vessleCode = f.seaPod.vessleCode;
        userOceanBuilder.oceanBuilderId = f.seaPod.id;
        userOceanBuilder.userType = f.type;
        userOceanBuilder.accessTime = Duration(milliseconds: f.period);
        userOceanBuilder.checkInDate =
            DateTime.fromMicrosecondsSinceEpoch(f.checkIn);
        userOceanBuilder.reqStatus = f.status;
        if (userOceanBuilder.reqStatus
                .compareTo(NotificationConstants.pending) ==
            0) userOceanBuilderList.add(userOceanBuilder);
      }).toList();

      userOceanBuilderList.map((f) {
        // debugPrint('AUTO LOGIN -- userOceanBuilder --------  ${f.oceanBuilderName}');
      }).toList();

      userData.userOceanBuilder = userOceanBuilderList;

      if (userData.emergencyContacts != null &&
          userData.emergencyContacts.length > 0) {
        userData.emergencyContact = userData.emergencyContacts[0];
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Login Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'autoLogin error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Login Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      ;
    }

    if (userData != null) {
      authenticatedUser = userData;
      responseStatus.status = 200;
      _isUserAuthenticated = true;
    }
    // notifyListeners();
  }

  // ------------------------------------------------------- Registration With SeaPod Creation ( POST ) --------------------------------------------------------------------

  Future<ResponseStatus> registrationWithSeaPodCreation(
      User personalDetails, OceanBuilder oceanBuilderDetails) async {
    isLoading = true;
    notifyListeners();
    oceanBuilderDetails.obName = ListHelper.getRandomName();
    ResponseStatus responseStatus = ResponseStatus();

    RegWithSeaPod regWithSeaPod = RegWithSeaPod();
    regWithSeaPod.user = new RegUser();
    regWithSeaPod.user.firstName = personalDetails.firstName;
    regWithSeaPod.user.lastName = personalDetails.lastName;
    regWithSeaPod.user.email = personalDetails.email;
    regWithSeaPod.user.password = personalDetails.password;
    regWithSeaPod.user.mobileNumber = personalDetails.phone;
    regWithSeaPod.user.country = personalDetails.country;

    regWithSeaPod.seaPod = new RegSeaPod();
    regWithSeaPod.seaPod.bedAndLivingRoomEnclousure =
        oceanBuilderDetails.bedAndLivingRoomEnclousure;
    regWithSeaPod.seaPod.deckEnclosure = oceanBuilderDetails.deckEnclosure;
    regWithSeaPod.seaPod.deckFloorFinishMaterial =
        oceanBuilderDetails.deckFloorFinishMaterials;
    regWithSeaPod.seaPod.entryStairs =
        oceanBuilderDetails.entryStairs.toLowerCase().compareTo('yes') == 0
            ? true
            : false;
    regWithSeaPod.seaPod.exterioirColor = oceanBuilderDetails.exteriorColor;
    regWithSeaPod.seaPod.exteriorFinish = oceanBuilderDetails.exteriorFinish;
    regWithSeaPod.seaPod.hasCleanWaterLevelIndicator =
        oceanBuilderDetails.hasCleanWaterLevelIndicator;
    regWithSeaPod.seaPod.hasFathometer = oceanBuilderDetails.hasFathometer;
    regWithSeaPod.seaPod.hasWeatherStation =
        oceanBuilderDetails.weatherStation != null &&
                oceanBuilderDetails.weatherStation.length > 0
            ? true
            : false;
    regWithSeaPod.seaPod.interiorBedroomWallColor =
        oceanBuilderDetails.interiorBedroomWallColor;
    regWithSeaPod.seaPod.kitchenfloorFinishing =
        oceanBuilderDetails.kitchenfloorFinishing;
    regWithSeaPod.seaPod.kitchenInteriorWallColor =
        oceanBuilderDetails.kitcheninteriorWallColor;
    regWithSeaPod.seaPod.livingRoomInteriorWallColor =
        oceanBuilderDetails.livingRoominteriorWallColor;
    regWithSeaPod.seaPod.livingRoomloorFinishing =
        oceanBuilderDetails.livingRoomloorFinishing;
    regWithSeaPod.seaPod.masterBedroomFloorFinishing = [
      oceanBuilderDetails.masterBedroomfloorFinishing
    ];
    regWithSeaPod.seaPod.masterBedroomInteriorWallColor =
        oceanBuilderDetails.masterBedroominteriorWallColor;
    regWithSeaPod.seaPod.power = oceanBuilderDetails.power;
    regWithSeaPod.seaPod.powerUtilities = oceanBuilderDetails.powerUtilities;
    regWithSeaPod.seaPod.seaPodName = oceanBuilderDetails.obName;
    regWithSeaPod.seaPod.seaPodStatus = 'status';
    regWithSeaPod.seaPod.soundSystem = oceanBuilderDetails.soundSystem;
    regWithSeaPod.seaPod.sparDesign = oceanBuilderDetails.sparDesign;
    regWithSeaPod.seaPod.sparFinish = oceanBuilderDetails.sparFinishing;
    regWithSeaPod.seaPod.underWaterRoomFinishing =
        oceanBuilderDetails.underWaterRoomFinishing;
    regWithSeaPod.seaPod.underWaterWindows =
        oceanBuilderDetails.underWaterWindows;
    // oceanBuilderDetails.defaultScenes = PredefinedLightData.defaultscenes;
    // debugPrint('regAndCreateNewSeapod --------- ${regWithSeaPod.toJson()}');
    try {
      final Response loginResponse = await _apiBaseHelper.postForResponse(
          url: APP_CONFIG.Config.REG_WITH_SEAPOD_CREATION,
          data: regWithSeaPod.toJson(),
          headers: _headerManager.headers);

      if (loginResponse != null && loginResponse.statusCode == 200) {
        debugPrint(
            '-----------------registration response ----- ${loginResponse.data.toString()}');
        responseStatus.status = 200;
        SharedPrefHelper.setEmail(regWithSeaPod.user.email);
      } else {
        // debugPrint('error code ');
        responseStatus.code = 'Registration Failed';
        if (loginResponse.statusMessage.contains('duplicate key error')) {
          responseStatus.message = 'User already exists';
        } else {
          responseStatus.message = loginResponse.statusMessage;
        }

        responseStatus.status = loginResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Registration Failed';
      // responseStatus.message = ea.message;
      if (ea.message.contains('duplicate key error')) {
        responseStatus.message = 'User already exists';
      } else {
        responseStatus.message = ea.message;
      }
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'registrationWithSeaPodCreation error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Registration Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();
    return responseStatus;
  }

  // ------------------------------------------------------- Create SeaPod For Existing User ( POST ) --------------------------------------------------------------------

  Future<ResponseStatus> createSeaPod(OceanBuilder oceanBuilderDetails) async {
    isLoading = true;
    notifyListeners();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    ResponseStatus responseStatus = ResponseStatus();

    oceanBuilderDetails.obName = ListHelper.getRandomName();

    RegSeaPod seaPod = new RegSeaPod();
    seaPod.bedAndLivingRoomEnclousure =
        oceanBuilderDetails.bedAndLivingRoomEnclousure;
    seaPod.deckEnclosure = oceanBuilderDetails.deckEnclosure;
    seaPod.deckFloorFinishMaterial =
        oceanBuilderDetails.deckFloorFinishMaterials;
    seaPod.entryStairs =
        oceanBuilderDetails.entryStairs.toLowerCase().compareTo('yes') == 0
            ? true
            : false;
    seaPod.exterioirColor = oceanBuilderDetails.exteriorColor;
    seaPod.exteriorFinish = oceanBuilderDetails.exteriorFinish;
    seaPod.hasCleanWaterLevelIndicator =
        oceanBuilderDetails.hasCleanWaterLevelIndicator;
    seaPod.hasFathometer = oceanBuilderDetails.hasFathometer;
    seaPod.hasWeatherStation = oceanBuilderDetails.weatherStation != null &&
            oceanBuilderDetails.weatherStation.length > 0
        ? true
        : false;
    seaPod.interiorBedroomWallColor =
        oceanBuilderDetails.interiorBedroomWallColor;
    seaPod.kitchenfloorFinishing = oceanBuilderDetails.kitchenfloorFinishing;
    seaPod.kitchenInteriorWallColor =
        oceanBuilderDetails.kitcheninteriorWallColor;
    seaPod.livingRoomInteriorWallColor =
        oceanBuilderDetails.livingRoominteriorWallColor;
    seaPod.livingRoomloorFinishing =
        oceanBuilderDetails.livingRoomloorFinishing;
    seaPod.masterBedroomFloorFinishing = [
      oceanBuilderDetails.masterBedroomfloorFinishing
    ];
    seaPod.masterBedroomInteriorWallColor =
        oceanBuilderDetails.masterBedroominteriorWallColor;
    seaPod.power = oceanBuilderDetails.power;
    seaPod.powerUtilities = oceanBuilderDetails.powerUtilities;
    seaPod.seaPodName = oceanBuilderDetails.obName;
    seaPod.seaPodStatus = 'status';
    seaPod.soundSystem = oceanBuilderDetails.soundSystem;
    seaPod.sparDesign = oceanBuilderDetails.sparDesign;
    seaPod.sparFinish = oceanBuilderDetails.sparFinishing;
    seaPod.underWaterRoomFinishing =
        oceanBuilderDetails.underWaterRoomFinishing;
    seaPod.underWaterWindows = oceanBuilderDetails.underWaterWindows;
    // oceanBuilderDetails.defaultScenes = PredefinedLightData.defaultscenes;

    User userData;

    try {
      var seapodCreationResponse = await _apiBaseHelper.post(
          url: APP_CONFIG.Config.CREATE_NEW_SEAPOD,
          data: seaPod.toJson(),
          headers: _headerManager.authUserHeaders);
      debugPrint('createSeaPod error ============================== ');
      print(seapodCreationResponse);
      userData = User.fromJson(seapodCreationResponse);

      List<UserOceanBuilder> userOceanBuilderList = [];
      userData.seaPods.map((f) {
        UserOceanBuilder userOceanBuilder = UserOceanBuilder();
        userOceanBuilder.oceanBuilderName = f.obName;
        userOceanBuilder.oceanBuilderId = f.id;
        userOceanBuilder.userType = f.users[0].userType;
        userOceanBuilder.accessTime = Duration(hours: 48);
        userOceanBuilder.checkInDate = null;
        userOceanBuilder.reqStatus = 'NA';
        userOceanBuilder.vessleCode = f.vessleCode;
        userOceanBuilderList.add(userOceanBuilder);
      }).toList();

      userData.accessRequests.map((f) {
        // debugPrint('accessRequests --------  ${f.seaPod.name}');
        UserOceanBuilder userOceanBuilder = UserOceanBuilder();
        userOceanBuilder.accessRequestID = f.id;
        userOceanBuilder.oceanBuilderName = f.seaPod.name;
        userOceanBuilder.vessleCode = f.seaPod.vessleCode;
        userOceanBuilder.oceanBuilderId = f.seaPod.id;
        userOceanBuilder.userType = f.type;
        userOceanBuilder.accessTime = Duration(milliseconds: f.period);
        userOceanBuilder.checkInDate =
            DateTime.fromMicrosecondsSinceEpoch(f.checkIn);
        userOceanBuilder.reqStatus = f.status;
        if (userOceanBuilder.reqStatus
                .compareTo(NotificationConstants.pending) ==
            0) userOceanBuilderList.add(userOceanBuilder);
      }).toList();

      // userOceanBuilderList.map((f) {
      //   // debugPrint('userOceanBuilder --------  ${f.oceanBuilderName}');
      // }).toList();

      userData.userOceanBuilder = userOceanBuilderList;

      if (userData.emergencyContacts != null &&
          userData.emergencyContacts.length > 0) {
        userData.emergencyContact = userData.emergencyContacts[0];
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Seapod creation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      //       'createSeaPod error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Seapod creation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    if (userData != null) {
      responseStatus.status = 200;
      authenticatedUser = userData;
    }

    isLoading = false;
    notifyListeners();
    return responseStatus;
  }

  // ------------------------------------------------------- Update User Profile ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> updateUserProfile(User user) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    Map<String, dynamic> userProfile = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'mobileNumber': user.phone,
      'email': user.email,
      'country': user.country,
    };

    try {
      final Response userProfileUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_USER_PROFILE,
          headers: _headerManager.authUserHeaders,
          data: userProfile);

      if (userProfileUpdateResponse != null &&
          userProfileUpdateResponse.statusCode == 200) {
        // debugPrint('updated user data ----------- $userProfileUpdateResponse');

        authenticatedUser.firstName = user.firstName;
        authenticatedUser.lastName = user.lastName;
        authenticatedUser.phone = user.phone;
        authenticatedUser.email = user.email;
        authenticatedUser.country = user.country;

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'User Profile Update Failed';
        responseStatus.message = userProfileUpdateResponse.statusMessage;
        responseStatus.status = userProfileUpdateResponse.statusCode;
        // debugPrint(
        // 'updateUserProfile error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'User Profile Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'updateUserProfile error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'User Profile Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      ;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Update User Password ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> updateUserPassword(
      String currentPassword, String newPassword) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    Map<String, dynamic> updatePassword = {
      "currentPassword": currentPassword,
      "newPassword": newPassword
    };

    try {
      final Response userPasswordUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_USER_PASSWORD,
          headers: _headerManager.headers,
          data: updatePassword);
      // debugPrint(
      // 'update password response ============================== $userPasswordUpdateResponse');

      if (userPasswordUpdateResponse != null &&
          userPasswordUpdateResponse.statusCode == 200) {
        // debugPrint(
        // 'updated user password ----------- $userPasswordUpdateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'User Password Update Failed';
        responseStatus.message = userPasswordUpdateResponse.statusMessage;
        responseStatus.status = userPasswordUpdateResponse.statusCode;
        // debugPrint(
        // 'updateUserPassword error ============================== $userPasswordUpdateResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'User Password Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'updateUserPassword error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'User Password Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      ;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Update SeaPod Name ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> updateSeapodName(
      String seaPodId, String newName) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    Map<String, dynamic> updateSeaPodName = {
      "seapodName": newName,
    };

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response seaPodNameUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_SEAPOD_NAME(seaPodId),
          headers: _headerManager.authUserHeaders,
          data: updateSeaPodName);
      // debugPrint(
      // 'update seaPodName response ============================== $seaPodNameUpdateResponse');

      if (seaPodNameUpdateResponse != null &&
          seaPodNameUpdateResponse.statusCode == 200) {
        // debugPrint(
        // 'updated seaPodName password ----------- $seaPodNameUpdateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'SeaPod Name Update Failed';
        responseStatus.message = seaPodNameUpdateResponse.statusMessage;
        responseStatus.status = seaPodNameUpdateResponse.statusCode;
        // debugPrint(
        // 'seaPod name update error ============================== $seaPodNameUpdateResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'SeaPod Name Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'update seaPod name error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'SeaPod Name Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Send Access Request To Existing User( POST ) --------------------------------------------------------------------

  Future<ResponseStatus> sendAccessReq(User user, String vesselCode) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    Duration accessTime = ListHelper.getAccessTimeMap()[user.requestAccessTime];
    if (accessTime == null) {
      accessTime =
          ListHelper.getAccessTimeMap()[ListHelper.getAccessTimeList()[7]];
    }

    Map<String, dynamic> requsetAccess = {
      'type': user.userType,
      'period': accessTime.inMilliseconds,
      'vessleCode': vesselCode,
      'checkIn': user.checkInDate.millisecondsSinceEpoch
    };

    debugPrint(
        'request access with map ------------- ${requsetAccess.toString()} ');

    try {
      var sendRequestResponse = await _apiBaseHelper.postForResponse(
          url: APP_CONFIG.Config.SEND_ACCESS_REQ_EXISTING_USER,
          headers: _headerManager.authUserHeaders,
          data: requsetAccess);

      if (sendRequestResponse != null &&
          sendRequestResponse.statusCode == 200) {
        // debugPrint('send access req response ----------- $sendRequestResponse');

        authenticatedUser.firstName = user.firstName;
        authenticatedUser.lastName = user.lastName;
        authenticatedUser.phone = user.phone;
        authenticatedUser.email = user.email;
        authenticatedUser.country = user.country;

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Access Request Sending Failed';
        responseStatus.message = sendRequestResponse.statusMessage;
        responseStatus.status = sendRequestResponse.statusCode;
        // debugPrint(
        // 'sendRequestResponse error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Access Request Sending Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'sendRequestResponse error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Access Request Sending Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Send Access Request To New User ( POST FOR RESPONSE ) --------------------------------------------------------------------

  Future<ResponseStatus> sendAccessReqForNewuser(
      User user, String vesselCode) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    Duration accessTime = ListHelper.getAccessTimeMap()[user.requestAccessTime];

    Map<String, dynamic> userData = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'mobileNumber': user.phone,
      'password': user.password,
      'country': user.country
    };

    Map<String, dynamic> requsetAccess = {
      'type': user.userType,
      'period': accessTime.inMilliseconds,
      'vessleCode': vesselCode,
      'checkIn': user.checkInDate.millisecondsSinceEpoch
    };

    Map<String, dynamic> reqMap = {'user': userData, 'request': requsetAccess};

    try {
      Response sendRequestResponse = await _apiBaseHelper.postForResponse(
          url: APP_CONFIG.Config.SEND_ACCESS_REQ_NEW_USER,
          headers: _headerManager.headers,
          data: reqMap);
      // debugPrint(
      // 'send access req response new user ======== $sendRequestResponse');

      if (sendRequestResponse.headers.value("X-Auth-Token") != null) {
        user.xAuthToken = sendRequestResponse.headers.value("X-Auth-Token");
        SharedPrefHelper.setAuthKey(
            sendRequestResponse.headers.value("X-Auth-Token"));

        await autoLogin();
// S1D07EDS1D
        // debugPrint(
        // 'autoLogin response in sendAccessReqNew ~~~~~~~~~~~~~~~~~~~~~~~ -- ${authenticatedUser.toJson()}');
      } else {
        // debugPrint('error code ');
        responseStatus.code = 'Registration Failed';
        if (sendRequestResponse.statusMessage.contains('duplicate key error')) {
          responseStatus.message = 'User already exists';
        } else {
          responseStatus.message = sendRequestResponse.statusMessage;
        }
        responseStatus.status = sendRequestResponse.statusCode;
      }

      if (authenticatedUser.userID != null) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Access Request Sending Failed';
        if (sendRequestResponse.statusMessage.contains('duplicate key error')) {
          responseStatus.message = 'User already exists';
        } else {
          responseStatus.message = sendRequestResponse.statusMessage;
        }
        responseStatus.status = sendRequestResponse.statusCode;
        // debugPrint(
        // 'sendRequestResponse error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Access Request Sending Failed';
      // responseStatus.message = ea.message;
      if (ea.message.contains('duplicate key error')) {
        responseStatus.message = 'User already exists';
      } else {
        responseStatus.message = ea.message;
      }
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'sendRequestResponse error FetchDataException ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Access Request Sending Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;

      // debugPrint(
      // 'sendRequestResponse error BadRequestException ============================== ${ea.message}');
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Cancel Access Request ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> cancelAccessReqeust(String accessRequestId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response seaPodNameUpdateResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.CANCEL_ACCESS_REQ(accessRequestId),
        headers: _headerManager.authUserHeaders,
      );
      // debugPrint(
      // 'cancelAccessReqeust response ============================== $seaPodNameUpdateResponse');

      if (seaPodNameUpdateResponse != null &&
          seaPodNameUpdateResponse.statusCode == 200) {
        // debugPrint(
        // 'cancelAccessReqeust password ----------- $seaPodNameUpdateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Cancel Access Request Failed';
        responseStatus.message = seaPodNameUpdateResponse.statusMessage;
        responseStatus.status = seaPodNameUpdateResponse.statusCode;
        // debugPrint(
        // 'Cancel Access Request update error ============================== $seaPodNameUpdateResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Cancel Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Cancel Access Request error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Cancel Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Accept Access Request ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> acceptAccessReqeust(
      String accessRequestId, String type, int period) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    Map<String, dynamic> reqMap = {'type': type, 'period': period};

    try {
      final Response acceptAccessRequestResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.ACCEPT_ACCESS_REQ(accessRequestId),
          headers: _headerManager.authUserHeaders,
          data: reqMap);

      // debugPrint(
      // 'AcceptAccessReqeust response ============================== $acceptAccessRequestResponse');

      if (acceptAccessRequestResponse != null &&
          acceptAccessRequestResponse.statusCode == 200) {
        // debugPrint(
        // 'Accept Access Request----------- $acceptAccessRequestResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Accept Access Request Failed';
        responseStatus.message = acceptAccessRequestResponse.statusMessage;
        responseStatus.status = acceptAccessRequestResponse.statusCode;
        // debugPrint(
        // 'Accept Access Request update error ============================== $acceptAccessRequestResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Accept Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Accept Access Request error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Accept Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Reject Access Request ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> rejectAccessReqeust(String accessRequestId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response acceptAccessRequestResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.REJECT_ACCESS_REQ(accessRequestId),
        headers: _headerManager.authUserHeaders,
      );

      // debugPrint('Reject Access Request response ============================== $acceptAccessRequestResponse');

      if (acceptAccessRequestResponse != null &&
          acceptAccessRequestResponse.statusCode == 200) {
        // debugPrint(
        // 'Reject Access Request----------- $acceptAccessRequestResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Reject Access Request Failed';
        responseStatus.message = acceptAccessRequestResponse.statusMessage;
        responseStatus.status = acceptAccessRequestResponse.statusCode;
        // debugPrint(
        // 'Reject Access Request update error ============================== $acceptAccessRequestResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Reject Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Reject Access Request error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Reject Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Get Access Request( GET ) --------------------------------------------------------------------

  Future<AccessEvent> getAccessRequest(String accessReqId) async {
    ResponseStatus responseStatus = ResponseStatus();
    AccessEvent accessRequest;

    // Map<String, String> _authUserHeaders = {};
    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      var accressReqResponse = await _apiBaseHelper.get(
          url: APP_CONFIG.Config.GET_ACCESS_REQUEST(accessReqId),
          headers: _headerManager.authUserHeaders);

      // notificationResponse

      accessRequest = AccessEvent.fromJson(accressReqResponse);
      // debugPrint('Get Access Request data  ----------- ${accessRequest.user.name}');

    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Get Access Request ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      ;
    }

    if (accessRequest != null) {
      responseStatus.status = 200;
      _isUserAuthenticated = true;
    }

    return accessRequest;
  }

  // ------------------------------------------------------- Send Invitation ( POST ) --------------------------------------------------------------------

  Future<ResponseStatus> sendInvitation(
      User user, String seapodId, String permissionSetId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
/*     Map<String, String> _authUserHeaders = {};

    String authToken = await SharedPrefHelper.getAuthKey();
    _authUserHeaders.addAll({
      "X-Auth-Token": authToken,
    });
 */

    await _headerManager.initalizeAuthenticatedUserHeaders();

    Map<String, dynamic> userDataMap = {
      'email': user.email,
      'type': user.userType,
      'permissionSetId': permissionSetId
    };

    try {
      var accessInvitaitonResponse = await _apiBaseHelper.post(
          url: APP_CONFIG.Config.SEND_ACCESS_INVITATION(seapodId),
          headers: _headerManager.authUserHeaders,
          data: userDataMap);
      // debugPrint('Send Invitation response ======== $accessInvitaitonResponse');

      AccessEvent accessRequestDetail =
          AccessEvent.fromJson(accessInvitaitonResponse);

      if (accessRequestDetail.id != null) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Access Invitation Sending Failed';
        responseStatus.message = accessInvitaitonResponse.statusMessage;
        responseStatus.status = accessInvitaitonResponse.statusCode;
        // debugPrint(
        // 'sendInvitationResponse error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Access Invitation Sending Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'sendInvitationResponse error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Access Invitation Sending Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Accept Access Invitation ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> acceptAccessnvitation(
      AccessEvent accessRequest) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response acceptAccessRequestResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.ACCEPT_ACCESS_INVITATION(accessRequest.id),
          headers: _headerManager.authUserHeaders,
          data: accessRequest.toJson());

      // debugPrint(
      // 'AcceptAccessInvitation response ============================== $acceptAccessRequestResponse');

      if (acceptAccessRequestResponse != null &&
          acceptAccessRequestResponse.statusCode == 200) {
        // debugPrint(
        // 'Accept Access Invitation----------- $acceptAccessRequestResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Accept Access Invitation Failed';
        responseStatus.message = acceptAccessRequestResponse.statusMessage;
        responseStatus.status = acceptAccessRequestResponse.statusCode;
        // debugPrint(
        // 'Accept Access Invitation update error ============================== $acceptAccessRequestResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Accept Access Invitation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Accept Access Invitation error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Accept Access Invitation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Rejct Access Invitation ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> rejectAccessnvitation(
      AccessEvent accessRequest) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response acceptAccessRequestResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.REJECT_ACCESS_INVITATION(accessRequest.id),
        headers: _headerManager.authUserHeaders,
      );

      // debugPrint(
      // 'RejctAccessInvitation response ============================== $acceptAccessRequestResponse');

      if (acceptAccessRequestResponse != null &&
          acceptAccessRequestResponse.statusCode == 200) {
        // debugPrint(
        // 'Rejct Access Invitation----------- $acceptAccessRequestResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Rejct Access Invitation Failed';
        responseStatus.message = acceptAccessRequestResponse.statusMessage;
        responseStatus.status = acceptAccessRequestResponse.statusCode;
        // debugPrint(
        // 'Rejct Access Invitation update error ============================== $acceptAccessRequestResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Rejct Access Invitation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Rejct Access Invitation error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Rejct Access Invitation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Cancel Access Invitation ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> cancelAccessnvitation(
      AccessEvent accessRequest) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response acceptAccessRequestResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.CANCEL_ACCESS_INVITATION(accessRequest.id),
        headers: _headerManager.authUserHeaders,
      );

      // debugPrint(
      // 'CancelAccessInvitation response ============================== $acceptAccessRequestResponse');

      if (acceptAccessRequestResponse != null &&
          acceptAccessRequestResponse.statusCode == 200) {
        // debugPrint(
        // 'Cancel Access Invitation----------- $acceptAccessRequestResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Cancel Access Invitation Failed';
        responseStatus.message = acceptAccessRequestResponse.statusMessage;
        responseStatus.status = acceptAccessRequestResponse.statusCode;
        // debugPrint(
        // 'Cancel Access Invitation update error ============================== $acceptAccessRequestResponse');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Cancel Access Invitation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Cancel Access Invitation error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Cancel Access Invitation Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Delete Member From SeaPod ( DELETE ) --------------------------------------------------------------------

  Future<ResponseStatus> removeMemberFromSeapod(
      String seapoID, String userId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response removeUserResponse = await _apiBaseHelper.del(
        url: APP_CONFIG.Config.REMOVE_MEMBER(seapoID, userId),
        headers: _headerManager.authUserHeaders,
      );

      if (removeUserResponse != null && removeUserResponse.statusCode == 200) {
        // debugPrint('Remove Member data ----------- $removeUserResponse');

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Remove Member Failed';
        responseStatus.message = removeUserResponse.statusMessage;
        responseStatus.status = removeUserResponse.statusCode;
        // debugPrint(
        // 'Remove Member error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Remove Member Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Remove Member error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Remove Member Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Get Notifications ( GET ) --------------------------------------------------------------------

  Future<void> getNotifications() async {
    ResponseStatus responseStatus = ResponseStatus();
    NotificationList notificationList;

    // Map<String, String> _authUserHeaders = {};
    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      var notificationResponse = await _apiBaseHelper.get(
          url: APP_CONFIG.Config.GET_NOTIFICATIONS,
          headers: _headerManager.authUserHeaders);

      // notificationResponse

      notificationList = NotificationList.fromJson(notificationResponse);
      // debugPrint('Get Notifications count  ----------- ${notificationList.notifications?.length}');

    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Notifications Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Get Notifications error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Notifications Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      ;
    }

    if (notificationList != null) {
      authenticatedUser.notifications = notificationList.notifications;
      responseStatus.status = 200;
      _isUserAuthenticated = true;
    }
  }

  // ------------------------------------------------------- Get Access Events ( GET ) --------------------------------------------------------------------

  Future<AccessEvents> getAccessEvents() async {
    ResponseStatus responseStatus = ResponseStatus();
    AccessEvents accessEvents;

    // Map<String, String> _authUserHeaders = {};
    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      var accessEventsResponse = await _apiBaseHelper.get(
          url: APP_CONFIG.Config.GET_ACCESS_EVENTS,
          headers: _headerManager.authUserHeaders);

      // notificationResponse

      accessEvents = AccessEvents.fromJson(accessEventsResponse);
      // debugPrint('Get Notifications count  ----------- ${notificationList.notifications?.length}');

    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Access Events Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Get Notifications error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Access Events Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    return accessEvents;
  }

  // ------------------------------------------------------- Add Emergency Contact ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> addEmergencyContact(User user) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    Map<String, dynamic> emergencyContact = {
      'firstName': user.emergencyContact.firstName,
      'lastName': user.emergencyContact.lastName,
      'mobileNumber': user.emergencyContact.phone,
      'email': user.emergencyContact.email,
    };

    try {
      final Response emergencyContactAddResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.ADD_EMERGENCY_CONTACT,
          headers: _headerManager.authUserHeaders,
          data: emergencyContact);

      if (emergencyContactAddResponse != null &&
          emergencyContactAddResponse.statusCode == 200) {
        // debugPrint('Add Emergency Contact data ----------- $emergencyContactAddResponse');

        if (authenticatedUser.emergencyContact == null)
          authenticatedUser.emergencyContact = EmergencyContact();

        authenticatedUser.emergencyContact.firstName =
            user.emergencyContact.firstName;
        authenticatedUser.emergencyContact.lastName =
            user.emergencyContact.lastName;
        authenticatedUser.emergencyContact.phone = user.emergencyContact.phone;
        authenticatedUser.emergencyContact.email = user.emergencyContact.email;

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Emergency Contact Add Failed';
        responseStatus.message = emergencyContactAddResponse.statusMessage;
        responseStatus.status = emergencyContactAddResponse.statusCode;
        // debugPrint(
        // 'Add Emergency Contact error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Emergency Contact Add Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Emergency Contact Add error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Emergency Contact Add Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Update Emergency Contact ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> updateEmergencyContact(User user) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    Map<String, dynamic> emergencyContact = {
      '_id': user.emergencyContact.id,
      'firstName': user.emergencyContact.firstName,
      'lastName': user.emergencyContact.lastName,
      'mobileNumber': user.emergencyContact.phone,
      'email': user.emergencyContact.email,
    };

    try {
      final Response emergencyContactUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_EMERGENCY_CONTACT(
              user.emergencyContact.id),
          headers: _headerManager.authUserHeaders,
          data: emergencyContact);

      if (emergencyContactUpdateResponse != null &&
          emergencyContactUpdateResponse.statusCode == 200) {
        // debugPrint('Update Emergency Contact data ----------- $emergencyContactUpdateResponse');

        authenticatedUser.emergencyContact.firstName =
            user.emergencyContact.firstName;
        authenticatedUser.emergencyContact.lastName =
            user.emergencyContact.lastName;
        authenticatedUser.emergencyContact.phone = user.emergencyContact.phone;
        authenticatedUser.emergencyContact.email = user.emergencyContact.email;

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Emergency Contact Update Failed';
        responseStatus.message = emergencyContactUpdateResponse.statusMessage;
        responseStatus.status = emergencyContactUpdateResponse.statusCode;
        // debugPrint(
        // 'Emergency Contact Update error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Emergency Contact Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Emergency Contact Update error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Emergency Contact Update Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Delete Emergency Contact ( DELETE ) --------------------------------------------------------------------

  Future<ResponseStatus> deleteEmergencyContact(
      String emergencyContactId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    try {
      final Response emergencyContactUpdateResponse = await _apiBaseHelper.del(
        url: APP_CONFIG.Config.UPDATE_EMERGENCY_CONTACT(emergencyContactId),
        headers: _headerManager.authUserHeaders,
      );

      if (emergencyContactUpdateResponse != null &&
          emergencyContactUpdateResponse.statusCode == 200) {
        // debugPrint('Delete Emergency Contact data ----------- $emergencyContactUpdateResponse');

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Delete Emergency Contact Failed';
        responseStatus.message = emergencyContactUpdateResponse.statusMessage;
        responseStatus.status = emergencyContactUpdateResponse.statusCode;
        // debugPrint(
        // 'Delete Emergency Contact error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Delete Emergency Contact Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Delete Emergency Contact error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Delete Emergency Contact Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // createLightScene

  // ------------------------------------------------------- Create Light Scene ( POST ) --------------------------------------------------------------------

  Future<ResponseStatus> createLightScene(
      String seapodId, Scene lighScene) async {
    print('Create new light scene');
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    Map<String, dynamic> lighSceneMap = lighScene.toJson();
    lighSceneMap.remove('_id');
    lighSceneMap.remove('userId');
    lighSceneMap.remove('seapodId');

    List<Map<String, dynamic>> r_ooms = lighSceneMap['rooms'];

    r_ooms.map((f) {
      f.remove('_id');
    }).toList();

    print('---------------------------------------------------');

    print(lighSceneMap.toString());

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      var lighSceneCreationResponse = await _apiBaseHelper.post(
          url: APP_CONFIG.Config.CREATE_UPDATE_LIGHT_SCENE(seapodId),
          headers: _headerManager.authUserHeaders,
          data: lighSceneMap);
      // print('lighSceneCreationResponse ===================================');
      Scene createdLightScene = Scene.fromJson(lighSceneCreationResponse);
      // print(createdLightScene.toJson());

      if (createdLightScene.id != null) {
        responseStatus.status = 200;
        responseStatus.message = createdLightScene.id;
      } else {
        responseStatus.code = 'Create Light Scene Failed';
        responseStatus.message = lighSceneCreationResponse.statusMessage;
        responseStatus.status = lighSceneCreationResponse.statusCode;
        // debugPrint(
        // 'Create Light Scene error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Create Light Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Create Light Scene error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Create Light Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Update Lighting Scene ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> updateLightingScene(
      String seapodId, Scene lighScene) async {
    print('Update light scene');
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response lightingSceneUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.CREATE_UPDATE_LIGHT_SCENE(seapodId),
          headers: _headerManager.authUserHeaders,
          data: lighScene.toJson());

      if (lightingSceneUpdateResponse != null &&
          lightingSceneUpdateResponse.statusCode == 200) {
        // debugPrint('Update Lighting Scene data ----------- $lightingSceneUpdateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update Lighting Scene Failed';
        responseStatus.message = lightingSceneUpdateResponse.statusMessage;
        responseStatus.status = lightingSceneUpdateResponse.statusCode;
        // debugPrint(
        // 'Update Lighting Scene error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Lighting Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Update Lighting Scene error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Lighting Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Update All Lighting Scene ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> updateAllLightingScene(
      List<Scene> lighScenes, String seaPodId, String source) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response lightingSceneUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_ALL_LIGHT_SCENES(seaPodId, source),
          headers: _headerManager.authUserHeaders,
          data: lighScenes.map((f) {
            return f.toJson();
          }).toList());

      if (lightingSceneUpdateResponse != null &&
          lightingSceneUpdateResponse.statusCode == 200) {
        // debugPrint('Update All Lighting Scenes data ----------- $lightingSceneUpdateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update All Lighting Scenes Failed';
        responseStatus.message = lightingSceneUpdateResponse.statusMessage;
        responseStatus.status = lightingSceneUpdateResponse.statusCode;
        // debugPrint(
        // 'Update All Lighting Scenes error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update All Lighting Scenes Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Update All Lighting Scenes error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update All Lighting Scenes Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Delete Lighting Scene ( DELETE ) --------------------------------------------------------------------

  Future<ResponseStatus> deleteLightingScene(String lightingSceneId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    // Map<String, String> _authUserHeaders = {};

    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    try {
      var deleteLightingSceneResponse = await _apiBaseHelper.del(
          url: APP_CONFIG.Config.DELETE_LIGHT_SCENE(lightingSceneId),
          headers: _headerManager.authUserHeaders);

      // print(deleteLightingSceneResponse);

      if (deleteLightingSceneResponse != null) {
        // debugPrint('Delete Lighting Scene data ----------- $deleteLightingSceneResponse');

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Delete Lighting Scene Failed';
        responseStatus.message = deleteLightingSceneResponse.statusMessage;
        responseStatus.status = deleteLightingSceneResponse.statusCode;
        // debugPrint(
        // 'Delete Lighting Scene error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Delete Lighting Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Delete Lighting Scene FetchDataException ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Delete Lighting Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Delete Lighting Scene BadRequestException ============================== ${ea.message}');
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

// ------------------------------------------------------- Update Notification Seen/Unseen Status ( PUT ) --------------------------------------------------------------------

  Future<void> updateNotificationReadStatus(String notificationId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response notificationSeenStateResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.UPDATE_NOTIFICATION_SEEN_STATUS(notificationId),
        headers: _headerManager.authUserHeaders,
      );

      if (notificationSeenStateResponse != null &&
          notificationSeenStateResponse.statusCode == 200) {
        // debugPrint('Update Notification Read Status data ----------- $notificationSeenStateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update Notification Read Status Failed';
        responseStatus.message = notificationSeenStateResponse.statusMessage;
        responseStatus.status = notificationSeenStateResponse.statusCode;
        // debugPrint(
        // 'Update Notification Read Status error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Notification Read Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Update Notification Read Status error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Notification Read Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Update bulk Notifications Seen/Unseen Status ( PUT ) --------------------------------------------------------------------

  Future<void> updateBulkNotificationReadStatus(String notificationId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    Map<String, dynamic> notificationIds = {
      'notificationIds': [notificationId]
    };

    try {
      final Response notificationSeenStateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_BULK_NOTIFICATION_SEEN_STATUS,
          headers: _headerManager.authUserHeaders,
          data: notificationIds);

      if (notificationSeenStateResponse != null &&
          notificationSeenStateResponse.statusCode == 200) {
        // debugPrint('Update Notification Read Status data ----------- $notificationSeenStateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update Notification Read Status Failed';
        responseStatus.message = notificationSeenStateResponse.statusMessage;
        responseStatus.status = notificationSeenStateResponse.statusCode;
        // debugPrint(
        // 'Update Notification Read Status error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Notification Read Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Update Notification Read Status error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Notification Read Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Get Permissions ( GET ) --------------------------------------------------------------------

  Future<void> getPermissions() async {
    ResponseStatus responseStatus = ResponseStatus();
    NotificationList notificationList;

    // Map<String, String> _authUserHeaders = {};
    // String authToken = await SharedPrefHelper.getAuthKey();
    // _authUserHeaders.addAll({
    //   "X-Auth-Token": authToken,
    // });

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      var notificationResponse = await _apiBaseHelper.get(
          url: APP_CONFIG.Config.GET_NOTIFICATIONS,
          headers: _headerManager.authUserHeaders);

      // notificationResponse

      notificationList = NotificationList.fromJson(notificationResponse);
      // debugPrint('Get Notifications count  ----------- ${notificationList.notifications?.length}');

    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Notifications Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Get Notifications error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Notifications Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      ;
    }

    if (notificationList != null) {
      authenticatedUser.notifications = notificationList.notifications;
      responseStatus.status = 200;
      _isUserAuthenticated = true;
    }
  }

// ------------------------------------------------------------ Set weather srouce (PUT) -------------------------------------------------------------

  // ------------------------------------------------------- Update All Lighting Scene ( PUT ) --------------------------------------------------------------------

  Future<ResponseStatus> setWeatherSource(String weatherSource) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      final Response response = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.SET_WEATHER_SOURCE(weatherSource),
        headers: _headerManager.authUserHeaders,
      );

      if (response != null && response.statusCode == 200) {
        // debugPrint('Set Weather Source  data ----------- $lightingSceneUpdateResponse');
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Set Weather Source Failed';
        responseStatus.message = response.statusMessage;
        responseStatus.status = response.statusCode;
        // debugPrint(
        // 'Set Weather Source  error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Set Weather Source ';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'Set Weather Source error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Set Weather Source ';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

//######################################################################################################################################################

  Future<void> signOut() async {
    // await _auth.signOut();
    _isUserAuthenticated = false;
    authenticatedUser = null;
    await SharedPrefHelper.setCurrentOB(' ');
    await SharedPrefHelper.setProfilePicFilePath(' ');
    await SharedPrefHelper.setAuthKey('');
    await FileUtils.removeProfilePicture();
  }
}

class ResponseStatus {
  int status;
  String code;
  String message;

  ResponseStatus({this.status, this.code, this.message});
}

class OceanBuilderInfo {
  String documentId;
  String vesselCode;
  String obName;
}
