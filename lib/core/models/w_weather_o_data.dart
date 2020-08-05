import 'package:flutter/widgets.dart';

class WorldWeatherOnlineData{
  WOWData data;

  WorldWeatherOnlineData({this.data});

  factory WorldWeatherOnlineData.fromJson(Map<String, dynamic> json){
    return WorldWeatherOnlineData(
      data: WOWData.fromJson(json['data'])
    );
  }
  
}

class WOWData{
 List<Weather> weathers;

 WOWData({this.weathers});

factory WOWData.fromJson(Map<String, dynamic> json){
  List<Weather> weatherList = [];
  var list = json['weather'] as List;
  if(list!=null && list.length > 1)
  {
     weatherList = list.map((f)=>Weather.fromJson(f)).toList();
  }
  return WOWData(
    weathers: weatherList
  );
}


}

class Weather{
      String date;
	    String maxtempC;
	    String maxtempF;
	    String mintempC;
	    String mintempF;
	    String uvIndex;
      List<Hourly> hours;
      Tide tides;

      Weather({
        this.date,
        this.maxtempC,
        this.maxtempF,
        this.mintempC,
        this.mintempF,
        this.uvIndex,
        this.hours,
        this.tides,
      });

      factory Weather.fromJson(Map<String, dynamic> json){
         var list = json['hourly'] as List;
         List<Hourly> hourList = list.map((f)=>Hourly.fromJson(f)).toList();
         var tideDataList = json['tides'] as List;
        return Weather(
          date: json['date'],
          maxtempC: json['maxtempC'],
          maxtempF: json['maxtempF'],
          mintempC: json['mintempC'],
          mintempF: json['mintempF'],
          uvIndex: json['uvIndex'],
          hours: hourList,
          tides: tideDataList !=null ? Tide.fromJson(tideDataList[0]) : Tide(),
        );
      }
}

class Hourly{
  String dateTime;
  String time;
  String weatherCode;
  String weatherIconUrl;
  String tempC;
  String feelsLikeC;
  String humidity;
  String chanceofrain;
  String uvIndex;
  String windspeedKmph;
  String windGustKmph;
  String winddirection;
  String pressureInches;

  String waterTempC;
  String waterTempF;
  String significantWave;
  String visibility;
  String swellHeight;
  String swellDirection;
  String swellPeriod;
  String seaLevel = '0';
  String waveHeight = '0';

  Hourly({
    this.dateTime,
    this.time,
    this.weatherCode,
    this.tempC,
    this.feelsLikeC,
    this.humidity,
    this.chanceofrain,
    this.uvIndex,
    this.windGustKmph,
    this.windspeedKmph,
    this.winddirection,
    this.pressureInches,
    this.weatherIconUrl,
    
    this.waterTempC,
    this.waterTempF,
    this.significantWave,
    this.visibility,
    this.swellHeight,
    this.swellDirection,
    this.swellPeriod,
    this.seaLevel,
    this.waveHeight
  });

  factory Hourly.fromJson(Map<String, dynamic> json){
    var list = json['weatherIconUrl'] as List;
    return Hourly(
      time: json['time'],
      weatherCode: json['weatherCode'],
      tempC: json['tempC'],
      feelsLikeC: json['FeelsLikeC'],
      humidity: json['humidity'],
      chanceofrain: json['chanceofrain'],
      uvIndex: json['uvIndex'],
      windGustKmph: json['WindGustKmph'],
      windspeedKmph: json['windspeedKmph'],
      winddirection: json['winddirDegree'],
      pressureInches: json['pressureInches'],
      weatherIconUrl: list[0]['value'],

      // marine data
      waterTempC: json['waterTemp_C'],
      waterTempF: json['waterTemp_F'],
      significantWave: json['sigHeight_m'],
      visibility: json['visibility'],
      swellHeight: json['swellHeight_m'],
      swellDirection: json['swellDir'],
      swellPeriod: json['swellPeriod_secs']
      

    );
  }


}

class Tide{
  
  List<TideData> tides;

  Tide({
    this.tides
  });

  factory Tide.fromJson(Map<String, dynamic> json){
    var list = json['tide_data'] as List;
    if(list==null || list.length <=0)
    return Tide();
    List<TideData> tideDataList = list.map((f){return TideData.fromJson(f);}).toList();
    return Tide(
      tides: tideDataList
    );
  }

}

