import 'package:ocean_builder/constants/constants.dart';

class WeatherDataDay {
  String name;
  String weatherType;

  double temperatureMax;
  double temperatureMin;

  double humidityMax;
  double humidityMin;

  double solarRadMax;
  double solarRadMin;

  double uvRadMax;
  double uvRadMin;

  double windSpeedMax;
  double windSpeedMin;

  double windGustsMax;
  double windGustsMin;

  double windDirMax;
  double windDirMin;

  double baromatricPressureMax;
  double baromatricPressureMin;

  double precipMMMax;
  double precipMMMin;

  WeatherDataDay(
      {this.name,
      this.temperatureMax,
      this.temperatureMin,
      this.weatherType,
      this.humidityMax,
      this.humidityMin,
      this.solarRadMax,
      this.solarRadMin,
      this.uvRadMax,
      this.uvRadMin,
      this.windSpeedMax,
      this.windSpeedMin,
      this.windGustsMax,
      this.windGustsMin,
      this.windDirMax,
      this.windDirMin,
      this.baromatricPressureMax,
      this.baromatricPressureMin,
      this.precipMMMax,
      this.precipMMMin});

  init() {
    this.name = '';
    this.temperatureMax = 0.0;
    this.temperatureMin = 10000.0;
    this.weatherType = '113';
    this.humidityMax = 0.0;
    this.humidityMin = 10000.0;
    this.solarRadMax = 0.0;
    this.solarRadMin = 10000.0;
    this.uvRadMax = 0.0;
    this.uvRadMin = 0.0;
    this.windSpeedMax = 0.0;
    this.windSpeedMin = 1000.0;
    this.windGustsMax = 0.0;
    this.windGustsMin = 1000.0;
    this.windDirMax = 0.0;
    this.windDirMin = 1000.0;
    this.baromatricPressureMax = 0.0;
    this.baromatricPressureMin = 1000.0;
    this.precipMMMax = 0.0;
    this.precipMMMin = 1000.0;
  }
}

/*

--------- SmartWeather ------------
{
      "timestamp": 1495732068,
      "air_temperature": 29.1,
      "barometric_pressure": 1002.9,
      "sea_level_pressure": 1004.7,
      "relative_humidity": 77,
      "precip": 0,
      "precip_accum_last_1hr": 0,
      "wind_avg": 3.5,
      "wind_direction": 289,
      "wind_gust": 5.1,
      "wind_lull": 2.2,
      "solar_radiation": 330,
      "uv": 8,
      "brightness": 7000,
      "lightning_strike_last_epoch": 1495652340,
      "lightning_strike_last_distance": 22,
      "lightning_strike_count_last_3hr": 0,
      "feels_like": 21.4,
      "heat_index": 21.4,
      "wind_chill": 21.4,
      "dew_point": 17.2,
      "wet_bulb_temperature": 18.6,
      "delta_t": -2.8,
      "air_density": 1.18257,
      "air_temperature_indoor": 29.1,
      "barometric_pressure_indoor": 1002.9,
      "sea_level_pressure_indoor": 1004.7,
      "relative_humidity_indoor": 77,
      "precip_indoor": 0,
      "precip_accum_last_1hr_indoor": 0,
      "wind_avg_indoor": 3.5,
      "wind_direction_indoor": 289,
      "wind_gust_indoor": 5.1,
      "wind_lull_indoor": 2.2,
      "solar_radiation_indoor": 330,
      "uv_indoor": 8,
      "brightness_indoor": 7000,
      "lightning_strike_last_epoch_indoor": 1495652340,
      "lightning_strike_last_distance_indoor": 22,
      "lightning_strike_count_last_3hr_indoor": 0,
      "feels_like_indoor": 21.4,
      "heat_index_indoor": 21.4,
      "wind_chill_indoor": 21.4,
      "dew_point_indoor": 17.2,
      "wet_bulb_temperature_indoor": 18.6,
      "delta_t_indoor": -2.8,
      "air_density_indoor": 1.18257
    }


*/
