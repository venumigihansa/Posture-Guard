import 'package:flutter/material.dart';
import 'package:posture_guard/components/bottom_nav_bar.dart';
import 'package:posture_guard/screens/exercises_page.dart';
import 'package:posture_guard/screens/posture_page.dart';
import 'package:posture_guard/screens/settings_page.dart';
import 'package:posture_guard/screens/stats_page.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

 //navigate bottom bar
  int _selectedIndex=0;
  void navigateBottomBar(int index){
    setState((){
      _selectedIndex =index;
    });

  }

  //pages
  final List<Widget> _pages = [
    //posture page
    PostureScreen(),


    //stats page
    StatsPage(),

    ExercisesPage(),

    ModernSettingsPage(),

  


    //settings page
    //SettingsPage(),

    //Exercises page


  ];






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}