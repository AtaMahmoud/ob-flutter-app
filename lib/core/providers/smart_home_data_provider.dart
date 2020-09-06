import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/repositories/smart_home_node_repository.dart';

class SmartHomeDataProvider extends ChangeNotifier {
  Future<MqttServerClient> connect() async {
    MqttServerClient client = MqttServerClient(Config.MQTT_SERVER, '');
    //  MqttServerClient client = MqttServerClient.withPort(Config.MQTT_SERVER, Config.MQTT_IDENTIFIER, Config.MQTT_PORT);
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(Config.MQTT_IDENTIFIER)
        .authenticateAs(Config.MQTT_USER, Config.MQTT_PASSWORD)
        .keepAliveFor(60)
        // .withWillTopic('willtopic')
        // .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('-------Exception at connecting with : $e');
      client.disconnect();
    }

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      print(c.toString());
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
    }).onError((e){
      print(e);
    });

    return client;
  }

// connection succeeded
  void onConnected() {
    notifyListeners();
    print('-------------------Connected---------------------');
  }

// unconnected
  void onDisconnected() {
    print('--------------------Disconnected--------------------');
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }

// nodejs server

  SmartHomeServerRepository _smartHomeServerRepository =
      SmartHomeServerRepository();

  Future<List<IotEventData>> fetchAllSensorData() async {
    notifyListeners();
    List<IotEventData> allSensorData = [];
    try {
      allSensorData = await _smartHomeServerRepository.getAllSensorData();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    print(allSensorData.toString());
    return allSensorData;
  }

  Future<List<IotEventData>> fetchSensorDataById(int id) async {
    notifyListeners();
    List<IotEventData> allSensorData = [];
    try {
      allSensorData = await _smartHomeServerRepository.getSensorDataById(id);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    print(allSensorData.toString());
    return allSensorData;
  }

  Future<List<IotEventData>> fetchSensorDataLast3Days() async {
    notifyListeners();
    List<IotEventData> allSensorData = [];
    try {
      allSensorData =
          await _smartHomeServerRepository.getSensorDataBetweenDates();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    print(allSensorData.toString());
    return allSensorData;
  }
}
