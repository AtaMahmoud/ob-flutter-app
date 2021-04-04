import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:ocean_builder/helper/app_exception.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';

class LightControlDemoRepo {
  List<Light> lightList = [
    Light(
        id: 1,
        status: true,
        desc: "Middle Hallway",
        type: "strip",
        group: "hallways",
        color: 0x000000,
        ata: "ATA 32 00-100-125"),
    Light(
        id: 2,
        status: true,
        desc: "Middle Hallway",
        type: "strip",
        group: "hallways",
        color: 0x000000,
        ata: "ATA 32 00-100-125"),
    Light(
        id: 3,
        status: true,
        desc: "Middle Hallway",
        type: "strip",
        group: "hallways",
        color: 0x000000,
        ata: "ATA 32 00-100-125"),
    Light(
        id: 4,
        status: true,
        desc: "Middle Hallway",
        type: "strip",
        group: "hallways",
        color: 0x000000,
        ata: "ATA 32 00-100-125"),
  ];
  Future<List<Light>> getLights() async {
    return lightList;
  }

  Future<dynamic> getLightById(int id) async {
    Light light;
    ResponseStatus responseStatus = ResponseStatus(status: 404);
    light = lightList.firstWhere((element) => element.id == id);
    if (light != null) return light;
    return responseStatus;
  }

  Future<dynamic> addLight(Light light) async {
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    lightList.add(light);
    return responseStatus;
  }

  Future<dynamic> updateLight(Light light) async {
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    lightList.removeWhere((element) => element.id == light.id);
    lightList.add(light);
    return responseStatus;
  }

  Future<dynamic> deleteLight(id) async {
    ResponseStatus responseStatus = ResponseStatus();
    responseStatus.status = 200;
    lightList.removeWhere((element) => element.id == id);
    return responseStatus;
  }
}
