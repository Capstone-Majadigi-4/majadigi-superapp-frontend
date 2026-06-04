import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/sinaker_provider.dart';
import 'package:majadigi_superapp_frontend/models/sinaker_model.dart';
import 'package:majadigi_superapp_frontend/screens/sinaker_jobs_screen.dart';

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

class MockSinakerProvider extends SinakerProvider {
  List<JobVacancy> _mockVacancies = [];
  List<JobApplication> _mockApplications = [];
  bool _mockLoading = false;

  @override
  List<JobVacancy> get vacancies => _mockVacancies;

  @override
  List<JobApplication> get applications => _mockApplications;

  @override
  bool get isLoading => _mockLoading;

  void setMockVacancies(List<JobVacancy> vacancies) {
    _mockVacancies = vacancies;
    notifyListeners();
  }

  void setMockApplications(List<JobApplication> applications) {
    _mockApplications = applications;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _mockLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> fetchVacancies() async {
    // No-op
  }

  @override
  Future<void> fetchApplications() async {
    // No-op
  }

  @override
  Future<bool> applyJob(String id) async {
    return true;
  }
}

void main() {
  testWidgets('SinakerJobsScreen displays list of jobs and applications', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockSinakerProvider();
      
      mockProvider.setMockApplications([
        JobApplication(
          id: 'app-1',
          title: 'QA Engineer',
          company: 'PT Quality Tech',
          date: '10 Mei 2026',
          status: 'Sedang Direview',
        ),
      ]);

      mockProvider.setMockVacancies([
        JobVacancy(
          id: 'vacancy-1',
          title: 'Frontend Engineer',
          company: 'PT Global Tech',
          location: 'Surabaya',
          salary: 'Rp 7.000.000',
          type: 'Full Time',
          posted: '1 hari lalu',
          match: '90%',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SinakerProvider>.value(
            value: mockProvider,
            child: const SinakerJobsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check applied job
      expect(find.text('QA Engineer'), findsOneWidget);
      expect(find.text('PT Quality Tech'), findsOneWidget);
      expect(find.text('Dilamar: 10 Mei 2026'), findsOneWidget);

      // Check recommendation vacancy
      expect(find.text('Frontend Engineer'), findsOneWidget);
      expect(find.text('PT Global Tech'), findsOneWidget);
      expect(find.text('Match 90%'), findsOneWidget);
    }, MockHttpOverrides());
  });

  testWidgets('SinakerJobsScreen search filters job recommendations', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockSinakerProvider();

      mockProvider.setMockVacancies([
        JobVacancy(
          id: 'v-1',
          title: 'Flutter Developer',
          company: 'PT Flutter Ind',
          location: 'Surabaya',
          salary: 'Rp 10.000.000',
          type: 'Full Time',
          posted: '1 hari lalu',
          match: '95%',
        ),
        JobVacancy(
          id: 'v-2',
          title: 'Python Engineer',
          company: 'PT Python Tech',
          location: 'Malang',
          salary: 'Rp 9.000.000',
          type: 'Full Time',
          posted: '2 hari lalu',
          match: '80%',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SinakerProvider>.value(
            value: mockProvider,
            child: const SinakerJobsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially both are displayed
      expect(find.text('Flutter Developer'), findsOneWidget);
      expect(find.text('Python Engineer'), findsOneWidget);

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.pumpAndSettle();

      // After search, Python Developer should be filtered out
      expect(find.text('Flutter Developer'), findsOneWidget);
      expect(find.text('Python Engineer'), findsNothing);
    }, MockHttpOverrides());
  });
}
