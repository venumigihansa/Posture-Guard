import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:posture_guard/Hive model/hive.dart';

class PostureController extends ChangeNotifier {
  String postureStatus = "Waiting for data...";
  double angle = 0.0;

  Duration _connectedDuration = Duration.zero;
  Duration _slouchDuration = Duration.zero;
  DateTime? _lastPostureChange;
  bool _isSlouching = false;
  Timer? _timer;

  late String _currentDateKey;

  String _postureImage = 'lib/images/loading.png'; // Default image
  String get postureImage => _postureImage;

  PostureController() {
    _currentDateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void setPosture(String newStatus, double newAngle) {
    angle = newAngle;
    bool isNowSlouching = newStatus.contains("Incorrect");

    final now = DateTime.now();
    final newDateKey = DateFormat('yyyy-MM-dd').format(now);

    if (newDateKey != _currentDateKey) {
      _currentDateKey = newDateKey;
      _connectedDuration = Duration.zero;
      _slouchDuration = Duration.zero;
      _lastPostureChange = now;
      _isSlouching = isNowSlouching;
    }

    if (_isSlouching != isNowSlouching) {
      _updateDurations();
      _lastPostureChange = now;
      _isSlouching = isNowSlouching;
    }

    postureStatus = newStatus;
    saveDailyStat();
    notifyListeners();
  }

  void setPostureImage(String imagePath) {
    _postureImage = imagePath;
    notifyListeners();
  }

  void startTracking() {
    _lastPostureChange = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDurations();
      saveDailyStat();
    });
  }

  void stopTracking() {
    _updateDurations();
    _timer?.cancel();
  }

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

  Duration get slouchTime => _slouchDuration;
  Duration get connectedTime => _connectedDuration;

  double get slouchPercentage {
    if (_connectedDuration.inSeconds == 0) return 0.0;
    return (_slouchDuration.inSeconds / _connectedDuration.inSeconds) * 100;
  }

  void resetDailyStats() {
    _connectedDuration = Duration.zero;
    _slouchDuration = Duration.zero;
    _lastPostureChange = DateTime.now();
    _isSlouching = false;
    notifyListeners();
  }

  Future<void> saveDailyStat() async {
    final box = Hive.box('mybox');
    final dateKey = _currentDateKey;

    final stat = DailyPostureStat(
      date: DateTime.now(),
      slouchTime: _slouchDuration,
      slouchPercentage: slouchPercentage,
    );

    await box.put(dateKey, stat);
  }

  List<DailyPostureStat> getWeeklyStats() {
    final box = Hive.box('mybox');
    final now = DateTime.now();
    final List<DailyPostureStat> weekStats = [];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(date);
      final stat = box.get(key);

      if (stat != null && stat is DailyPostureStat) {
        weekStats.add(stat);
      } else {
        weekStats.add(DailyPostureStat(
          date: date,
          slouchTime: Duration.zero,
          slouchPercentage: 0,
        ));
      }
    }

    return weekStats;
  }
}
