import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/splash_screen.dart';
import 'package:majadigi_superapp_frontend/screens/onBoarding_screen.dart';
import 'package:majadigi_superapp_frontend/screens/login_screen.dart';
import 'package:majadigi_superapp_frontend/services/notification_service.dart';

import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModuleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majadigi Superapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0065FF)),
        useMaterial3: true,
      ),
      home: const OnBoardingScreen(),
    );
  }
}
