import 'package:flutter/material.dart';
import 'dart:async';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final List<Map<String, dynamic>> _exercises = [
    {
      'name': 'Cat-Cow Stretch',
      'description': 'A gentle flow between two poses that warms the spine and relieves back tension.',
      'duration': '1-2 minutes',
      'image': 'lib/images/cat_cow.jpg',
    },
    {
      'name': 'Child\'s Pose',
      'description': 'A resting pose that gently stretches the lower back and promotes relaxation.',
      'duration': '30-60 seconds',
      'image': 'lib/images/childs_pose.jpg',
    },
    {
      'name': 'Seated Spinal Twist',
      'description': 'Improves spine mobility and relieves tension in the back muscles.',
      'duration': '30 seconds each side',
      'image': 'lib/images/spinal_twist.jpg',
    },
    {
      'name': 'Bridge Pose',
      'description': 'Strengthens the back muscles and improves posture.',
      'duration': '10-15 repetitions',
      'image': 'lib/images/bridge.jpg',
    },
    {
      'name': 'Superman Exercise',
      'description': 'Strengthens the lower back muscles and improves core stability.',
      'duration': '10-12 repetitions',
      'image': 'lib/images/superman.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "BACK HEALTH MATTERS",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Exercises & Stretches\nFor Your Back",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseCard(exercise: _exercises[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE0ECFF),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full natural-size image
            Image.asset(
              exercise['image'],
              fit: BoxFit.contain,
              width: double.infinity,
            ),
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                exercise['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Duration: ${exercise['duration']}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              children: [
                Text(
                  exercise['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showTimerDialog(context, exercise['name'], exercise['duration']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Start Timer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTimerDialog(BuildContext context, String exerciseName, String duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer for $exerciseName'),
          content: ExerciseTimer(duration: duration),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ExerciseTimer extends StatefulWidget {
  final String duration;

  const ExerciseTimer({
    super.key,
    required this.duration,
  });

  @override
  State<ExerciseTimer> createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late int _seconds;
  bool _isRunning = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _seconds = _parseDuration(widget.duration);
  }

  int _parseDuration(String duration) {
    if (duration.contains('seconds')) {
      return int.tryParse(duration.split(' ')[0]) ?? 30;
    } else if (duration.contains('minute')) {
      return (int.tryParse(duration.split(' ')[0]) ?? 1) * 60;
    } else {
      return 30;
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _timer.cancel();
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _startTimer,
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: _isRunning ? _stopTimer : null,
              child: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}
