import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/screens/home_screen.dart';
import 'package:majadigi_superapp_frontend/screens/welcome_screen.dart';
import 'package:majadigi_superapp_frontend/screens/login_screen.dart';
import 'package:majadigi_superapp_frontend/utils/app_colors.dart';
import 'package:majadigi_superapp_frontend/widgets/splash_footer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Show splash screen for at least 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = await authProvider.checkLoginStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              AppColors.accentBlue,
              AppColors.primaryBlue,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: NetworkPatternPainter(),
              ),
            ),
            // Logo and Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
            // Footer
            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SplashFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Simple geometric lines to simulate a network pattern
    for (var i = 0; i < 10; i++) {
      path.moveTo(0, size.height * (i / 10));
      path.lineTo(size.width, size.height * ((i + 2) / 10));
      
      path.moveTo(size.width * (i / 10), 0);
      path.lineTo(size.width * ((i + 3) / 10), size.height);
    }

    canvas.drawPath(path, paint);
    
    // Add some "nodes"
    final nodePaint = Paint()
      ..color = AppColors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 4, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 6, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.8), 5, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.7), 3, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
