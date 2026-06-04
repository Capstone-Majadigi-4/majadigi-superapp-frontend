import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/screens/register_screen.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';

class MockAuthProvider extends AuthProvider {
  bool _mockRegisterSuccess = true;
  String? _mockErrorMsg;
  bool _registerCalled = false;

  bool get registerCalled => _registerCalled;

  void setMockRegisterResult({required bool success, String? error}) {
    _mockRegisterSuccess = success;
    _mockErrorMsg = error;
  }

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => _mockErrorMsg;

  @override
  Future<bool> register({
    required String nik,
    required String password,
    required String nama,
    required String noHp,
  }) async {
    _registerCalled = true;
    return _mockRegisterSuccess;
  }
}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  group('Auth Registration Flow Tests', () {
    testWidgets('RegisterScreen validation and multi-step flow test', (WidgetTester tester) async {
      await HttpOverrides.runWithHttpOverrides(() async {
        final mockAuthProvider = MockAuthProvider();

        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          ChangeNotifierProvider<AuthProvider>.value(
            value: mockAuthProvider,
            child: const MaterialApp(
              home: RegisterScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 1. Initial State: Should display Step 1 Title & Fields
        expect(find.text('Daftar'), findsOneWidget);
        expect(find.text('Langkah 1 dari 2'), findsOneWidget);
        expect(find.text('Nama depan'), findsOneWidget);
        expect(find.text('No HP'), findsOneWidget);

        // 2. Try to click "Selanjutnya" without filling fields (Validation Error should trigger)
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();

        expect(find.text('Nama depan wajib diisi'), findsOneWidget);
        expect(find.text('Nomor HP wajib diisi'), findsOneWidget);

        // 3. Fill in Step 1 fields (invalid phone number test)
        await tester.enterText(find.widgetWithText(TextFormField, 'Nama depan'), 'Budi');
        await tester.enterText(find.widgetWithText(TextFormField, 'No HP'), 'abc'); // invalid phone
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();

        expect(find.text('Nomor HP harus berupa angka'), findsOneWidget);

        // 4. Fill in Step 1 fields (valid values)
        await tester.enterText(find.widgetWithText(TextFormField, 'No HP'), '081234567890');
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();

        // Should successfully transition to Step 2
        expect(find.text('Langkah 2 dari 2'), findsOneWidget);
        expect(find.text('NIK'), findsOneWidget);
        expect(find.text('Kata sandi'), findsOneWidget);

        // 5. Try to click "Daftar" without filling step 2 required fields
        await tester.tap(find.widgetWithText(CustomButton, 'Daftar'));
        await tester.pumpAndSettle();

        expect(find.text('NIK wajib diisi'), findsOneWidget);
        expect(find.text('Kata sandi wajib diisi'), findsOneWidget);

        // 6. Fill in Step 2 NIK (invalid format)
        await tester.enterText(find.widgetWithText(TextFormField, 'NIK'), '123'); // NIK not 16 digits
        await tester.tap(find.widgetWithText(CustomButton, 'Daftar'));
        await tester.pumpAndSettle();
        expect(find.text('NIK harus tepat 16 digit'), findsOneWidget);

        // 7. Fill in Step 2 valid details, but mismatching password
        await tester.enterText(find.widgetWithText(TextFormField, 'NIK'), '3578010101900002');
        await tester.enterText(find.widgetWithText(TextFormField, 'Kata sandi'), 'password123');
        await tester.enterText(find.widgetWithText(TextFormField, 'Ulangi Kata sandi'), 'different123');
        await tester.tap(find.widgetWithText(CustomButton, 'Daftar'));
        await tester.pumpAndSettle();
        expect(find.text('Kata sandi tidak cocok'), findsOneWidget);

        // 8. Match passwords and Submit (should call AuthProvider.register)
        await tester.enterText(find.widgetWithText(TextFormField, 'Ulangi Kata sandi'), 'password123');
        await tester.tap(find.widgetWithText(CustomButton, 'Daftar'));
        await tester.pump(); // Start API submission / loading dialog
        
        expect(mockAuthProvider.registerCalled, isTrue);
      }, MockHttpOverrides());
    });
  });
}
