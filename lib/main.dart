import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DriveboyApp());
}

class DriveboyApp extends StatelessWidget {
  const DriveboyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driveboy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'SF Pro',
      ),
      home: const HomeScreen(),
    );
  }
}
