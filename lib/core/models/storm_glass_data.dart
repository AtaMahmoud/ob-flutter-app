import 'package:flutter/rendering.dart';

class StormGlassData {
  List<HourData> hours;

  StormGlassData({this.hours});

  factory StormGlassData.fromJson(Map<String, dynamic> json) {
    var list = json['hours'] as List;
    List<HourData> hourList = list.map((f) => HourData.fromJson(f)).toList();
    return StormGlassData(hours: hourList);
  }
}

class HourData {
  AttributeList airTemperatureList;
  AttributeList waterTemperatureList;
  AttributeList seaLevelList;
  AttributeList waveHeightList;
  AttributeList significantWaveList;
  AttributeList visiblityList;
  AttributeList swellHeightList;
  AttributeList swellDirectionList;
  AttributeList swellPeriodList;
  AttributeList humidityList;
  AttributeList windSpeedList;
  AttributeList windGustList;
  AttributeList windDirectionList;
  AttributeList barometricPressureList;
  AttributeList precipitationList;
  String time;

  HourData(
      {this.airTemperatureList,
      this.waterTemperatureList,
      this.seaLevelList,
      this.waveHeightList,
      this.significantWaveList,
      this.visiblityList,
      this.swellHeightList,
      this.swellDirectionList,
      this.swellPeriodList,
      this.humidityList,
      this.windSpeedList,
      this.windGustList,
      this.windDirectionList,
      this.barometricPressureList,
      this.precipitationList,
      this.time});

  factory HourData.fromJson(Map<String, dynamic> json) {
    // debugPrint('time -----------' + json['time']);
    //  debugPrint('  waterTemperature -----------' + json['waterTemperature'].toString());
    //   debugPrint(' seaLevel -----------' + json['seaLevel'].toString());
    //    debugPrint('waveHeight -----------' + json['waveHeight'].toString());
    //     debugPrint('secondarySwellHeight -----------' + json['secondarySwellHeight'].toString());
    //      debugPrint('visiblity -----------' + json['visibility'].toString());
    //       debugPrint('swellHeight -----------' + json['swellHeight'].toString());
    //        debugPrint('swellDirection -----------' + json['swellDirection'].toString());
    //         debugPrint('swellPeriod -----------' + json['swellPeriod'].toString());
    //         debugPrint('windSpeed -----------' + json['windSpeedList'].toString());

    return HourData(
      time: json['time'],
      airTemperatureList: AttributeList.fromJson(json['airTemperature']),
      waterTemperatureList: AttributeList.fromJson(json['waterTemperature']),
      seaLevelList: AttributeList.fromJson(json['seaLevel']),
      waveHeightList: AttributeList.fromJson(json['waveHeight']),
      significantWaveList: AttributeList.fromJson(json['waveHeight']),
      visiblityList: AttributeList.fromJson(json['visibility']),
      swellHeightList: AttributeList.fromJson(json['swellHeight']),
      swellDirectionList: AttributeList.fromJson(json['swellDirection']),
      swellPeriodList: AttributeList.fromJson(json['swellPeriod']),
      humidityList: AttributeList.fromJson(json['humidity']),
      windSpeedList: AttributeList.fromJson(json['windSpeed']),
      windGustList: AttributeList.fromJson(json['gust']),
      windDirectionList: AttributeList.fromJson(json['windDirection']),
      barometricPressureList: AttributeList.fromJson(json['pressure']),
      precipitationList: AttributeList.fromJson(json['precipitation']),
    );
  }
}

class AttributeList {
  List<AtrributeData> attributeDataList;

  AttributeList({this.attributeDataList});

  factory AttributeList.fromJson(List<dynamic> json) {
    List<AtrributeData> attributeList =
        json.map((f) => AtrributeData.fromJson(f)).toList();
    return AttributeList(attributeDataList: attributeList);
  }
}

class AtrributeData {
  String source;
  double value;

  AtrributeData({this.source, this.value});

  factory AtrributeData.fromJson(Map<String, dynamic> json) {
    return AtrributeData(source: json['source'], value: json['value']);
  }
}

class TideData {
  List<TideExtreme> extremas;

  TideData({this.extremas});

  factory TideData.fromJson(Map<String, dynamic> json) {
    var list = json['extremes'] as List;
    List<TideExtreme> extremaList =
        list.map((f) => TideExtreme.fromJson(f)).toList();
    return TideData(extremas: extremaList);
  }
}

