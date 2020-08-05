import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/weather_flow_data.dart';
import 'package:ocean_builder/helper/api_base_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class LocalWeatherDataRepository{

  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

    final Map<String, dynamic> _params = {
    "api_key": Config.WEATHER_FLOW_API_KEY,
  };

  Future<WeatherFlowData> getStationObservationData({String stationId = '22862'}) async {

    final response = await _apiBaseHelper.get(
      url: Config.GET_WEATHER_FLOW_STATION_OBS_DATA(stationId),
      parameters: _params,
    );
    print(response);
    WeatherFlowData weatherFlowData = WeatherFlowData.fromJson(response);
    return weatherFlowData;
  }

}