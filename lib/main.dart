import 'package:flutter/material.dart';
import 'package:untitled/Screens/DashBoardScreen/dashboard.dart';
import 'package:untitled/Screens/MainScreen/main_screen.dart';
import 'package:untitled/Screens/SplashScreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreen(),
    );
  }
}
