import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static getFirstInstallStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstRun = false;
    if (prefs.getBool('first_run') ?? true) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.deleteAll();
      isFirstRun = true;
      prefs.setBool('first_run', false);
    } else {
      isFirstRun = false;
    }

    return isFirstRun;
  }

  static setCurrentOB(String obId) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: SharedPreferanceKeys.KEY_SELECTED_OB_ID, value: obId);
  }

  static Future<String> getCurrentOB() async {
    String obId = '';
    final storage = new FlutterSecureStorage();
    obId = await storage.read(key: SharedPreferanceKeys.KEY_SELECTED_OB_ID);
    return obId;
  }

  static setProfilePicFilePath(String profilePicPath) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: SharedPreferanceKeys.KEY_PROFILE_PIC, value: profilePicPath);
  }

  static Future<String> getProfilePicFilePath() async {
    String profilePicFilePath = '';
    final storage = new FlutterSecureStorage();
    profilePicFilePath =
        await storage.read(key: SharedPreferanceKeys.KEY_PROFILE_PIC);
    return profilePicFilePath;
  }

  static setAuthKey(String authToken) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: SharedPreferanceKeys.KEY_X_AUTH_TOKEN, value: authToken);
  }

  static Future<String> getAuthKey() async {
    String authToken = '';
    final storage = new FlutterSecureStorage();
    authToken = await storage.read(key: SharedPreferanceKeys.KEY_X_AUTH_TOKEN);
    return authToken;
  }

  static setEsAuthKey(String authToken) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: SharedPreferanceKeys.KEY_X_AUTH_TOKEN_EARTH_STATION,
        value: authToken);
  }

  static Future<String> getEsAuthKey() async {
    String authToken = '';
    final storage = new FlutterSecureStorage();
    authToken = await storage.read(
        key: SharedPreferanceKeys.KEY_X_AUTH_TOKEN_EARTH_STATION);
    return authToken;
  }

  static setEmail(String email) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: SharedPreferanceKeys.KEY_EMAIL, value: email);
  }

  static Future<String> getEmail() async {
    String email = '';
    final storage = new FlutterSecureStorage();
    email = await storage.read(key: SharedPreferanceKeys.KEY_EMAIL);
    return email;
  }
}
