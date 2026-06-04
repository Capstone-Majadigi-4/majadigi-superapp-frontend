import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/etibi_provider.dart';
import 'package:majadigi_superapp_frontend/models/etibi_model.dart';
import 'package:majadigi_superapp_frontend/screens/tbc_screening_screen.dart';
import 'package:majadigi_superapp_frontend/screens/tbc_questions_screen.dart';
import 'package:majadigi_superapp_frontend/screens/tbc_reminder_screen.dart';

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

class MockEtibiProvider extends EtibiProvider {
  List<ScreeningQuestion> _mockQuestions = [];
  bool? _mockLastScreeningResult;
  MedicationAdherenceStatus? _mockAdherenceStatus;
  List<MedicationCalendarEntry> _mockCalendarEntries = [];
  bool _mockLoading = false;

  @override
  List<ScreeningQuestion> get questions => _mockQuestions;

  @override
  bool? get lastScreeningResult => _mockLastScreeningResult;

  @override
  MedicationAdherenceStatus? get adherenceStatus => _mockAdherenceStatus;

  @override
  List<MedicationCalendarEntry> get calendarEntries => _mockCalendarEntries;

  @override
  bool get isLoading => _mockLoading;

  void setMockQuestions(List<ScreeningQuestion> questions) {
    _mockQuestions = questions;
    notifyListeners();
  }

  void setMockLastScreeningResult(bool? result) {
    _mockLastScreeningResult = result;
    notifyListeners();
  }

  void setMockAdherenceStatus(MedicationAdherenceStatus status) {
    _mockAdherenceStatus = status;
    notifyListeners();
  }

  void setMockCalendarEntries(List<MedicationCalendarEntry> entries) {
    _mockCalendarEntries = entries;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _mockLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> fetchQuestions() async {
    // No-op
  }

  @override
  Future<bool?> fetchLastScreeningResult() async {
    return _mockLastScreeningResult;
  }

  @override
  Future<bool> submitScreening(Map<int, bool> answers) async {
    final result = answers.values.any((v) => v == true);
    _mockLastScreeningResult = result;
    notifyListeners();
    return result;
  }

  @override
  Future<void> fetchAdherenceStatus() async {
    // No-op
  }

  @override
  Future<void> fetchCalendarEntries() async {
    // No-op
  }

  @override
  Future<bool> confirmMedicationIntake() async {
    _mockCalendarEntries.insert(0, MedicationCalendarEntry(date: 'Hari Ini', status: 'Sudah', isDone: true));
    if (_mockAdherenceStatus != null) {
      _mockAdherenceStatus = MedicationAdherenceStatus(
        adherencePercentage: 100,
        currentProgress: '76/180 hari',
        startDate: _mockAdherenceStatus!.startDate,
        dailyReminderTime: _mockAdherenceStatus!.dailyReminderTime,
        isReminderEnabled: _mockAdherenceStatus!.isReminderEnabled,
      );
    }
    notifyListeners();
    return true;
  }

  @override
  Future<void> toggleReminder(bool isEnabled) async {
    if (_mockAdherenceStatus != null) {
      _mockAdherenceStatus = MedicationAdherenceStatus(
        adherencePercentage: _mockAdherenceStatus!.adherencePercentage,
        currentProgress: _mockAdherenceStatus!.currentProgress,
        startDate: _mockAdherenceStatus!.startDate,
        dailyReminderTime: _mockAdherenceStatus!.dailyReminderTime,
        isReminderEnabled: isEnabled,
      );
    }
    notifyListeners();
  }

  @override
  Future<void> updateReminderTime(String time) async {
    if (_mockAdherenceStatus != null) {
      _mockAdherenceStatus = MedicationAdherenceStatus(
        adherencePercentage: _mockAdherenceStatus!.adherencePercentage,
        currentProgress: _mockAdherenceStatus!.currentProgress,
        startDate: _mockAdherenceStatus!.startDate,
        dailyReminderTime: time,
        isReminderEnabled: _mockAdherenceStatus!.isReminderEnabled,
      );
    }
    notifyListeners();
  }
}

void main() {
  testWidgets('TbcScreeningScreen displays result card and buttons correctly', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockEtibiProvider();
      mockProvider.setMockLastScreeningResult(true); // high risk

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<EtibiProvider>.value(
            value: mockProvider,
            child: const TbcScreeningScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check dynamic risk card
      expect(find.text('Hasil Skrining: Berisiko TBC'), findsOneWidget);
      expect(find.text('Mulai Skrining Mandiri'), findsOneWidget);
      expect(find.text('Kalender & Pengingat Obat'), findsOneWidget);

      // Check change in result
      mockProvider.setMockLastScreeningResult(false); // low risk
      await tester.pumpAndSettle();
      expect(find.text('Hasil Skrining: Risiko Rendah'), findsOneWidget);
    }, MockHttpOverrides());
  });

  testWidgets('TbcQuestionsScreen renders dynamic screening questions and submits answers', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockEtibiProvider();
      mockProvider.setMockQuestions([
        ScreeningQuestion(id: 1, text: 'Batuk berdarah', category: 'keluhan'),
        ScreeningQuestion(id: 2, text: 'Pernah kontak dengan pasien TB', category: 'info_lainnya'),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<EtibiProvider>.value(
            value: mockProvider,
            child: const TbcQuestionsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check categories and questions are rendered
      expect(find.text('Keluhan yang dirasakan'), findsOneWidget);
      expect(find.text('Batuk berdarah'), findsOneWidget);
      expect(find.text('Informasi Lainnya'), findsOneWidget);
      expect(find.text('Pernah kontak dengan pasien TB'), findsOneWidget);

      // Tap Yes on the first question
      // In TbcQuestionCard, there are likely "Iya" and "Tidak" buttons
      expect(find.text('Iya'), findsNWidgets(2));
      await tester.tap(find.text('Iya').first);
      await tester.pumpAndSettle();

      // Tap 'Lihat Hasil' button to submit
      await tester.tap(find.text('Lihat Hasil'));
      await tester.pumpAndSettle();

      // Verify result dialog displays risk result since we chose 'Iya'
      expect(find.text('Hasil Skrining'), findsOneWidget);
    }, MockHttpOverrides());
  });

  testWidgets('TbcReminderScreen shows adherence stats and updates daily log', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockEtibiProvider();
      mockProvider.setMockAdherenceStatus(MedicationAdherenceStatus(
        adherencePercentage: 90,
        currentProgress: '75/180 hari',
        startDate: '10 Januari 2025',
        dailyReminderTime: '07:30',
        isReminderEnabled: true,
      ));
      mockProvider.setMockCalendarEntries([
        MedicationCalendarEntry(date: 'Kemarin', status: 'Sudah', isDone: true),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<EtibiProvider>.value(
            value: mockProvider,
            child: const TbcReminderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check stats cards
      expect(find.text('90%'), findsOneWidget);
      expect(find.text('75/180 hari'), findsOneWidget);
      expect(find.text('10 Januari 2025'), findsOneWidget);

      // Check reminder settings
      expect(find.text('Setiap hari pukul 07:30'), findsOneWidget);

      // Check history logs
      expect(find.text('Kemarin'), findsOneWidget);

      // Confirm pill intake
      await tester.tap(find.text('Sudah Minum Obat Hari Ini'));
      await tester.pumpAndSettle();

      // Check updated stats
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('76/180 hari'), findsOneWidget);
      expect(find.text('Hari Ini'), findsOneWidget);
    }, MockHttpOverrides());
  });
}
