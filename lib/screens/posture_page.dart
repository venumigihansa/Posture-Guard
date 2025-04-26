import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:posture_guard/posture_controller.dart';
import 'package:vibration/vibration.dart';
import 'package:logging/logging.dart';
import 'package:posture_guard/notification_service.dart';

class PostureScreen extends StatefulWidget {
  const PostureScreen({super.key});

  @override
  State<PostureScreen> createState() => _PostureScreenState();
}

class _PostureScreenState extends State<PostureScreen> {
  late MqttServerClient _client;
  final _logger = Logger('PostureScreen');

  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  Future<void> _connectToMqtt({int retryCount = 0, int maxRetries = 5}) async {
    final provider = Provider.of<PostureController>(context, listen: false);
    provider.setPosture("Connecting to MQTT...", 0.0);
    provider.setPostureImage('lib/images/loading.png');

    _client = MqttServerClient(
      '218638469dfa429db85a2e1df0b4f8c7.s1.eu.hivemq.cloud',
      'flutter_client',
    );
    _client.port = 8883;
    _client.logging(on: true);
    _client.secure = true;
    _client.keepAlivePeriod = 20;
    _client.setProtocolV311();
    _client.onBadCertificate = (Object? cert) => true;

    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs('hivemq.webclient.1742574310428', '61b!5CgSPQc>xqu.3@JM')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    if (retryCount >= maxRetries) {
      provider.setPosture("Failed to connect after $maxRetries attempts.", 0.0);
      provider.setPostureImage('lib/images/loading.png');
      return;
    }

    try {
      _logger.info('Trying to connect...');
      await _client.connect();
    } catch (e) {
      _logger.severe('Connection failed: $e');
      _client.disconnect();
      provider.setPosture("Connection failed. Retrying...", 0.0);
      provider.setPostureImage('lib/images/loading.png');
      await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));
      _connectToMqtt(retryCount: retryCount + 1, maxRetries: maxRetries);
      return;
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      _onConnected();
    } else {
      _logger.warning('Failed to connect to MQTT (bad state)');
      provider.setPosture("Failed to connect to MQTT.", 0.0);
      provider.setPostureImage('lib/images/loading.png');
    }
  }

  void _onConnected() {
    final provider = Provider.of<PostureController>(context, listen: false);
    _logger.info("Connected to MQTT broker");
    provider.setPosture("Connected to MQTT. Waiting for data...", 0.0);
    provider.setPostureImage('lib/images/loading.png');
    _client.subscribe('alert/posture', MqttQos.atMostOnce);
    provider.startTracking();

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final MqttPublishMessage recMessage = messages[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      _handleMessage(payload);
    });
  }

  void _onDisconnected() {
    final provider = Provider.of<PostureController>(context, listen: false);
    _logger.warning("Disconnected from MQTT broker");
    provider.setPostureImage('lib/images/loading.png');
    provider.stopTracking();
  }

  void _onSubscribed(String topic) {
    _logger.info("Subscribed to topic: $topic");
  }

  Future<void> _handleMessage(String payload) async {
    final decoded = jsonDecode(payload);
    final String message = decoded['message'];
    final double angle = decoded['angle'];

    final provider = Provider.of<PostureController>(context, listen: false);
    provider.setPosture(message, angle);

    if (message == 'Posture Alert! Continued Incorrect Posture') {
      provider.setPostureImage('lib/images/bad_posture.png');
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 1000);
      }
      NotificationService.showNotification(
        'Posture Alert!',
        'Continued incorrect posture detected. Please correct your posture.',
      );
    } else if (message.contains("Incorrect")) {
      provider.setPostureImage('lib/images/bad_posture.png');
    } else if (message.contains("Posture Corrected")) {
      provider.setPostureImage('lib/images/good_posture.png');
      NotificationService.showNotification(
        'Good Job!',
        'Your posture has been corrected!',
      );
    } else if (message.contains("Idle for too long")) {
      provider.setPostureImage('lib/images/idle.png'); // <<< Add an idle image
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500);
      }
      NotificationService.showNotification(
        'Idle Alert',
        'You have been idle for too long. Time to move!',
      );
    } else {
      _logger.warning('Received unknown message: $message');
    }
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Provider.of<PostureController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "WE GOT YOUR BACK! LITERALLY!",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Keep Track of Your\nPosture Today 🔥",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE0ECFF),
                      spreadRadius: 10,
                      blurRadius: 40,
                      offset: Offset(0, 20),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    controller.postureImage,
                    width: size.width * 0.25,
                    height: size.width * 0.25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Text(
                controller.postureStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Slouch Angle: ${controller.angle.toStringAsFixed(1)}°",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
