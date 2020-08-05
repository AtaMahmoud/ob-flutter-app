import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/es_record.dart';
import 'package:ocean_builder/core/models/user.dart';
import 'package:ocean_builder/core/providers/base_provider.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';
import 'package:ocean_builder/helper/app_exception.dart';
import 'package:ocean_builder/ui/shared/shared_pref_data.dart';
import 'package:ocean_builder/configs/app_configurations.dart' as APP_CONFIG;

class EarthStationDataProvider extends BaseProvider{

 

    ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
    HeadersManager _headerManager = HeadersManager.getInstance();

      // ------------------------------------------------------- Login ( POST ) --------------------------------------------------------------------

  Future<ResponseStatus> logIn({String username, String password}) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    Map<String,dynamic> _userCredentials = {
      "username": "diego@scissorboy.com",
      "password": "BNoM2k5idzcmHfgeIDHb"
    };

    try {
       var loginResponse = await _apiBaseHelper.postForResponse(
          url: APP_CONFIG.Config.ES_LOGIN,
          data: _userCredentials,
          headers: _headerManager.headers);


      if (loginResponse != null && loginResponse.statusCode == 200) {
        // temporary fix for userOceanbuilder

        if (loginResponse.headers.value("X-Auth") != null) {

          SharedPrefHelper.setEsAuthKey(
              loginResponse.headers.value("X-Auth"));

          // // debugPrint('earth stattion loginResponse ~~~~~~~~~~~~~~~~~~~~~~~ -- ${loginResponse.headers.value("X-Auth")}');
        } else {
          // // debugPrint('error code ');
          responseStatus.code = 'Login Failed';
          responseStatus.message = loginResponse.statusMessage;
          responseStatus.status = loginResponse.statusCode;
        }
      } else {
        // // debugPrint('error code ');
        responseStatus.code = 'Login Failed';
        ;
        responseStatus.message = loginResponse.statusMessage;
        responseStatus.status = loginResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Login Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // // debugPrint('logIn  error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Login Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    if (authenticatedUser != null) {
      responseStatus.status = 200;
    }

    isLoading = false;
    notifyListeners();
    return responseStatus;
  }

    // ------------------------------------------------------- Get Records ( POST ) --------------------------------------------------------------------

  Future<EsRecord> getRecords() async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    Map<String, String> _authUserHeaders = {};

    EsRecord esRecord;

    String authToken = await SharedPrefHelper.getEsAuthKey();
    _authUserHeaders.addAll({
      "X-Auth": authToken,
    });

    Map<String,dynamic> _getRecordsParams = {
    "startDate": DateFormat('yyyy-MM-dd').format(new DateTime.now().subtract(Duration(days: 3))),//"2020-03-28",
    "endDate":DateFormat('yyyy-MM-dd').format(new DateTime.now()),
    "startTime":"00:00:00",
    "endTime":"23:59:59"
    }; 

    try {
       var getRecordsResponse = await _apiBaseHelper.postForResponse(
          url: APP_CONFIG.Config.ES_GET_RECORDS,
          headers: _authUserHeaders,
          data: _getRecordsParams);
      if (getRecordsResponse != null &&
          getRecordsResponse.statusCode == 200) {

          esRecord = EsRecord.fromJson(getRecordsResponse.data);

        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Get Records Failed';
        responseStatus.message = getRecordsResponse.statusMessage;
        responseStatus.status = getRecordsResponse.statusCode;
        // // debugPrint('Get Records error ============================== $responseStatus');
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Records Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
      // // debugPrint('Get Records error ============================== ${ea.message}');
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Get Records Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    // if(esRecord!=null)
    //   // print(esRecord);
    //   else
    //   // print(responseStatus);

    return esRecord;
  }

}