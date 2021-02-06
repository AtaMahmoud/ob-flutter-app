import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/helper/app_exception.dart';

class ApiBaseHelper {
  Dio _dio = Dio(BaseOptions(
      connectTimeout: Config.CONNECTION_TIME_OUT,
      receiveTimeout: Config.READ_TIME_OUT));

  ApiBaseHelper() {
    _dio.interceptors.add(LogInterceptor(requestBody: true));
  }

  Future<dynamic> put(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    // debugPrint('header ---- $headers    -- parameters ---- $parameters');

    var responseMap;

    try {
      final Response response = await _dio.put(url,
          queryParameters: parameters,
          options: Options(headers: headers),
          data: data);

      responseMap = response; //_returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);
      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }

  Future<dynamic> delete(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    // debugPrint('header ---- $headers    -- parameters ---- $parameters');

    var responseMap;

    try {
      final Response response = await _dio.delete(url,
          queryParameters: parameters,
          options: Options(headers: headers),
          data: data);

      responseMap = response; //_returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);
      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }

  Future<dynamic> post(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    // debugPrint('header ---- $headers    -- parameters ---- $parameters --------- data  ----------- $data'   );

    var responseMap;

    try {
      final Response response = await _dio.post(url,
          queryParameters: parameters,
          options: Options(headers: headers),
          data: data);

      responseMap = _returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);
      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }

  Future<dynamic> postForResponse(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    var responseMap;

    try {
      final Response response = await _dio.post(url,
          queryParameters: parameters,
          options: Options(headers: headers),
          data: data);

      responseMap = response; // _returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);
      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }

  Future<dynamic> get(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    var responseMap;

    try {
      final Response response = await _dio.get(
        url,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      responseMap = _returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);

      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }

    Future<dynamic> getForResponse(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    var responseMap;

    try {
      final Response response = await _dio.get(
        url,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      responseMap = response;//_returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);

      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }


  Future<dynamic> del(
      {String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> parameters = const {},
      dynamic data = const {}}) async {
    var responseMap;

    try {
      final Response response = await _dio.delete(
        url,
        queryParameters: parameters,
        options: Options(headers: headers),
      );
      responseMap = response; //_returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet connection");
    } on DioError catch (error) {
      String exceptionText = _handleError(error);

      if (error.response != null && error.response.statusCode != null)
        throw FetchDataException(exceptionText, error.response.statusCode);
      else
        throw FetchDataException(exceptionText);
    }

    return responseMap;
  }

/*
400	Bad Request -- Your request is invalid.
401	Unauthorized -- Your API key is invalid.
429	Too Many Requests -- You've reached your daily limit.
500	Internal Server Error -- We had a problem with our server. Try again later.
503	Service Unavailable -- We're temporarily offline for maintenance. Please try again later.
*/

  dynamic _returnResponse(Response response) {
    final decodedResponse = response.data;

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw BadRequestException("key is missing");
    }

    return decodedResponse;
  }

  String _handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send time out";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          try {
            errorDescription = '${error.response.data['message']}';
          } catch (e) {}
          if (errorDescription.length <= 1) {
            errorDescription =
                'Received invalid status code: ${error.response.statusCode}';
          }

          // debugPrint('error Description ---------  ' + errorDescription);

          //"Received invalid status code: ${error.response.statusCode}";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
