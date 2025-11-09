/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Splash screen shows app title for 3 seconds.
 */

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Smart Budget Tracker Lite',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
