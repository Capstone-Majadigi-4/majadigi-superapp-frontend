import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/darurat_provider.dart';
import 'package:majadigi_superapp_frontend/models/darurat_model.dart';
import 'package:majadigi_superapp_frontend/screens/emergency_numbers_screen.dart';
import 'package:majadigi_superapp_frontend/screens/emergency_contact_list_screen.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:majadigi_superapp_frontend/models/service_module.dart';

class MockModuleProvider extends ChangeNotifier implements ModuleProvider {
  final List<String> _favorites = [];

  @override
  List<String> get installedModuleIds => [];
  @override
  List<String> get favoriteModuleIds => _favorites;
  @override
  List<ServiceModule> get availableModules => [];
  @override
  List<ServiceModule> get installedModules => [];
  @override
  List<ServiceModule> get favoriteModules => [];
  @override
  Future<void> installModule(String id) async {}
  @override
  Future<void> uninstallModule(String id) async {}
  @override
  Future<void> setInitialModulesFromOnboarding(List<String> moduleIds) async {}
  @override
  bool isInstalled(String id) => false;
  
  @override
  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  @override
  bool isFavorite(String id) => _favorites.contains(id);

  @override
  Future<void> reload() async {}
}

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

class MockDaruratProvider extends DaruratProvider {
  List<EmergencyAgency> _mockAgencies = [];
  List<PanicReport> _mockReports = [];
  bool _mockLoading = false;

  @override
  List<EmergencyAgency> get agencies => _mockAgencies;

  @override
  List<PanicReport> get reports => _mockReports;

  @override
  bool get isLoading => _mockLoading;

  void setMockAgencies(List<EmergencyAgency> agencies) {
    _mockAgencies = agencies;
    notifyListeners();
  }

  void setMockReports(List<PanicReport> reports) {
    _mockReports = reports;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _mockLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> fetchAgencies() async {
    // No-op
  }

  @override
  Future<void> fetchPanicReports() async {
    // No-op
  }

  @override
  Future<PanicReport?> triggerPanicButton(String category, String number, String gpsCoords) async {
    final report = PanicReport(
      id: 'report-mock',
      category: category,
      number: number,
      gpsCoords: gpsCoords,
      timestamp: 'Baru Saja',
      status: 'Diterima',
    );
    _mockReports.insert(0, report);
    notifyListeners();
    return report;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Mock permission_handler channel
    const MethodChannel('flutter.baseflow.com/permissions/methods')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'checkPermissionStatus') {
        return 1; // granted
      } else if (methodCall.method == 'requestPermissions') {
        final List<dynamic> permissions = methodCall.arguments;
        final map = <int, int>{};
        for (final p in permissions) {
          map[p as int] = 1; // granted
        }
        return map;
      }
      return null;
    });

    // Mock geolocator channel
    const MethodChannel('flutter.baseflow.com/geolocator')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getCurrentPosition') {
        return {
          'latitude': -7.25,
          'longitude': 112.75,
          'timestamp': 0,
          'accuracy': 1.0,
          'altitude': 0.0,
          'heading': 0.0,
          'speed': 0.0,
          'speed_accuracy': 0.0,
          'is_mocked': true,
        };
      }
      return null;
    });
  });

  testWidgets('EmergencyContactListScreen displays dynamic agencies', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockDaruratProvider();

      mockProvider.setMockAgencies([
        EmergencyAgency(
          id: 'agency-1',
          title: 'Polrestabes Surabaya',
          subtitle: 'Kepolisian Wilayah Kota Surabaya',
          number: '031-110',
          distance: '0.8 km',
        ),
        EmergencyAgency(
          id: 'agency-2',
          title: 'PMI Surabaya',
          subtitle: 'Palang Merah Indonesia',
          number: '031-119',
          distance: '1.5 km',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<DaruratProvider>.value(
            value: mockProvider,
            child: const EmergencyContactListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Polrestabes Surabaya'), findsOneWidget);
      expect(find.text('Kepolisian Wilayah Kota Surabaya (0.8 km)'), findsOneWidget);

      expect(find.text('PMI Surabaya'), findsOneWidget);
      expect(find.text('Palang Merah Indonesia (1.5 km)'), findsOneWidget);
    }, MockHttpOverrides());
  });

  testWidgets('EmergencyNumbersScreen triggers SOS panic report and shows success dialog', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(800, 1200);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockDaruratProvider();

      mockProvider.setMockReports([
        PanicReport(
          id: 'report-old',
          category: 'Damkar',
          number: '113',
          gpsCoords: '-7.25, 112.75',
          timestamp: 'Kemarin',
          status: 'Selesai',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DaruratProvider>.value(value: mockProvider),
              ChangeNotifierProvider<ModuleProvider>.value(value: MockModuleProvider()),
            ],
            child: const EmergencyNumbersScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      // Check existing report history
      expect(find.text('Damkar'), findsOneWidget);
      expect(find.text('-7.25, 112.75'), findsOneWidget);
      expect(find.text('Selesai'), findsOneWidget);

      // Tap SOS button to trigger category picker
      await tester.tap(find.text('SOS'));
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Category bottom sheet should appear
      expect(find.text('Pilih Kategori Bantuan'), findsOneWidget);
      expect(find.text('112 Pusat'), findsOneWidget);
      expect(find.text('Polisi'), findsOneWidget);

      // Tap 'Polisi'
      await tester.tap(find.text('Polisi'));
      await tester.pump(const Duration(milliseconds: 100)); // Start async call

      // Pump to let the state set _isSendingSos = false and show the dialog
      for (int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Check success dialog
      expect(find.text('Sinyal SOS Terkirim!'), findsOneWidget);
      expect(find.text('Tutup'), findsOneWidget);

      // Tap Close button
      await tester.tap(find.text('Tutup'));
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Verification that the new report history is displayed
      expect(find.text('Polisi'), findsOneWidget);
      expect(find.text('Diterima'), findsOneWidget);
    }, MockHttpOverrides());
  });
}
