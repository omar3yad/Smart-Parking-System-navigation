import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double carPosition = -150;

  @override
  void initState() {
    super.initState();

    // Show splash screen immediately to overlay Flutter logo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        carPosition = 230;
      });
    });

    // Navigate to next page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/logo.png', width: 300, height: 300),
          ),

          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            bottom: 20,
            left: carPosition,
            child: Image.asset('assets/car.png', width: 120, height: 120),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/road.jpg',
              width: MediaQuery.of(context).size.width,
              height: 50, 
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            bottom: 40,
            right: 0,
            child: Image.asset('assets/halfhouse.png', width: 120, height: 120),
          ),
          Positioned(
            bottom: 45,
            right: 55,
            child: Image.asset('assets/p.png', width: 60, height: 60),
          ),
        ],
      ),
    );
  }
}
