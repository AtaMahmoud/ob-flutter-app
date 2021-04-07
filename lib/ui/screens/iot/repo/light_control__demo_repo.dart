import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/providers/user_provider.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:ocean_builder/helper/app_exception.dart';
import 'package:ocean_builder/ui/screens/iot/model/light.dart';
import 'package:ocean_builder/ui/screens/iot/repo/device_control_repo.dart';

List<Light> lightList = [
  Light(
      id: 1,
      status: true,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.red.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 2,
      status: false,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.green.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 3,
      status: true,
      desc: "Middle Hallway",
      name: 'change name',
      brightnessLevel: .50,
      type: "strip",
      group: "hallways",
      color: Colors.blue.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 4,
      status: false,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.orange.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 5,
      status: true,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.yellow.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 6,
      status: false,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.cyan.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 7,
      status: true,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.amber.value,
      ata: "ATA 32 00-100-125"),
  Light(
      id: 8,
      status: true,
      name: 'change name',
      brightnessLevel: .50,
      desc: "Middle Hallway",
      type: "strip",
      group: "hallways",
      color: Colors.brown.value,
      ata: "ATA 32 00-100-125"),
];

class LightControlDemoRepo extends DeviceControlRepo {
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
