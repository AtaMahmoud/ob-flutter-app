import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class WeatherFlowDeviceObservationData {
  DeviceObservationStatus status;
  @JsonKey(name: 'device_id')
  int deviceId;
  String type;
  @JsonKey(name: 'bucket_step_minutes')
  int bucketStepMinutes;
  String source;
  List<DeviceObservation> obs;

  WeatherFlowDeviceObservationData(
      {this.status,
      this.deviceId,
      this.type,
      this.bucketStepMinutes,
      this.source,
      this.obs});

  factory WeatherFlowDeviceObservationData.fromJson(Map<String, dynamic> json) {
    var list = json['obs'] as List;
    List<DeviceObservation> obsList =
        list.map((f) => DeviceObservation.fromJson(f)).toList();
    return WeatherFlowDeviceObservationData(
        status: DeviceObservationStatus.fromJson(json['status']),
        deviceId: json['device_id'],
        type: json['type'],
        bucketStepMinutes: json['bucket_step_minutes'],
        source: json['source'],
        obs: obsList);
  }
}

class DeviceObservationStatus {
  @JsonKey(name: 'status_code')
  int statusCode;
  @JsonKey(name: 'status_message')
  String statusMessage;

  DeviceObservationStatus({this.statusCode, this.statusMessage});

  factory DeviceObservationStatus.fromJson(Map<String, dynamic> json) {
    return DeviceObservationStatus(
        statusCode: json['status_code'], statusMessage: json['status_message']);
  }
}

class DeviceObservation {
  List<dynamic> observation;
  int epoch; 
  int windLull;
  double windAvg;
  double windGust;
  int windDirection;
  int windSampleInterval;
  double pressure;
  double airTemperature;
  int relativeHumidity;
  int illuminance;
  double unIndex;
  int solarRadiation;
  int rainAccumulation;
  // (0 = none, 1 = rain, 2 = hail)
  int precipitationType;
  int averageStrikeDistance;
  int strikeCount;
  double battery;
  int reportIntervals;
  int localDayRainAccumulation;
  int rainAccuulationFinal;
  int localDayRainAccumulationFinal;
  // (0 = none, 1 = Rain Check with user display on, 2 = Rain Check with user display off)
  int precipitationAnalysisType;



  DeviceObservation({this.observation,this.airTemperature,this.averageStrikeDistance,this.battery,this.epoch,this.illuminance,this.localDayRainAccumulation,this.localDayRainAccumulationFinal,this.precipitationAnalysisType,this.precipitationType,this.pressure,this.rainAccumulation,this.rainAccuulationFinal,this.relativeHumidity,this.reportIntervals,this.solarRadiation,this.strikeCount,this.unIndex,this.windAvg,this.windDirection,this.windGust,this.windLull,this.windSampleInterval});

  factory DeviceObservation.fromJson(dynamic json) {
    debugPrint('json --------------  $json ');
    List<dynamic> values = json != null ? List.from(json) : null;
     debugPrint('values --------------  $values ');
    return DeviceObservation(
      observation: values,
      airTemperature: values[7],
        );
  }
}

/*

Air (type="obs_air")
Observation Layout
0 - Epoch (seconds UTC)
1 - Station Pressure (MB)
2 - Air Temperature (C)
3 - Relative Humidity (%)
4 - Lightning Strike Count
5 - Lightning Strike Average Distance (km)
6 - Battery (volts)
7 - Report Interval (minutes)

Sky (type="obs_sky")
Observation Layout
0 - Epoch (seconds UTC)
1 - Illuminance (lux)
2 - UV (index)
3 - Rain Accumulation (mm)
4 - Wind Lull (m/s)
5 - Wind Avg (m/s)
6 - Wind Gust (m/s)
7 - Wind Direction (degrees)
8 - Battery (volts)
9 - Report Interval (minutes)
10 - Solar Radiation (W/m^2)
11 - Local Day Rain Accumulation (mm)
12 - Precipitation Type (0 = none, 1 = rain, 2 = hail)
13 - Wind Sample Interval (seconds)
14 - Rain Accumulation Final (Rain Check) (mm)
15 - Local Day Rain Accumulation Final (Rain Check) (mm)
16 - Precipitation Analysis Type (0 = none, 1 = Rain Check with user display on, 2 = Rain Check with user display off)

Tempest (type="obs_st")
Observation Layout
0 - Epoch (Seconds UTC)
1 - Wind Lull (m/s)
2 - Wind Avg (m/s)
3 - Wind Gust (m/s)
4 - Wind Direction (degrees)
5 - Wind Sample Interval (seconds)
6 - Pressure (MB)
7 - Air Temperature (C)
8 - Relative Humidity (%)
9 - Illuminance (lux)
10 - UV (index)
11 - Solar Radiation (W/m^2)
12 - Rain Accumulation (mm)
13 - Precipitation Type (0 = none, 1 = rain, 2 = hail)
14 - Average Strike Distance (km)
15 - Strike Count
16 - Battery (volts)
17 - Report Interval (minutes)
18 - Local Day Rain Accumulation (mm)
19 - Rain Accumulation Final (Rain Check) (mm)
20 - Local Day Rain Accumulation Final (Rain Check) (mm)
21 - Precipitation Aanalysis Type (0 = none, 1 = Rain Check with user display on, 2 = Rain Check with user display off)


{
    "status": {
        "status_code": 0,
        "status_message": "SUCCESS"
    },
    "device_id": 73674,
    "type": "obs_st",
    "bucket_step_minutes": 5,
    "source": "db",
    "obs": [
        [
            1595256600,
            0,
            1.47,
            6.62,
            26,
            3,
            915.7,
            23.0,
            91,
            98710,
            5.35,
            823,
            0,
            0,
            0,
            0,
            2.52,
            5,
            0,
            null,
            null,
            0
        ],
      ]
}

*/
