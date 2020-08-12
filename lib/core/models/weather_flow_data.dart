import 'package:json_annotation/json_annotation.dart';

part 'weather_flow_data.g.dart';

@JsonSerializable()
class WeatherFlowData {
  StationObservationValues obs;

  WeatherFlowData({this.obs});

  factory WeatherFlowData.fromJson(Map<String, dynamic> json) =>
      _$WeatherFlowDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherFlowDataToJson(this);
}

@JsonSerializable()
class StationObservationValues {
  int timestamp;

  @JsonKey(name: 'air_temperature')
  int airTemperature;
  @JsonKey(name: 'barometric_pressure')
  int barometricPressure;
  @JsonKey(name: 'sea_level_pressure')
  int seaLevelPressure;
  @JsonKey(name: 'relative_humidity')
  int relativeHumidity;
  int precip;
  @JsonKey(name: 'precip_accum_last_1hr')
  int precipAccumLast1hr;
  @JsonKey(name: 'wind_avg')
  int windAvg;
  @JsonKey(name: 'wind_direction')
  int windDirection;
  @JsonKey(name: 'wind_gust')
  int windGust;
  @JsonKey(name: 'wind_lull')
  int windLull;
  @JsonKey(name: 'solar_radiation')
  int solarRadiation;
  int uv;
  int brightness;
  @JsonKey(name: 'lightning_strike_last_epoch')
  int lightningStrikeLastEpoch;
  @JsonKey(name: 'lightning_strike_last_distance')
  int lightningStrikeLastDistance;
  @JsonKey(name: 'lightning_strike_count_last_3hr')
  int lightningStrikeCountLast_3hr;
  @JsonKey(name: 'feels_like')
  int feelsLike;
  @JsonKey(name: 'heat_index')
  int heatIndex;
  @JsonKey(name: 'wind_chill')
  int windChill;
  @JsonKey(name: 'dew_point')
  int dewPoint;
  @JsonKey(name: 'wet_bulb_temperature')
  int wetBulbTemperature;
  @JsonKey(name: 'delta_t')
  int deltaT;
  @JsonKey(name: 'air_density')
  int airDensity;
  @JsonKey(name: 'air_temperature_indoor')
  int airTemperatureIndoor;
  @JsonKey(name: 'barometric_pressure_indoor')
  int barometricPressureIndoor;
  @JsonKey(name: 'sea_level_pressure_indoor')
  int seaLevelPressureIndoor;
  @JsonKey(name: 'relative_humidity_indoor')
  int relativeHumidityIndoor;
  @JsonKey(name: 'precip_indoor')
  int precipIndoor;
  @JsonKey(name: 'precip_accum_last_1hr_indoor')
  int precipAccumLast_1hrIndoor;
  @JsonKey(name: 'wind_avg_indoor')
  int windAvgIndoor;
  @JsonKey(name: 'wind_direction_indoor')
  int windDirectionIndoor;
  @JsonKey(name: 'wind_gust_indoor')
  int windGustIndoor;
  @JsonKey(name: 'wind_lull_indoor')
  int windLullIndoor;
  @JsonKey(name: 'solar_radiation_indoor')
  int solarRadiationIndoor;
  @JsonKey(name: 'uv_indoor')
  int uvIndoor;
  @JsonKey(name: 'brightness_indoor')
  int brightnessIndoor;
  @JsonKey(name: 'lightning_strike_last_epoch_indoor')
  int lightningStrikeLastEpochIndoor;
  @JsonKey(name: 'lightning_strike_last_distance_indoor')
  int lightningStrikeLastDistanceIndoor;
  @JsonKey(name: 'lightning_strike_count_last_3hr_indoor')
  int lightningStrikeCountLast_3hrIndoor;
  @JsonKey(name: 'feels_like_indoor')
  int feelsLikeIndoor;
  @JsonKey(name: 'heat_index_indoor')
  int heatIndexIndoor;
  @JsonKey(name: 'wind_chill_indoor')
  int windChillIndoor;
  @JsonKey(name: 'dew_point_indoor')
  int dewPointIndoor;
  @JsonKey(name: 'wet_bulb_temperature_indoor')
  int wetBulbTemperatureIndoor;
  @JsonKey(name: 'delta_t_indoor')
  int deltaTIndoor;
  @JsonKey(name: 'air_density_indoor;')
  int airDensityIndoor;

  StationObservationValues(
      {this.airDensity,
      this.airDensityIndoor,
      this.airTemperature,
      this.airTemperatureIndoor,
      this.barometricPressure,
      this.barometricPressureIndoor,
      this.brightness,
      this.brightnessIndoor,
      this.deltaT,
      this.deltaTIndoor,
      this.dewPoint,
      this.dewPointIndoor,
      this.feelsLike,
      this.feelsLikeIndoor,
      this.heatIndex});

