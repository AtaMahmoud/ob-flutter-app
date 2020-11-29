import 'package:ocean_builder/configs/config_reader.dart';

class Config {
  static const int CONNECTION_TIME_OUT = 10000 * 5;
  static const int READ_TIME_OUT = 10000 * 5;

  static String STORM_GLASS_API_KEY = ConfigReader.getStormGlassApiKey();

  static var WEATHER_FLOW_API_KEY = ConfigReader.getWeatherFlowApiKey();

  static const String WORLD_WEATHER_ONLINE_API_KEY = '';

  // openweather map url

  static const String OPEN_WEATHER_MAP_URL =
      'https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature&lat=9.2589903&lon=-80.259267&zoom=5';
  // 'https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature&lat=30&lon=-20&zoom=5';
  // API links

  static const GET_WEATHER_DATA = 'https://api.stormglass.io/v1/weather/point';
  static const GET_TIDE_DATA =
      'https://api.stormglass.io/v1/tide/extremes/point';

  static const GET_UVINDEX_DATA = 'https://api.stormglass.io/v2/solar/point';

  static const GET_WOW_WEATHER_DATA =
      'https://api.worldweatheronline.com/premium/v1/weather.ashx';
  static const GET_PAST_WOW_WEATHER_DATA =
      'https://api.worldweatheronline.com/premium/v1/past-weather.ashx';
  static const GET_WOW_MARINE_DATA =
      'https://api.worldweatheronline.com/premium/v1/marine.ashx';
  static const GET_PAST_WOW_MARINE_DATA =
      'https://api.worldweatheronline.com/premium/v1/past-marine.ashx';

  // heroku server APIs
  static const LOGIN = 'https://oceanbuilders.herokuapp.com/v1/api/auth';
  static const REG_WITH_SEAPOD_CREATION =
      'https://oceanbuilders.herokuapp.com/v1/api/auth';
  static const AUTO_LOGIN =
      'https://oceanbuilders.herokuapp.com/v1/api/auth/me';
  static const CREATE_NEW_SEAPOD =
      'https://oceanbuilders.herokuapp.com/v1/api/seapods';
  static const UPDATE_USER_PROFILE =
      'https://oceanbuilders.herokuapp.com/v1/api/users';
  static const UPDATE_USER_PASSWORD =
      'https://oceanbuilders.herokuapp.com/v1/api/users/password';

  static String UPDATE_SEAPOD_NAME(String seapodId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/seapods/$seapodId/name';
  static const SEND_ACCESS_REQ_EXISTING_USER =
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/existing';
  static const SEND_ACCESS_REQ_NEW_USER =
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/new';
  static String CANCEL_ACCESS_REQ(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/$accessReqId';
  static String ACCEPT_ACCESS_REQ(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/$accessReqId/approval';
  static String REJECT_ACCESS_REQ(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/$accessReqId/rejection';
  static const GET_NOTIFICATIONS =
      'https://oceanbuilders.herokuapp.com/v1/api/users/notifications';
  static const ADD_EMERGENCY_CONTACT =
      'https://oceanbuilders.herokuapp.com/v1/api/users/emergency-contacts';
  static String UPDATE_EMERGENCY_CONTACT(String emergencyContactId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/users/emergency-contacts/$emergencyContactId';
  static String GET_ACCESS_REQUEST(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/$accessReqId';
  static String SEND_ACCESS_INVITATION(String seaPodId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/invitations/$seaPodId';
  static String CANCEL_ACCESS_INVITATION(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/invitations/$accessReqId';
  static String ACCEPT_ACCESS_INVITATION(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/invitations/$accessReqId/approval';
  static String REJECT_ACCESS_INVITATION(String accessReqId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/invitations/$accessReqId/rejection';
  static String CREATE_UPDATE_LIGHT_SCENE(String seaPodId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$seaPodId';
  static String UPDATE_ALL_LIGHT_SCENES(String seaPodId, String source) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$seaPodId/$source';
  static String DELETE_LIGHT_SCENE(String sceneId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$sceneId';
  static String TOOGLE_LIGHT_SCENE_STATUS(String seaPodId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$seaPodId/status';
  static String TOOGLE_LIGHT_STATUS(String sceneId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$sceneId/lightStatus';
  static String UPDATE_SELECTED_LIGHTING_SCENE(
          String seaPodId, String selectedLightSceneId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$seaPodId/selected/$selectedLightSceneId';
  static String UPDATE_LIGHT_SCENE_INTENSITY(String seaPodId, int intensity) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$seaPodId/intensity/$intensity';
  static String UPDATE_LIGHT_INTENSITY(String lightSceneId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/lightining-scenes/$lightSceneId/lightIntensity';
  static String UPDATE_BULK_NOTIFICATION_SEEN_STATUS =
      'https://oceanbuilders.herokuapp.com/v1/api/users/notifications';
  static String UPDATE_NOTIFICATION_SEEN_STATUS(String notificationId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/users/notifications/$notificationId';
  static String REMOVE_MEMBER(String seaPodId, String userId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/seapods/$seaPodId/users/$userId';
  static String CREATE_PERMISSION(String seaPodId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/permissions/$seaPodId';
  static String DELETE_PERMISSION(String seaPodId, String permissionId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/permissions/$permissionId/seapod/$seaPodId';
  static String UPDATE_PERMISSION(String permissionId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/permissions/$permissionId';
  static String RENAME_PERMISSION(String seaPodId, String permissionId) =>
      'https://oceanbuilders.herokuapp.com/v1/api/permissions/$permissionId/seapod/$seaPodId/name';

  static String ES_LOGIN =
      'https://www.earth-station-modular.com/api/auth/login';
  static String ES_GET_RECORDS =
      'https://www.earth-station-modular.com/api/data/getRecords';

  static String GET_ACCESS_EVENTS =
      'https://oceanbuilders.herokuapp.com/v1/api/access-requests/user';

  static GET_WEATHER_FLOW_STATION_OBS_DATA(String stationId) =>
      'https://swd.weatherflow.com/swd/rest/observations/station/$stationId';

  static GET_WEATHER_FLOW_DEVICE_OBS_DATA(String deviceId) =>
      'https://swd.weatherflow.com/swd/rest/observations/device/$deviceId';

  static SET_WEATHER_SOURCE(String source) =>
      'https://oceanbuilders.herokuapp.com/v1/api/users/weatherSource/$source';
}
