import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/repositories/smart_home_node_repository.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class SmartHomeDataProvider extends ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';

  MqttServerClient _client;

  void setReceivedText(String text) {
    _receivedText = text;
    _historyText = _historyText + '\n\n' + _receivedText;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  Future<MqttServerClient> connect() async {
    _client = new MqttServerClient("mqtt.technoid.info", "");
    _client.logging(on: false);
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onUnsubscribed = onUnsubscribed;
    _client.onSubscribed = onSubscribed;
    _client.onSubscribeFail = onSubscribeFail;
    _client.pongCallback = pong;
    _client.autoReconnect = true;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .authenticateAs(Config.MQTT_USER, Config.MQTT_PASSWORD)
        // .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    _client.connectionMessage = connMess;

    try {
      setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
    } catch (e) {
      print('-------Exception at connecting with : $e');
      _client.disconnect();
    }

    return _client;
  }

// connection succeeded
  void onConnected() {
    print('-------------------Connected---------------------');
    setAppConnectionState(MQTTAppConnectionState.connected);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      print('------------lsitenning to  message -----------');
      // print(c.toString());
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print('------------got broadcasted message -----------');
      print('Received message:$payload from topic: ${c[0].topic}>');
      setReceivedText('Received payload:$payload from topic: ${c[0].topic}');
      notifyListeners();
    }).onError((e) {
      print(e);
    });
  }

// unconnected
  void onDisconnected() {
    print('--------------------Disconnected--------------------');
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    setAppConnectionState(MQTTAppConnectionState.disconnected);
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
    return allSensorData;
  }
}
