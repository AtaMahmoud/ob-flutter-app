import 'dart:convert';

import 'package:flutter/services.dart';

abstract class ConfigReader {
  static Map<String, dynamic> _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getStormGlassApiKey() {
    return _config['apiKeyStormGlass'] as String;
  }

  static String getWeatherFlowApiKey() {
    return _config['apiKeyWeatherFlow'] as String;
  }

  static String getMqttServer(){
    return _config['mqttServer'] as String;
  }

  static int getMqttPort(){
    return _config['mqttPort'] as int;
  }

  static String getMqttIdentifier(){
    return _config['mqttIdentifier'] as String;
  }

  static String getMqttUserName(){
    return _config['mqttUserName'] as String;
  }

  static String getMqttPassword(){
    return _config['mqttPassword'] as String;
  }

  static String getMqttTopic(){
    return _config['mqttTopic'] as String;
  }

  static String getMqttWildCardTopic(){
    return _config['mqttWlidCard'] as String;
  }

    static String getIotServerApiKey(){
    return _config['apiKeyIotServer'] as String;
  }
}