class TideExtreme {
  double height;
  String time;
  String type;

  TideExtreme({this.height, this.time, this.type});

  factory TideExtreme.fromJson(Map<String, dynamic> json) {
    return TideExtreme(
        height: json['height'], time: json['timestamp'], type: json['type']);
  }
}

/*
{
  "data": [
    {
      "time": "2020-02-19T17:00:00+00:00",
      "uvIndex": {
        "noaa": 0.3,
        "sg": 0.3,
      },
      ...
    }
  ],
  "meta": {
    "dailyQuota": 50,
    "lat": 58.7984,
    "lng": 17.8081,
    "requestCount": 1
  }
}
*/

class UvIndexData {
  List<UvIndexAttribute> uvIndexAttributes;

  UvIndexData({this.uvIndexAttributes});

  factory UvIndexData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;

    List<UvIndexAttribute> hourList =
        list.map((f) => UvIndexAttribute.fromJson(f)).toList();
    return UvIndexData(uvIndexAttributes: hourList);
  }
}

class UvIndexAttribute {
  String time;
  UvIndexValue uvIndexValue;

  UvIndexAttribute({this.time, this.uvIndexValue});

  factory UvIndexAttribute.fromJson(Map<String, dynamic> json) {
    return UvIndexAttribute(time: json['time'], uvIndexValue: json['uvIndex']);
  }
}

class UvIndexValue {
  double value;

  UvIndexValue({this.value});

  factory UvIndexValue.fromJson(Map<String, dynamic> json) {
    return UvIndexValue(
      value: json['sg'],
    );
  }
}

/*
------------storm glass sample json----------------


{   // Map<String,dynamic>
    "hours": [    // List<Map<String,dynamic>>
        {      // Map<String,dynamic>
            "airTemperature": [  //List<Map<String,dynamic>>
                {   // Map<String,dynamic>
                    "source": "sg",
                    "value": 11.5
                }
            ],
            "time": "2019-09-16T00:00:00+00:00",
            "waterTemperature": [
                {
                    "source": "sg",
                    "value": 14.63
                }
            ]
        },
        {
            "airTemperature": [
                {
                    "source": "sg",
                    "value": 11.5
                }
            ],
            "time": "2019-09-16T01:00:00+00:00",
            "waterTemperature": [
                {
                    "source": "sg",
                    "value": 14.62
                }
            ]
        },
        {
            "airTemperature": [
                {
                    "source": "sg",
                    "value": 11.4
                }
            ],
            "time": "2019-09-16T02:00:00+00:00",
            "waterTemperature": [
                {
                    "source": "sg",
                    "value": 14.6
                }
            ]
        }
    ],
    "meta": {
        "cost": 1,
        "dailyQuota": 50,
        "end": "2019-09-16 02:00",
        "lat": 58.7984,
        "lng": 17.8081,
        "params": [
            "waterTemperature",
            "airTemperature"
        ],
        "requestCount": 3,
        "source": "sg",
        "start": "2019-09-16 00:00"
    }
}

---------- Tide ----------

{
    "extremas": [
        {
            "height": "1.18",
            "time": "2019-03-15 03:40:44+00:00",
            "type": "high"
        },
        {
            "height": "0.60",
            "time": "2019-03-15 09:53:54+00:00",
            "type": "low"
        },
        {
            "height": "1.20",
            "time": "2019-03-15 16:23:29+00:00",
            "type": "high"
        },
        {
            "height": "0.61",
            "time": "2019-03-15 22:39:15+00:00",
            "type": "low"
        }
    ],
    "meta": {
        "cost": 1,
        "dailyQuota": 800,
        "end": "2019-03-16 00:00",
        "lat": 60.936,
        "lng": 5.114,
        "requestCount": 145,
        "start": "2019-03-15 00:00",
        "station": {
            "distance": 61,
            "lat": 60.398046,
            "lng": 5.320487,
            "name": "bergen",
            "source": "sehavniva.no"
        }
    }
}


------------------ solar data (uvIndex) --------------------------------------------

{
  "data": [
    {
      "time": "2020-02-19T17:00:00+00:00",
      "uvIndex": {
        "noaa": 0.3,
        "sg": 0.3,
      },
      ...
    }
  ],
  "meta": {
    "dailyQuota": 50,
    "lat": 58.7984,
    "lng": 17.8081,
    "requestCount": 1
  }
}




*/
