import 'package:flutter/material.dart';

class PostureController extends ChangeNotifier {
  String postureStatus = "Waiting for data...";
  double angle = 0.0;

  void setPosture(String newStatus, double newAngle) {
    postureStatus = newStatus;
    angle = newAngle;
    notifyListeners();
  }
}
