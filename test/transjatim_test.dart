import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/transjatim_provider.dart';
import 'package:majadigi_superapp_frontend/models/transjatim_model.dart';
import 'package:majadigi_superapp_frontend/screens/transjatim_tracking_screen.dart';

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(MockHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return Future.value(MockHttpClientRequest());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    try {
      return super.noSuchMethod(invocation);
    } catch (_) {
      return null;
    }
  }
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() {
    return Future.value(MockHttpClientResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    try {
      return super.noSuchMethod(invocation);
    } catch (_) {
      return null;
    }
  }
}

class MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    try {
      return super.noSuchMethod(invocation);
    } catch (_) {
      return null;
    }
  }
}

class MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  static final List<int> _transparentImage = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
    0x42, 0x60, 0x82
  ];

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    try {
      return super.noSuchMethod(invocation);
    } catch (_) {
      return null;
    }
  }
}

class MockTransJatimProvider extends TransJatimProvider {
  List<Koridor> _mockKoridors = [];
  List<Armada> _mockArmadas = [];
  bool _mockLoading = false;

  @override
  List<Koridor> get koridorList => _mockKoridors;

  @override
  List<Armada> get armadaList => _mockArmadas;

  @override
  bool get isLoadingArmada => _mockLoading;

  void setMockKoridors(List<Koridor> list) {
    _mockKoridors = list;
    notifyListeners();
  }

  void setMockArmadas(List<Armada> list) {
    _mockArmadas = list;
    notifyListeners();
  }

  void setLoading(bool val) {
    _mockLoading = val;
    notifyListeners();
  }

  @override
  Future<void> fetchKoridor() async {
    // No-op
  }

  @override
  Future<void> fetchArmada(String koridorId) async {
    // No-op
  }
}

void main() {
  group('TransJatim Live Tracking Integration Tests', () {
    test('Armada model parses correctly from JSON', () {
      final json = {
        'id': 'f2d72ab8-da1e-4d5f-832f-430583c9ce87',
        'koridor_id': '9d6b1585-f8fc-4fc3-bf3e-cf7fd08a48be',
        'kode_bus': 'TJ-01-A',
        'kapasitas': 60,
        'lat': -7.3512,
        'lng': 112.7242,
        'status': 'aktif',
        'updated_at': '2026-05-26T04:29:53Z'
      };

      final armada = Armada.fromJson(json);

      expect(armada.id, 'f2d72ab8-da1e-4d5f-832f-430583c9ce87');
      expect(armada.kodeBus, 'TJ-01-A');
      expect(armada.lat, -7.3512);
      expect(armada.lng, 112.7242);
      expect(armada.status, 'aktif');
    });

    testWidgets('TransjatimTrackingScreen renders drop down and dynamic armada lists', (WidgetTester tester) async {
      await HttpOverrides.runWithHttpOverrides(() async {
        final mockProvider = MockTransJatimProvider();
        mockProvider.setMockKoridors([
          Koridor(
            id: '9d6b1585-f8fc-4fc3-bf3e-cf7fd08a48be',
            kode: 'TJ-01',
            nama: 'Koridor 1 - Purabaya - Darmo',
            asal: 'Terminal Purabaya',
            tujuan: 'Jl. Darmo',
            isActive: true,
          )
        ]);

        mockProvider.setMockArmadas([
          Armada(
            id: 'f2d72ab8-da1e-4d5f-832f-430583c9ce87',
            koridorId: '9d6b1585-f8fc-4fc3-bf3e-cf7fd08a48be',
            kodeBus: 'TJ-01-A',
            kapasitas: 60,
            lat: -7.3512,
            lng: 112.7242,
            status: 'aktif',
            updatedAt: '2026-05-26T04:29:53Z',
          ),
        ]);

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<TransJatimProvider>.value(
              value: mockProvider,
              child: const TransjatimTrackingScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check header and tab navigation
        expect(find.text('Transjatim'), findsOneWidget);
        expect(find.text('Tracking'), findsOneWidget);

        // Check dropdown and selected corridor
        expect(find.text('TJ-01 - Koridor 1 - Purabaya - Darmo'), findsOneWidget);

        // Check dynamic list and map markers (2 instances of TJ-01-A)
        expect(find.text('TJ-01-A'), findsNWidgets(2));
        expect(find.text('Beroperasi'), findsOneWidget);

        // Check map section renders dynamic map name
        expect(find.text('Peta: Koridor 1 - Purabaya - Darmo'), findsOneWidget);
      }, MockHttpOverrides());
    });
  });
}
