import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/parking_provider.dart';
import 'providers/payment_provider.dart';

import 'repositories/auth_repository.dart';
import 'repositories/parking_repository.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ParkingProvider>(
          create: (_) => ParkingProvider(ParkingRepository())
            ..loadSummary()
            ..loadSlots(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(AuthRepository()),
        ),
        ChangeNotifierProvider<PaymentProvider>(
          create: (_) => PaymentProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(), 
      ),
    );
  }
}
