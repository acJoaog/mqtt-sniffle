import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttServerClient? _client;
  final String server;
  final int port;
  final String clientId;
  final String? username;
  final String? password;

  MqttManager({
    required this.server,
    required this.port,
    required this.clientId,
    this.username,
    this.password,
  });

  Future<void> connect() async {
    _client = MqttServerClient(server, clientId);
    _client!.port = port;

    _client!.logging(on: false);
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .authenticateAs(username, password)
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
      print('Connected to MQTT broker');

      _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

        print('Received message: topic=${c[0].topic}, payload=$payload');
        // You can add your own logic here to handle the received message
      });
    } catch (e) {
      print('Failed to connect: $e');
      disconnect();
    }
  }

  Future<void> subscribe(String topic) async {
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.subscribe(topic, MqttQos.atMostOnce);
      print('Subscribed to topic: $topic');
    } else {
      print('Not connected to the MQTT broker');
    }
  }

  Future<void> publish(String topic, String message) async {
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      print('Published to topic: $topic, message: $message');
    } else {
      print('Not connected to the MQTT broker');
    }
  }

  Future<void> disconnect() async {
    if (_client != null &&
        _client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.disconnect();
      print('Disconnected from MQTT broker');
    }
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker');
  }

  void _onMessage(String topic, MqttReceivedMessage<MqttMessage> message) {
    final recMess = message.payload as MqttPublishMessage;
    final payload =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('Received message on topic: $topic, message: $payload');
    // You can add your own logic here to handle the received message
  }
}

void main() async {
  final mqttManager = MqttManager(
    server: '192.168.66.50',
    port: 1883,
    clientId: 'mqtt-sniffle',
    username: 'csilab',
    password: 'WhoAmI#2023',
  );

  await mqttManager.connect();
  await mqttManager.subscribe('connection');
  await mqttManager.publish('main', 'Hello, MQTT!');
  //await mqttManager.disconnect();
}
