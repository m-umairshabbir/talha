import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled/Services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    _splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffd7e8fc),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 600 : screenWidth, // Cap width for web
              maxHeight: screenHeight, // Constrain height to fit screen
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/splash.jpg', // Replace with your logo asset path
                  width: screenWidth * 0.5, // Scale image width dynamically
                  height: screenHeight * 0.5, // Scale image height dynamically
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const SpinKitPulse(
                  color: Color(0xff294363),
                  size: 50, // Spinner size
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


