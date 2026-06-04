import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/splash_screen.dart';
import 'package:majadigi_superapp_frontend/screens/onBoarding_screen.dart';
import 'package:majadigi_superapp_frontend/screens/login_screen.dart';
import 'package:majadigi_superapp_frontend/services/notification_service.dart';

import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/providers/dashboard_provider.dart';
import 'package:majadigi_superapp_frontend/providers/islamic_center_provider.dart';
import 'package:majadigi_superapp_frontend/providers/rsud_provider.dart';
import 'package:majadigi_superapp_frontend/providers/transjatim_provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapok_provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapenda_provider.dart';
import 'package:majadigi_superapp_frontend/providers/bansos_provider.dart';
import 'package:majadigi_superapp_frontend/providers/sinaker_provider.dart';
import 'package:majadigi_superapp_frontend/providers/wisata_provider.dart';
import 'package:majadigi_superapp_frontend/providers/darurat_provider.dart';
import 'package:majadigi_superapp_frontend/providers/etibi_provider.dart';

import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  // Set up unauthorized handler
  DioClient.onUnauthorized = () {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Provider.of<AuthProvider>(context, listen: false).logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi telah berakhir, silakan login kembali'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModuleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => IslamicCenterProvider()),
        ChangeNotifierProvider(create: (_) => RsudProvider()),
        ChangeNotifierProvider(create: (_) => TransJatimProvider()),
        ChangeNotifierProvider(create: (_) => BapokProvider()),
        ChangeNotifierProvider(create: (_) => BapendaProvider()),
        ChangeNotifierProvider(create: (_) => BansosProvider()),
        ChangeNotifierProvider(create: (_) => SinakerProvider()),
        ChangeNotifierProvider(create: (_) => WisataProvider()),
        ChangeNotifierProvider(create: (_) => DaruratProvider()),
        ChangeNotifierProvider(create: (_) => EtibiProvider()),
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
      navigatorKey: navigatorKey,
      title: 'Majadigi Superapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0065FF)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
