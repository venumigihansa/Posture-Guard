import 'dart:async';
import 'package:flutter/material.dart';

class PostureController extends ChangeNotifier {
  String postureStatus = "Waiting for data...";
  double angle = 0.0;

  // Time tracking variables
  Duration _connectedDuration = Duration.zero;
  Duration _slouchDuration = Duration.zero;
  DateTime? _lastPostureChange;
  bool _isSlouching = false;
  Timer? _timer;

  // Set posture status and angle from MQTT message
  void setPosture(String newStatus, double newAngle) {
    angle = newAngle;
    bool isNowSlouching = newStatus.contains("Incorrect");

    if (_isSlouching != isNowSlouching) {
      _updateDurations(); // Track time spent in previous state
      _lastPostureChange = DateTime.now();
      _isSlouching = isNowSlouching;
    }

    postureStatus = newStatus;
    notifyListeners();
  }

  // Start tracking when MQTT connects
  void startTracking() {
    _lastPostureChange = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDurations();
    });
  }

  // Stop tracking when MQTT disconnects or app closes
  void stopTracking() {
    _updateDurations();
    _timer?.cancel();
  }

  // Update connection and slouch time
  void _updateDurations() {
    if (_lastPostureChange == null) return;

    final now = DateTime.now();
    final diff = now.difference(_lastPostureChange!);
    _connectedDuration += diff;

    if (_isSlouching) {
      _slouchDuration += diff;
    }

    _lastPostureChange = now;
  }

  // Getters to access stats
  Duration get slouchTime => _slouchDuration;
  Duration get connectedTime => _connectedDuration;

  double get slouchPercentage {
    if (_connectedDuration.inSeconds == 0) return 0.0;
    return (_slouchDuration.inSeconds / _connectedDuration.inSeconds) * 100;
  }

  // To reset daily stats at midnight or manually
  void resetDailyStats() {
    _connectedDuration = Duration.zero;
    _slouchDuration = Duration.zero;
    _lastPostureChange = DateTime.now();
    _isSlouching = false;
    notifyListeners();
  }
}
