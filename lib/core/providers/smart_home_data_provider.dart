import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/configs/app_configurations.dart';
import 'package:ocean_builder/core/models/iot_event_data.dart';
import 'package:ocean_builder/core/repositories/smart_home_node_repository.dart';
import 'package:ocean_builder/ui/screens/designSteps/smart_home_screen.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class SmartHomeDataProvider extends ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;
  String _receivedText = '';
  String _historyText = '';
  List<SensorData> _sensorDataList = [];

  // temporary
  String _ledStatus = "";

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

  void setSensorData(SensorData sensorData){
    _sensorDataList.add(sensorData);
    notifyListeners();
  }

  void setLedStatus(String ledStat){
    _ledStatus = ledStat;
    notifyListeners();
  }

  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  List<SensorData> get sensorDataList => _sensorDataList;
  String get ledControl => _ledStatus;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  Future<MqttServerClient> connect() async {
    _client = new MqttServerClient(Config.MQTT_SERVER, "");
    _client.setProtocolV311();
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
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
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
    // send message to all topics
    // final builder1 = MqttClientPayloadBuilder();
    // builder1.addString('Every');
    // print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
    // _client.publishMessage("byron/#", MqttQos.exactlyOnce, builder1.payload,retain: true);

    // _client.subscribe(Config.MQTT_TOPIC_WILD_CARD, MqttQos.atMostOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      print('------------lsitenning to  message -----------');
      // print(c.toString());
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      // print('------------got broadcasted message -----------');
      // print('Received message:$payload from topic: ${c[0].topic}>');
      for (var i = 0; i < c.length; i++) {
        print('Received message:$payload from topic: ${c[i].topic}>');
      }
      // setReceivedText('Received payload:$payload from topic: ${c[0].topic}');

      if(c[0].topic.compareTo("test/message/status")==0){
        setLedStatus(payload);
      }else{
      var topics = c[0].topic.split("/");
      SensorData sensorData = SensorData(roomName: topics.first, sensorName: topics.last,sensorData: payload);
      setSensorData(sensorData);
      }
      // notifyListeners();
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

  Future<List<IotTopic>> fetchAllTopicsData() async {
    notifyListeners();
    List<IotTopic> allTopicData = [];
    try {
      allTopicData = await _smartHomeServerRepository.getAllTopicData();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      notifyListeners();
    }
    return allTopicData;
  }    

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
class SensorData {
  String roomName;
  String sensorName;
  String sensorData;

  SensorData({this.roomName,this.sensorName,this.sensorData});

}