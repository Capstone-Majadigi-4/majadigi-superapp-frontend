import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bansos_provider.dart';
import 'package:majadigi_superapp_frontend/models/bansos_model.dart';
import 'package:majadigi_superapp_frontend/screens/sapabansos_status_screen.dart';
import 'package:majadigi_superapp_frontend/screens/sapabansos_info_program_screen.dart';

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

class MockBansosProvider extends BansosProvider {
  BansosStatus? _mockStatus;
  List<BansosProgramInfo> _mockPrograms = [];
  bool _mockLoading = false;

  @override
  BansosStatus? get bansosStatus => _mockStatus;

  @override
  List<BansosProgramInfo> get programs => _mockPrograms;

  @override
  bool get isLoading => _mockLoading;

  void setMockStatus(BansosStatus status) {
    _mockStatus = status;
    notifyListeners();
  }

  void setMockPrograms(List<BansosProgramInfo> programs) {
    _mockPrograms = programs;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _mockLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> fetchBansosStatus() async {
    // No-op to avoid actual API call
  }

  @override
  Future<void> fetchBansosPrograms() async {
    // No-op to avoid actual API call
  }
}

void main() {
  testWidgets('SapabansosStatusScreen displays eligible status and programs', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockBansosProvider();
      mockProvider.setMockStatus(BansosStatus(
        isEligible: true,
        statusText: 'Terdaftar',
        description: 'Anda terdaftar sebagai penerima bantuan sosial',
        programs: [
          BansosProgram(
            title: 'PKH Mock',
            status: 'Aktif',
            nominal: 'Rp 1.000.000',
            distributionDate: '12 Des 2026',
          ),
        ],
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BansosProvider>.value(
            value: mockProvider,
            child: const SapabansosStatusScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Status: Terdaftar'), findsOneWidget);
      expect(find.text('Anda terdaftar sebagai penerima bantuan sosial'), findsOneWidget);
      expect(find.text('PKH Mock'), findsOneWidget);
      expect(find.text('Rp 1.000.000'), findsOneWidget);
    }, MockHttpOverrides());
  });

  testWidgets('SapabansosInfoProgramScreen displays list of program info', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockBansosProvider();
      mockProvider.setMockPrograms([
        BansosProgramInfo(
          title: 'Program Info Mock',
          description: 'Description of mock program',
          totalFunds: 'Rp 50.000.000',
          quota: '100 penerima',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<BansosProvider>.value(
            value: mockProvider,
            child: const SapabansosInfoProgramScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Program Info Mock'), findsOneWidget);
      expect(find.text('Description of mock program'), findsOneWidget);
      expect(find.text('Rp 50.000.000'), findsOneWidget);
      expect(find.text('100 penerima'), findsOneWidget);
    }, MockHttpOverrides());
  });
}
