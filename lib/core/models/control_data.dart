import 'package:json_annotation/json_annotation.dart';

part 'control_data.g.dart';

@JsonSerializable()
class ControlData {
  int insideTemperature; //         "insideTemperature": 23,
  int drinkingWaterPercentage; //         "drinkingWaterPercentage": 6,
  int co2Percentage; //         "co2Percentage": 55,
  int movementAngle; //         "movementAngle": 47,
  int frostWindowsPercentage; //         "frostWindowsPercentage": 79,
  int lowerStairsPercentage; //        "lowerStairsPercentage": 12,
  int solarBatteryPercentage; //        "solarBatteryPercentage": 68,
  int batteryPercentageWaterLeak; //         "batteryPercentageWaterLeak": 85,
  int batteryPercentageFireDetectors; //         "batteryPercentageFireDetectors": 14,
  int batteryPercentageC02; //         "batteryPercentageC02": 44

  ControlData(
      {this.insideTemperature,
      this.drinkingWaterPercentage,
      this.co2Percentage,
      this.movementAngle,
      this.frostWindowsPercentage,
      this.lowerStairsPercentage,
      this.solarBatteryPercentage,
      this.batteryPercentageWaterLeak,
      this.batteryPercentageFireDetectors,
      this.batteryPercentageC02});

  factory ControlData.fromJson(Map<String, dynamic> json) =>
      _$ControlDataFromJson(json);

  Map<String, dynamic> toJson() => _$ControlDataToJson(this);
}
