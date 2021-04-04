import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:ocean_builder/helper/app_exception.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';

class LightControlRepo {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  String _crudLight = '${Config.BASE_URL}/api/light';
  String _getLightById(id) => '${Config.BASE_URL}/api/lights/$id';

  final Map<String, dynamic> _headers = {
    "x-auth-token": Config.IOT_SERVER_API_KEY,
  };

  Future<List<Light>> getLights() async {
    List<Light> lightList = [];
    final response =
        await _apiBaseHelper.get(url: _crudLight, headers: _headers);
    print(response);
    var responseMap = response as List;

    responseMap.map((json) {
      Light light = Light.fromJson(json);
      lightList.add(light);
    }).toList();

    return lightList;
  }

  Future<dynamic> getLightById(int id) async {
    Light light;
    ResponseStatus responseStatus = ResponseStatus();

    final Map<String, dynamic> _headers = {
      "x-auth-token": Config.IOT_SERVER_API_KEY,
    };

    try {
      var response =
          await _apiBaseHelper.get(url: _getLightById(id), headers: _headers);
      light = Light.fromJson(response);
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Access Request Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }
    if (responseStatus.status == 200) return light;
    return responseStatus;
  }

  Future<dynamic> addLight(Light light) async {
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    final Map<String, dynamic> _headers = {
      "x-auth-token": Config.IOT_SERVER_API_KEY,
    };

    try {
      Response response = await _apiBaseHelper.postForResponse(
          url: _crudLight, headers: _headers, data: light.toJson());
      // debugPrint('Send Invitation response ======== $accessInvitaitonResponse');

      if (response.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Adding Light Failed';
        responseStatus.message = response.statusMessage;
        responseStatus.status = response.statusCode;
        // debugPrint(
        // 'sendInvitationResponse error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Adding Light Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'sendInvitationResponse error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Adding Light Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    return responseStatus;
  }

  Future<dynamic> updateLight(Light light) async {
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    final Map<String, dynamic> _headers = {
      "x-auth-token": Config.IOT_SERVER_API_KEY,
    };

    try {
      Response response = await _apiBaseHelper.put(
          url: _crudLight, headers: _headers, data: light.toJson());
      // debugPrint('Send Invitation response ======== $accessInvitaitonResponse');

      if (response.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Updating Light Failed';
        responseStatus.message = response.statusMessage;
        responseStatus.status = response.statusCode;
        // debugPrint(
        // 'sendInvitationResponse error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Updating Light Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'sendInvitationResponse error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Updating Light Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    return responseStatus;
  }

  Future<dynamic> deleteLight(id) async {
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    final Map<String, dynamic> _headers = {
      "x-auth-token": Config.IOT_SERVER_API_KEY,
    };

    try {
      Response response = await _apiBaseHelper.delete(
          url: _crudLight, headers: _headers, data: id);
      // debugPrint('Send Invitation response ======== $accessInvitaitonResponse');

      if (response.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Deleting Light Failed';
        responseStatus.message = response.statusMessage;
        responseStatus.status = response.statusCode;
        // debugPrint(
        // 'sendInvitationResponse error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Deleting Light Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // debugPrint(
      // 'sendInvitationResponse error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Deleting Light Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    return responseStatus;
  }
}