  factory StationObservationValues.fromJson(Map<String, dynamic> json) =>
      _$StationObservationValuesFromJson(json);

  Map<String, dynamic> toJson() => _$StationObservationValuesToJson(this);
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



timestamp (number, optional),
air_temperature (number, optional),
barometric_pressure (number, optional),
sea_level_pressure (number, optional),
relative_humidity (number, optional),
precip (number, optional),
precip_accum_last_1hr (number, optional),
wind_avg (number, optional),
wind_direction (number, optional),
wind_gust (number, optional),
wind_lull (number, optional),
solar_radiation (number, optional),
uv (number, optional),
brightness (number, optional),
lightning_strike_last_epoch (number, optional),
lightning_strike_last_distance (number, optional),
lightning_strike_count_last_3hr (number, optional),
feels_like (number, optional),
heat_index (number, optional),
wind_chill (number, optional),
dew_point (number, optional),
wet_bulb_temperature (number, optional),
delta_t (number, optional),
air_density (number, optional),
air_temperature_indoor (number, optional),
barometric_pressure_indoor (number, optional),
sea_level_pressure_indoor (number, optional),
relative_humidity_indoor (number, optional),
precip_indoor (number, optional),
precip_accum_last_1hr_indoor (number, optional),
wind_avg_indoor (number, optional),
wind_direction_indoor (number, optional),
wind_gust_indoor (number, optional),
wind_lull_indoor (number, optional),
solar_radiation_indoor (number, optional),
uv_indoor (number, optional),
brightness_indoor (number, optional),
lightning_strike_last_epoch_indoor (number, optional),
lightning_strike_last_distance_indoor (number, optional),
lightning_strike_count_last_3hr_indoor (number, optional),
feels_like_indoor (number, optional),
heat_index_indoor (number, optional),
wind_chill_indoor (number, optional),
dew_point_indoor (number, optional),
wet_bulb_temperature_indoor (number, optional),
delta_t_indoor (number, optional),
air_density_indoor (number, optional)






{
    "station_id": 22057,
    "station_name": "Manzana 130906",
    "public_name": "Manzana 130906",
    "latitude": 8.64591,
    "longitude": -80.06478,
    "timezone": "America/Panama",
    "elevation": 864.221435546875,
    "is_public": true,
    "status": {
        "status_code": 0,
        "status_message": "SUCCESS"
    },
    "station_units": {
        "units_temp": "c",
        "units_wind": "mph",
        "units_precip": "mm",
        "units_pressure": "hpa",
        "units_distance": "mi",
        "units_direction": "cardinal",
        "units_other": "imperial"
    },
    "outdoor_keys": [
        "timestamp",
        "air_temperature",
        "barometric_pressure",
        "station_pressure",
        "sea_level_pressure",
        "relative_humidity",
        "precip",
        "precip_accum_last_1hr",
        "precip_accum_local_day",
        "precip_accum_local_yesterday",
        "precip_minutes_local_day",
        "precip_minutes_local_yesterday",
        "wind_avg",
        "wind_direction",
        "wind_gust",
        "wind_lull",
        "solar_radiation",
        "uv",
        "brightness",
        "lightning_strike_last_epoch",
        "lightning_strike_last_distance",
        "lightning_strike_count",
        "lightning_strike_count_last_1hr",
        "lightning_strike_count_last_3hr",
        "feels_like",
        "heat_index",
        "wind_chill",
        "dew_point",
        "wet_bulb_temperature",
        "delta_t",
        "air_density"
    ],
    "obs": [
        {
            "timestamp": 1595352419,
            "air_temperature": 21.8,
            "barometric_pressure": 917.8,
            "station_pressure": 917.8,
            "sea_level_pressure": 1018,
            "relative_humidity": 99,
            "precip": 0,
            "precip_accum_last_1hr": 0.043272,
            "precip_accum_local_day": 0.043272,
            "precip_accum_local_yesterday": 6.768118,
            "precip_minutes_local_day": 0,
            "precip_minutes_local_yesterday": 120,
            "wind_avg": 0.5,
            "wind_direction": 109,
            "wind_gust": 1,
            "wind_lull": 0.1,
            "solar_radiation": 79,
            "uv": 0.47,
            "brightness": 9524,
            "lightning_strike_last_epoch": 1595304788,
            "lightning_strike_last_distance": 23,
            "lightning_strike_count": 0,
            "lightning_strike_count_last_1hr": 0,
            "lightning_strike_count_last_3hr": 0,
            "feels_like": 21.8,
            "heat_index": 21.8,
            "wind_chill": 21.8,
            "dew_point": 21.6,
            "wet_bulb_temperature": 21.7,
            "delta_t": 0.1,
            "air_density": 1.084
        }
    ]
}

*/
