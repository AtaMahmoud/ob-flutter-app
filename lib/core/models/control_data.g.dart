// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'control_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ControlData _$ControlDataFromJson(Map<String, dynamic> json) {
  return ControlData(
    insideTemperature: json['insideTemperature'] as int,
    drinkingWaterPercentage: json['drinkingWaterPercentage'] as int,
    co2Percentage: json['co2Percentage'] as int,
    movementAngle: json['movementAngle'] as int,
    frostWindowsPercentage: json['frostWindowsPercentage'] as int,
    lowerStairsPercentage: json['lowerStairsPercentage'] as int,
    solarBatteryPercentage: json['solarBatteryPercentage'] as int,
    batteryPercentageWaterLeak: json['batteryPercentageWaterLeak'] as int,
    batteryPercentageFireDetectors:
        json['batteryPercentageFireDetectors'] as int,
    batteryPercentageC02: json['batteryPercentageC02'] as int,
  );
}

Map<String, dynamic> _$ControlDataToJson(ControlData instance) =>
    <String, dynamic>{
      'insideTemperature': instance.insideTemperature,
      'drinkingWaterPercentage': instance.drinkingWaterPercentage,
      'co2Percentage': instance.co2Percentage,
      'movementAngle': instance.movementAngle,
      'frostWindowsPercentage': instance.frostWindowsPercentage,
      'lowerStairsPercentage': instance.lowerStairsPercentage,
      'solarBatteryPercentage': instance.solarBatteryPercentage,
      'batteryPercentageWaterLeak': instance.batteryPercentageWaterLeak,
      'batteryPercentageFireDetectors': instance.batteryPercentageFireDetectors,
      'batteryPercentageC02': instance.batteryPercentageC02,
    };
