import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/core/models/ocean_builder.dart';
import 'package:ocean_builder/core/models/ocean_builder_user.dart';
import 'package:ocean_builder/core/models/permission.dart';
import 'package:ocean_builder/core/models/seapod.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/core/singletons/headers_manager.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:ocean_builder/helper/app_exception.dart';
import 'package:ocean_builder/helper/file_utils.dart';
import 'package:ocean_builder/helper/method_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'base_provider.dart';
import 'package:flutter/services.dart';
import 'package:ocean_builder/configs/app_configurations.dart' as APP_CONFIG;

class OceanBuilderProvider extends BaseProvider {
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  HeadersManager _headerManager = HeadersManager.getInstance();

  Future<SeaPod> getSeaPod(String obId, UserProvider userProvider) async {
    // debugPrint('get SeaPod info for  ' + obId);

    SeaPod seapod;

    userProvider.authenticatedUser.seaPods.map((f) {
      // // debugPrint('comparing with -- ${f.id}');
      if (f.id.compareTo(obId) == 0) {
        seapod = f;
      }
    }).toList();

    // print("got SeaPod  =====================================================");
    // print(seapod?.toJson());

    seapod ??= userProvider.authenticatedUser.seaPods[0];

    // debugPrint('returning seapod -- $seapod');

    return seapod;
  }

// ------------------------------------------------------- crate permission -----------------------------------------------------------------

  Future<ResponseStatus> createPermission(
      String seapodId, PermissionSet permissionSet) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    Map<String, dynamic> permissionMap = permissionSet.toJson();
    permissionMap.remove('_id');

