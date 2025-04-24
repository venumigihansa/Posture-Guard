import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posture_guard/screens/splash_screen.dart';
import 'package:posture_guard/posture_controller.dart';
import 'package:logging/logging.dart'; // <- Add this import

void main() {
  _setupLogging(); // <- Add this line

  runApp(
    ChangeNotifierProvider(
      create: (_) => PostureController(),
      child: const MyApp(),
    ),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // Log all messages
  Logger.root.onRecord.listen((record) {
    // This will print to your terminal / debug console
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
