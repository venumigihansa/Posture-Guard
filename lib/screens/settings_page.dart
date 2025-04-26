import 'package:flutter/material.dart';

class ModernSettingsPage extends StatefulWidget {
  const ModernSettingsPage({super.key});

  @override
  State<ModernSettingsPage> createState() => _ModernSettingsPageState();
}

class _ModernSettingsPageState extends State<ModernSettingsPage> {
  double _thresholdValue = 70.0;
  bool _soundAlertsEnabled = true;
  bool _vibrationAlertsEnabled = true; // Added vibration toggle!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                "Posture Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Threshold Setting
              _buildSectionTitle("Posture Threshold"),
              _buildSectionSubtitle(
                "Adjust the angle threshold for posture alerts. Higher values mean stricter posture monitoring.",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("50°", style: TextStyle(color: Colors.grey)),
                  Expanded(
                    child: Slider(
                      value: _thresholdValue,
                      min: 50.0,
                      max: 80.0,
                      divisions: 30,
                      activeColor: Colors.blue[200],
                      label: "${_thresholdValue.round()}°",
                      onChanged: (value) {
                        setState(() => _thresholdValue = value);
                      },
                    ),
                  ),
                  const Text("80°", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Text(
                "Current threshold: ${_thresholdValue.round()}°",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              // Sound Alerts Toggle
              _buildSwitchTile(
                title: "Sound Alerts",
                subtitle: "Enable or disable sound notifications for posture alerts.",
                value: _soundAlertsEnabled,
                onChanged: (bool value) {
                  setState(() => _soundAlertsEnabled = value);
                },
              ),

              const SizedBox(height: 20),

              // Vibration Alerts Toggle
              _buildSwitchTile(
                title: "Vibration Alerts",
                subtitle: "Enable or disable vibration notifications for posture alerts.",
                value: _vibrationAlertsEnabled,
                onChanged: (bool value) {
                  setState(() => _vibrationAlertsEnabled = value);
                },
              ),

              const SizedBox(height: 40),

              // Apply Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings applied successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Apply Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Section Title
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Helper: Section Subtitle
  Widget _buildSectionSubtitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  // Helper: SwitchTile
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
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
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        value: value,
        activeColor: Colors.blue[200],
        onChanged: onChanged,
      ),
    );
  }
}