    print('------------------------------create permission ');

// // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      var permissionCreationResponse = await _apiBaseHelper.post(
          url: APP_CONFIG.Config.CREATE_PERMISSION(seapodId),
          headers: _headerManager.authUserHeaders,
          data: permissionMap);
      PermissionSet createdPermissionSet =
          PermissionSet.fromJson(permissionCreationResponse);

      if (createdPermissionSet.id != null) {
        responseStatus.status = 200;
        responseStatus.message = createdPermissionSet.id;
      } else {
        responseStatus.code = 'Create Permission Failed';
        responseStatus.message = permissionCreationResponse.statusMessage;
        responseStatus.status = permissionCreationResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Create Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Create Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- update permission -----------------------------------------------------------------

  Future<ResponseStatus> updatePermission(
      String seapodId, PermissionSet permissionSet) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    Map<String, dynamic> permissionMap = permissionSet.toJson();

    print(
        '------------------------------update permission--------------------');

// // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      Response permissionUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.UPDATE_PERMISSION(seapodId),
          headers: _headerManager.authUserHeaders,
          data: permissionMap);

      if (permissionUpdateResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update Permission Failed';
        responseStatus.message = permissionUpdateResponse.statusMessage;
        responseStatus.status = permissionUpdateResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- rename permission -----------------------------------------------------------------

  Future<ResponseStatus> renamePermission(
      String seapodId, String permissionId, String newName) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    print(
        '------------------------------rename permission--------------------');

// // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      Response permissionUpdateResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.RENAME_PERMISSION(seapodId, permissionId),
          headers: _headerManager.authUserHeaders,
          data: {'Name': newName});

      if (permissionUpdateResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Rename Permission Failed';
        responseStatus.message = permissionUpdateResponse.statusMessage;
        responseStatus.status = permissionUpdateResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Rename Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Rename Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

// ------------------------------------------------------- delete permission -----------------------------------------------------------------

  Future<ResponseStatus> deletePermission(
      String seapodId, String permissionSetId) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    print('------------------------------delete permission ');

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      Response permissionDeleteResponse = await _apiBaseHelper.delete(
          url: APP_CONFIG.Config.DELETE_PERMISSION(seapodId, permissionSetId),
          headers: _headerManager.authUserHeaders);

      if (permissionDeleteResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Delete Permission Failed';
        responseStatus.message = permissionDeleteResponse.statusMessage;
        responseStatus.status = permissionDeleteResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Delete Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Delete Permission Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Toogle light scene status  -----------------------------------------------------------------

  Future<ResponseStatus> toogleLightSceneStatus({String seapodId}) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    print(
        '------------------------------toogle light scene on/off--------------------');

// // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      Response toogleLightSceneResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.TOOGLE_LIGHT_SCENE_STATUS(seapodId),
        headers: _headerManager.authUserHeaders,
      );

      if (toogleLightSceneResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Toogle Light Scene Status Failed';
        responseStatus.message = toogleLightSceneResponse.statusMessage;
        responseStatus.status = toogleLightSceneResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Toogle Light Scene Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Toogle Light Scene Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- Toogle light status -----------------------------------------------------------------

  Future<ResponseStatus> toogleLightStatus(
      {String sceneId, String lightId}) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    print(
        '------------------------------toogle light scene on/off--------------------');

// // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    Map<String, dynamic> reqMap = {
      "lightId": lightId,
    };

    try {
      Response toogleLightSceneResponse = await _apiBaseHelper.put(
          url: APP_CONFIG.Config.TOOGLE_LIGHT_STATUS(sceneId),
          headers: _headerManager.authUserHeaders,
          data: reqMap);

      print(toogleLightSceneResponse.statusCode);

      if (toogleLightSceneResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Toogle Light Status Failed';
        responseStatus.message = toogleLightSceneResponse.statusMessage;
        responseStatus.status = toogleLightSceneResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Toogle Light Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Toogle Light Status Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- update light scene intensity  -----------------------------------------------------------------

  Future<ResponseStatus> updateLightSceneIntensity(
      {String seapodId, int intensity}) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    print(
        '------------------------------update light scene intensity--------------------');

    // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      Response updateSelectedLightSceneResponse = await _apiBaseHelper.put(
        url:
            APP_CONFIG.Config.UPDATE_LIGHT_SCENE_INTENSITY(seapodId, intensity),
        headers: _headerManager.authUserHeaders,
      );

      if (updateSelectedLightSceneResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update Light Scene Intensity Failed';
        responseStatus.message = updateSelectedLightSceneResponse.statusMessage;
        responseStatus.status = updateSelectedLightSceneResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Light Scene Intensity Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Light Scene Intensity Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

  // ------------------------------------------------------- update light scene intensity  -----------------------------------------------------------------

  Future<ResponseStatus> updateSelectedLightScene(
      {String seapodId, String lightSceneId}) async {
    isLoading = true;
    notifyListeners();
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;

    print(
        '------------------------------update selected light scene--------------------');

    // print(lighSceneMap);

    await _headerManager.initalizeAuthenticatedUserHeaders();

    try {
      Response updateSelectedLightSceneResponse = await _apiBaseHelper.put(
        url: APP_CONFIG.Config.UPDATE_SELECTED_LIGHTING_SCENE(
            seapodId, lightSceneId),
        headers: _headerManager.authUserHeaders,
      );

      if (updateSelectedLightSceneResponse.statusCode == 200) {
        responseStatus.status = 200;
      } else {
        responseStatus.code = 'Update Selected Light Scene Failed';
        responseStatus.message = updateSelectedLightSceneResponse.statusMessage;
        responseStatus.status = updateSelectedLightSceneResponse.statusCode;
      }
    } on FetchDataException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Selected Light Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    } on BadRequestException catch (e) {
      AppException ea = e;
      responseStatus.code = 'Update Selected Light Scene Failed';
      responseStatus.message = ea.message;
      responseStatus.status = ea.statusCode;
    }

    isLoading = false;
    notifyListeners();

    return responseStatus;
  }

//######################################################################################################################################################

  Future<File> _generateQrCodeImage(String oceanBuilderId) async {
    QrPainter qrPainter = QrPainter(
      data: oceanBuilderId,
      version: 5,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    final ByteData imageData = await qrPainter.toImageData(500.0);
    File file = await FileUtils.localFile('obqr.png'); //File('./obqr.png');
    file = await file.writeAsBytes(imageData.buffer.asUint8List());

    return file;
  }

  Future<String> scan() async {
    String qrcode;
    try {
      String barcode = await BarcodeScanner.scan().toString();
      qrcode = barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // 'The user did not grant the camera permission!'
        qrcode = null;
      } else {
        // 'Unknown error: $e'
        qrcode = 'Unknown error: $e';
      }
    } on FormatException {
      // 'null (User returned using the "back"-button before scanning anything. Result)'
      qrcode = null;
    } catch (e) {
      qrcode = 'Unknown error: $e';
    }
    return qrcode;
  }

  // Future<String> _uploadImage(File qrCodeImage) async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();

  //   StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
  //   StorageUploadTask uploadTask = ref.putFile(qrCodeImage);
  //   StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

  //   String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

  //   return downloadUrl;
  // }

}
