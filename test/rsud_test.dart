import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/rsud_provider.dart';
import 'package:majadigi_superapp_frontend/models/rsud_model.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_queue_status_screen.dart';

class MockRsudProvider extends RsudProvider {
  Antrean? _mockAntrean;

  @override
  Antrean? get lastAntrean => _mockAntrean;

  void setMockAntrean(Antrean antrean) {
    _mockAntrean = antrean;
    notifyListeners();
  }
}

void main() {
  testWidgets('RsudQueueStatusScreen displays correct active clinic and queue position', (WidgetTester tester) async {
    final mockProvider = MockRsudProvider();
    mockProvider.setMockAntrean(Antrean(
      antreanId: 'test-id',
      nomorAntrean: 'A-001',
      poli: 'Anak',
      dokter: 'dr. Budi Santoso Sp.A',
      estimasiJam: '08:00',
      qrCheckin: 'test-qr',
      status: 'menunggu',
    ));

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<RsudProvider>.value(
          value: mockProvider,
          child: const RsudQueueStatusScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify top card details
    expect(find.text('A-001'), findsWidgets);
    expect(find.text('Anak'), findsWidgets);
    expect(find.text('dr. Budi Santoso Sp.A'), findsWidgets);

    // Verify Sedang dilayani in top card
    expect(find.text('A-001'), findsWidgets); // Should match currentServing too

    // Verify bottom list Poli Anak has 1 Antrean and Sedang dilayani
    expect(find.text('1 Antrean'), findsOneWidget);
    expect(find.text('Sedang dilayani'), findsOneWidget);
  });
}
