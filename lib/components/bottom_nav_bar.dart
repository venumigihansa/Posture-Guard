import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key,required this.onTabChange,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: GNav(
        onTabChange: (value) => onTabChange!(value) ,
        color: Colors.grey[400],
        mainAxisAlignment: MainAxisAlignment.center,
        tabBackgroundColor: Colors.grey.shade300,
        tabBorderRadius: 24,
        tabActiveBorder: Border.all(color: Colors.white),
        tabs:[
          GButton(
            icon: Icons.accessibility_new,
            text: 'Posture',
            ),
          GButton(
            icon: Icons.bar_chart, 
            text: 'stats',
            ),

          GButton(
            icon: Icons.fitness_center, 
            text: 'Exercises',
            ),        

          GButton(
            icon: Icons.settings, 
            text: 'settings',
            ),        

            
      
      ]),
    );
  }
}