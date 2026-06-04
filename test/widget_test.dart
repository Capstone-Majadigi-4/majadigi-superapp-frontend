import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/screens/splash_screen.dart';

class MockAuthProvider extends AuthProvider {
  @override
  Future<bool> checkLoginStatus() async {
    return false;
  }
}

void main() {
  testWidgets('SplashScreen rendering test', (WidgetTester tester) async {
    final mockProvider = MockAuthProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockProvider,
          child: const SplashScreen(),
        ),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    // Let the splash screen timer run out to avoid pending timer exception
    await tester.pump(const Duration(milliseconds: 3000));
  });
}

