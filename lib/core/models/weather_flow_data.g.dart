// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_flow_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherFlowData _$WeatherFlowDataFromJson(Map<String, dynamic> json) {
  return WeatherFlowData(
    obs: json['obs'] == null
        ? null
        : StationObservationValues.fromJson(
            json['obs'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$WeatherFlowDataToJson(WeatherFlowData instance) =>
    <String, dynamic>{
      'obs': instance.obs,
    };

StationObservationValues _$StationObservationValuesFromJson(
    Map<String, dynamic> json) {
  return StationObservationValues(
    airDensity: json['air_density'] as int,
    airDensityIndoor: json['air_density_indoor;'] as int,
    airTemperature: json['air_temperature'] as int,
    airTemperatureIndoor: json['air_temperature_indoor'] as int,
    barometricPressure: json['barometric_pressure'] as int,
    barometricPressureIndoor: json['barometric_pressure_indoor'] as int,
    brightness: json['brightness'] as int,
    brightnessIndoor: json['brightness_indoor'] as int,
    deltaT: json['delta_t'] as int,
    deltaTIndoor: json['delta_t_indoor'] as int,
    dewPoint: json['dew_point'] as int,
    dewPointIndoor: json['dew_point_indoor'] as int,
    feelsLike: json['feels_like'] as int,
    feelsLikeIndoor: json['feels_like_indoor'] as int,
    heatIndex: json['heat_index'] as int,
  )
    ..timestamp = json['timestamp'] as int
    ..seaLevelPressure = json['sea_level_pressure'] as int
    ..relativeHumidity = json['relative_humidity'] as int
    ..precip = json['precip'] as int
    ..precipAccumLast1hr = json['precip_accum_last_1hr'] as int
    ..windAvg = json['wind_avg'] as int
    ..windDirection = json['wind_direction'] as int
    ..windGust = json['wind_gust'] as int
    ..windLull = json['wind_lull'] as int
    ..solarRadiation = json['solar_radiation'] as int
    ..uv = json['uv'] as int
    ..lightningStrikeLastEpoch = json['lightning_strike_last_epoch'] as int
    ..lightningStrikeLastDistance =
        json['lightning_strike_last_distance'] as int
    ..lightningStrikeCountLast_3hr =
        json['lightning_strike_count_last_3hr'] as int
    ..windChill = json['wind_chill'] as int
    ..wetBulbTemperature = json['wet_bulb_temperature'] as int
    ..seaLevelPressureIndoor = json['sea_level_pressure_indoor'] as int
    ..relativeHumidityIndoor = json['relative_humidity_indoor'] as int
    ..precipIndoor = json['precip_indoor'] as int
    ..precipAccumLast_1hrIndoor = json['precip_accum_last_1hr_indoor'] as int
    ..windAvgIndoor = json['wind_avg_indoor'] as int
    ..windDirectionIndoor = json['wind_direction_indoor'] as int
    ..windGustIndoor = json['wind_gust_indoor'] as int
    ..windLullIndoor = json['wind_lull_indoor'] as int
    ..solarRadiationIndoor = json['solar_radiation_indoor'] as int
    ..uvIndoor = json['uv_indoor'] as int
    ..lightningStrikeLastEpochIndoor =
        json['lightning_strike_last_epoch_indoor'] as int
    ..lightningStrikeLastDistanceIndoor =
        json['lightning_strike_last_distance_indoor'] as int
    ..lightningStrikeCountLast_3hrIndoor =
        json['lightning_strike_count_last_3hr_indoor'] as int
    ..heatIndexIndoor = json['heat_index_indoor'] as int
    ..windChillIndoor = json['wind_chill_indoor'] as int
    ..wetBulbTemperatureIndoor = json['wet_bulb_temperature_indoor'] as int;
}

Map<String, dynamic> _$StationObservationValuesToJson(
        StationObservationValues instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'air_temperature': instance.airTemperature,
      'barometric_pressure': instance.barometricPressure,
      'sea_level_pressure': instance.seaLevelPressure,
      'relative_humidity': instance.relativeHumidity,
      'precip': instance.precip,
      'precip_accum_last_1hr': instance.precipAccumLast1hr,
      'wind_avg': instance.windAvg,
      'wind_direction': instance.windDirection,
      'wind_gust': instance.windGust,
      'wind_lull': instance.windLull,
      'solar_radiation': instance.solarRadiation,
      'uv': instance.uv,
      'brightness': instance.brightness,
      'lightning_strike_last_epoch': instance.lightningStrikeLastEpoch,
      'lightning_strike_last_distance': instance.lightningStrikeLastDistance,
      'lightning_strike_count_last_3hr': instance.lightningStrikeCountLast_3hr,
      'feels_like': instance.feelsLike,
      'heat_index': instance.heatIndex,
      'wind_chill': instance.windChill,
      'dew_point': instance.dewPoint,
      'wet_bulb_temperature': instance.wetBulbTemperature,
      'delta_t': instance.deltaT,
      'air_density': instance.airDensity,
      'air_temperature_indoor': instance.airTemperatureIndoor,
      'barometric_pressure_indoor': instance.barometricPressureIndoor,
      'sea_level_pressure_indoor': instance.seaLevelPressureIndoor,
      'relative_humidity_indoor': instance.relativeHumidityIndoor,
      'precip_indoor': instance.precipIndoor,
      'precip_accum_last_1hr_indoor': instance.precipAccumLast_1hrIndoor,
      'wind_avg_indoor': instance.windAvgIndoor,
      'wind_direction_indoor': instance.windDirectionIndoor,
      'wind_gust_indoor': instance.windGustIndoor,
      'wind_lull_indoor': instance.windLullIndoor,
      'solar_radiation_indoor': instance.solarRadiationIndoor,
      'uv_indoor': instance.uvIndoor,
      'brightness_indoor': instance.brightnessIndoor,
      'lightning_strike_last_epoch_indoor':
          instance.lightningStrikeLastEpochIndoor,
      'lightning_strike_last_distance_indoor':
          instance.lightningStrikeLastDistanceIndoor,
      'lightning_strike_count_last_3hr_indoor':
          instance.lightningStrikeCountLast_3hrIndoor,
      'feels_like_indoor': instance.feelsLikeIndoor,
      'heat_index_indoor': instance.heatIndexIndoor,
      'wind_chill_indoor': instance.windChillIndoor,
      'dew_point_indoor': instance.dewPointIndoor,
      'wet_bulb_temperature_indoor': instance.wetBulbTemperatureIndoor,
      'delta_t_indoor': instance.deltaTIndoor,
      'air_density_indoor;': instance.airDensityIndoor,
    };
