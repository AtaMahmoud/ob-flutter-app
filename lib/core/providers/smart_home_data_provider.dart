import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ocean_builder/configs/app_configurations.dart';

class SmartHomeDataProvider extends ChangeNotifier {
  
Future<MqttServerClient> connect() async {
  debugPrint('----${Config.MQTT_SERVER}-----------${Config.MQTT_IDENTIFIER}----${Config.MQTT_PORT}----${Config.MQTT_USER}----${Config.MQTT_PASSWORD}----${Config.MQTT_TOPIC}');
  MqttServerClient client = MqttServerClient(Config.MQTT_SERVER,'');
    //  MqttServerClient client = MqttServerClient.withPort(Config.MQTT_SERVER, Config.MQTT_IDENTIFIER, Config.MQTT_PORT);
  client.logging(on: true);
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
      final MqttPublishMessage message = c[0].payload;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
    });

    return client;
  }

// connection succeeded
void onConnected() {
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
}
