import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:posture_guard/screens/splash_screen.dart';
import 'package:posture_guard/posture_controller.dart';
import 'package:logging/logging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart'; // Import notification service
import 'package:posture_guard/Hive%20model/hive.dart'; // Correct the import path

void main() async {
  _setupLogging();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(DailyPostureStatAdapter()); // Register the adapter for your model

  var box = await Hive.openBox('mybox'); // Open a typed box

  // Initialize notification service
  await NotificationService.initialize();

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