class TideData{
  String tideTime;
  String tideHeightMt;
  String tideDateTime;
  String tideType;

  TideData({
    this.tideTime,
    this.tideHeightMt,
    this.tideDateTime,
    this.tideType
  });

  factory TideData.fromJson(Map<String, dynamic> json){
    return TideData(
      tideTime:json['tideTime'],
      tideHeightMt: json['tideHeight_mt'],
      tideDateTime: json['tideDateTime'],
      tideType: json['tide_type'],
    );
  }
}



/*
// sample weather request of worldweatheronline

{
    "data": {
        "request": [
            {
                "type": "LatLon",
                "query": "Lat 23.74 and Lon 90.43"
            }
        ],
        "current_condition": [
            {
                "observation_time": "05:18 AM",
                "temp_C": "29",
                "temp_F": "84",
                "weatherCode": "176",
                "weatherIconUrl": [
                    {
                        "value": "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0009_light_rain_showers.png"
                    }
                ],
                "weatherDesc": [
                    {
                        "value": "Patchy rain possible"
                    }
                ],
                "windspeedMiles": "5",
                "windspeedKmph": "9",
                "winddirDegree": "74",
                "winddir16Point": "ENE",
                "precipMM": "0.1",
                "precipInches": "0.0",
                "humidity": "67",
                "visibility": "10",
                "visibilityMiles": "6",
                "pressure": "1014",
                "pressureInches": "30",
                "cloudcover": "34",
                "FeelsLikeC": "32",
                "FeelsLikeF": "90",
                "uvIndex": 6
            }
        ],
        "weather": [
            {
                "date": "2019-10-17",
                "astronomy": [
                    {
                        "sunrise": "05:56 AM",
                        "sunset": "05:31 PM",
                        "moonrise": "08:01 PM",
                        "moonset": "08:42 AM",
                        "moon_phase": "Waning Gibbous",
                        "moon_illumination": "72"
                    }
                ],
                "maxtempC": "34",
                "maxtempF": "92",
                "mintempC": "26",
                "mintempF": "79",
                "avgtempC": "30",
                "avgtempF": "86",
                "totalSnow_cm": "0.0",
                "sunHour": "10.2",
                "uvIndex": "7",
                "hourly": [
                    {
                        "time": "0",
                        "tempC": "28",
                        "tempF": "83",
                        "windspeedMiles": "1",
                        "windspeedKmph": "1",
                        "winddirDegree": "101",
                        "winddir16Point": "ESE",
                        "weatherCode": "116",
                        "weatherIconUrl": [
                            {
                                "value": "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"
                            }
                        ],
                        "weatherDesc": [
                            {
                                "value": "Partly cloudy"
                            }
                        ],
                        "precipMM": "0.0",
                        "precipInches": "0.0",
                        "humidity": "69",
                        "visibility": "10",
                        "visibilityMiles": "6",
                        "pressure": "1012",
                        "pressureInches": "30",
                        "cloudcover": "61",
                        "HeatIndexC": "31",
                        "HeatIndexF": "89",
                        "DewPointC": "22",
                        "DewPointF": "72",
                        "WindChillC": "28",
                        "WindChillF": "83",
                        "WindGustMiles": "1",
                        "WindGustKmph": "2",
                        "FeelsLikeC": "31",
                        "FeelsLikeF": "89",
                        "chanceofrain": "0",
                        "chanceofremdry": "91",
                        "chanceofwindy": "0",
                        "chanceofovercast": "48",
                        "chanceofsunshine": "83",
                        "chanceoffrost": "0",
                        "chanceofhightemp": "98",
                        "chanceoffog": "0",
                        "chanceofsnow": "0",
                        "chanceofthunder": "0",
                        "uvIndex": "0"
                    },
                    {
                        "time": "1200",
                        "tempC": "33",
                        "tempF": "92",
                        "windspeedMiles": "5",
                        "windspeedKmph": "8",
                        "winddirDegree": "47",
                        "winddir16Point": "NE",
                        "weatherCode": "116",
                        "weatherIconUrl": [
                            {
                                "value": "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png"
                            }
                        ],
                        "weatherDesc": [
                            {
                                "value": "Partly cloudy"
                            }
                        ],
                        "precipMM": "0.0",
                        "precipInches": "0.0",
                        "humidity": "50",
                        "visibility": "10",
                        "visibilityMiles": "6",
                        "pressure": "1012",
                        "pressureInches": "30",
                        "cloudcover": "39",
                        "HeatIndexC": "37",
                        "HeatIndexF": "99",
                        "DewPointC": "21",
                        "DewPointF": "71",
                        "WindChillC": "33",
                        "WindChillF": "92",
                        "WindGustMiles": "6",
                        "WindGustKmph": "9",
                        "FeelsLikeC": "37",
                        "FeelsLikeF": "99",
                        "chanceofrain": "0",
                        "chanceofremdry": "92",
                        "chanceofwindy": "0",
                        "chanceofovercast": "43",
                        "chanceofsunshine": "79",
                        "chanceoffrost": "0",
                        "chanceofhightemp": "96",
                        "chanceoffog": "0",
                        "chanceofsnow": "0",
                        "chanceofthunder": "0",
                        "uvIndex": "8"
                    }
                ]
            },
            {
                "date": "2019-10-18",
                "astronomy": [
                    {
                        "sunrise": "05:57 AM",
                        "sunset": "05:31 PM",
                        "moonrise": "08:46 PM",
                        "moonset": "09:38 AM",
                        "moon_phase": "Waning Gibbous",
                        "moon_illumination": "64"
                    }
                ],
                "maxtempC": "34",
                "maxtempF": "93",
                "mintempC": "27",
                "mintempF": "80",
                "avgtempC": "30",
                "avgtempF": "86",
                "totalSnow_cm": "0.0",
                "sunHour": "11.6",
                "uvIndex": "8",
                "hourly": [
                    {
                        "time": "0",
                        "tempC": "28",
                        "tempF": "82",
                        "windspeedMiles": "4",
                        "windspeedKmph": "7",
                        "winddirDegree": "3",
                        "winddir16Point": "N",
                        "weatherCode": "116",
                        "weatherIconUrl": [
                            {
                                "value": "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"
                            }
                        ],
                        "weatherDesc": [
                            {
                                "value": "Partly cloudy"
                            }
                        ],
                        "precipMM": "0.0",
                        "precipInches": "0.0",
                        "humidity": "71",
                        "visibility": "10",
                        "visibilityMiles": "6",
                        "pressure": "1011",
                        "pressureInches": "30",
                        "cloudcover": "61",
                        "HeatIndexC": "31",
                        "HeatIndexF": "88",
                        "DewPointC": "22",
                        "DewPointF": "72",
                        "WindChillC": "28",
                        "WindChillF": "82",
                        "WindGustMiles": "7",
                        "WindGustKmph": "11",
                        "FeelsLikeC": "31",
                        "FeelsLikeF": "88",
                        "chanceofrain": "0",
                        "chanceofremdry": "87",
                        "chanceofwindy": "0",
                        "chanceofovercast": "49",
                        "chanceofsunshine": "74",
                        "chanceoffrost": "0",
                        "chanceofhightemp": "45",
                        "chanceoffog": "0",
                        "chanceofsnow": "0",
                        "chanceofthunder": "0",
                        "uvIndex": "0"
                    },
                    {
                        "time": "1200",
                        "tempC": "34",
                        "tempF": "92",
                        "windspeedMiles": "5",
                        "windspeedKmph": "8",
                        "winddirDegree": "349",
                        "winddir16Point": "NNW",
                        "weatherCode": "116",
                        "weatherIconUrl": [
                            {
                                "value": "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png"
                            }
                        ],
                        "weatherDesc": [
                            {
                                "value": "Partly cloudy"
                            }
                        ],
                        "precipMM": "0.0",
                        "precipInches": "0.0",
                        "humidity": "49",
                        "visibility": "10",
                        "visibilityMiles": "6",
                        "pressure": "1012",
                        "pressureInches": "30",
                        "cloudcover": "43",
                        "HeatIndexC": "38",
                        "HeatIndexF": "100",
                        "DewPointC": "21",
                        "DewPointF": "71",
                        "WindChillC": "34",
                        "WindChillF": "92",
                        "WindGustMiles": "5",
                        "WindGustKmph": "9",
                        "FeelsLikeC": "38",
                        "FeelsLikeF": "100",
                        "chanceofrain": "0",
                        "chanceofremdry": "88",
                        "chanceofwindy": "0",
                        "chanceofovercast": "43",
                        "chanceofsunshine": "82",
                        "chanceoffrost": "0",
                        "chanceofhightemp": "50",
                        "chanceoffog": "0",
                        "chanceofsnow": "0",
                        "chanceofthunder": "0",
                        "uvIndex": "8"
                    }
                ]
            }
        ],
        "ClimateAverages": [
            {
                "month": [
                    {
                        "index": "1",
                        "name": "January",
                        "avgMinTemp": "15.0",
                        "avgMinTemp_F": "59.0",
                        "absMaxTemp": "29.72581",
                        "absMaxTemp_F": "85.5",
                        "avgDailyRainfall": "0.03"
                    },
                    {
                        "index": "2",
                        "name": "February",
                        "avgMinTemp": "17.2",
                        "avgMinTemp_F": "63.0",
                        "absMaxTemp": "31.01614",
                        "absMaxTemp_F": "87.8",
                        "avgDailyRainfall": "0.38"
                    },
                    {
                        "index": "3",
                        "name": "March",
                        "avgMinTemp": "21.2",
                        "avgMinTemp_F": "70.1",
                        "absMaxTemp": "36.86423",
                        "absMaxTemp_F": "98.4",
                        "avgDailyRainfall": "0.75"
                    },
                    {
                        "index": "4",
                        "name": "April",
                        "avgMinTemp": "25.5",
                        "avgMinTemp_F": "77.8",
                        "absMaxTemp": "39.06673",
                        "absMaxTemp_F": "102.3",
                        "avgDailyRainfall": "2.61"
                    },
                    {
                        "index": "5",
                        "name": "May",
                        "avgMinTemp": "26.9",
                        "avgMinTemp_F": "80.3",
                        "absMaxTemp": "39.04839",
                        "absMaxTemp_F": "102.3",
                        "avgDailyRainfall": "3.22"
                    },
                    {
                        "index": "6",
                        "name": "June",
                        "avgMinTemp": "27.2",
                        "avgMinTemp_F": "80.9",
                        "absMaxTemp": "36.14667",
                        "absMaxTemp_F": "97.1",
                        "avgDailyRainfall": "3.29"
                    },
                    {
                        "index": "7",
                        "name": "July",
                        "avgMinTemp": "26.5",
                        "avgMinTemp_F": "79.7",
                        "absMaxTemp": "33.72581",
                        "absMaxTemp_F": "92.7",
                        "avgDailyRainfall": "2.85"
                    },
                    {
                        "index": "8",
                        "name": "August",
                        "avgMinTemp": "26.4",
                        "avgMinTemp_F": "79.5",
                        "absMaxTemp": "33.97419",
                        "absMaxTemp_F": "93.2",
                        "avgDailyRainfall": "2.83"
                    },
                    {
                        "index": "9",
                        "name": "September",
                        "avgMinTemp": "25.8",
                        "avgMinTemp_F": "78.5",
                        "absMaxTemp": "33.77703",
                        "absMaxTemp_F": "92.8",
                        "avgDailyRainfall": "2.87"
                    },
                    {
                        "index": "10",
                        "name": "October",
                        "avgMinTemp": "23.7",
                        "avgMinTemp_F": "74.7",
                        "absMaxTemp": "32.98064",
                        "absMaxTemp_F": "91.4",
                        "avgDailyRainfall": "1.12"
                    },
                    {
                        "index": "11",
                        "name": "November",
                        "avgMinTemp": "19.9",
                        "avgMinTemp_F": "67.9",
                        "absMaxTemp": "32.72334",
                        "absMaxTemp_F": "90.9",
                        "avgDailyRainfall": "0.18"
                    },
                    {
                        "index": "12",
                        "name": "December",
                        "avgMinTemp": "16.6",
                        "avgMinTemp_F": "62.0",
                        "absMaxTemp": "28.09032",
                        "absMaxTemp_F": "82.6",
                        "avgDailyRainfall": "0.31"
                    }
                ]
            }
        ]
    }
}

*/