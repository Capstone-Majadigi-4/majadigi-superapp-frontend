import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/wisata_provider.dart';
import 'package:majadigi_superapp_frontend/models/wisata_model.dart';
import 'package:majadigi_superapp_frontend/screens/tourism_main_flow_screen.dart';
import 'package:majadigi_superapp_frontend/screens/my_itinerary_screen.dart';

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

class MockWisataProvider extends WisataProvider {
  List<Destination> _mockDestinations = [];
  List<TourismTicket> _mockTickets = [];
  bool _mockLoading = false;

  @override
  List<Destination> get destinations => _mockDestinations;

  @override
  List<TourismTicket> get tickets => _mockTickets;

  @override
  bool get isLoading => _mockLoading;

  void setMockDestinations(List<Destination> destinations) {
    _mockDestinations = destinations;
    notifyListeners();
  }

  void setMockTickets(List<TourismTicket> tickets) {
    _mockTickets = tickets;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _mockLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> fetchDestinations() async {
    // No-op
  }

  @override
  Future<void> fetchTickets() async {
    // No-op
  }

  @override
  Future<bool> buyTicket(String destinationId, int quantity, String date, String time) async {
    return true;
  }
}

void main() {
  testWidgets('TourismMainFlowScreen displays category tabs and destinations', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockWisataProvider();

      mockProvider.setMockDestinations([
        Destination(
          id: 'dest-1',
          title: 'Hutan Bambu Keputih',
          description: 'Hutan bambu yang rindang di Surabaya',
          imageUrl: 'https://example.com/hutan.jpg',
          duration: '1-2 jam',
          openHours: '08:00 - 17:00',
          route: 'Naik TransJatim Koridor 1',
          distance: '2.5 km',
          price: 'Gratis',
          category: 'Alam',
        ),
        Destination(
          id: 'dest-2',
          title: 'Pantai Kenjeran Lama',
          description: 'Pantai legendaris di Surabaya',
          imageUrl: 'https://example.com/pantai.jpg',
          duration: '2-3 jam',
          openHours: '06:00 - 18:00',
          route: 'Naik TransJatim Koridor 2',
          distance: '5.0 km',
          price: 'Rp 10.000',
          category: 'Pantai',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WisataProvider>.value(
            value: mockProvider,
            child: const TourismMainFlowScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check category tabs
      expect(find.text('Semua'), findsWidgets);
      expect(find.text('Alam'), findsWidgets);
      expect(find.text('Pantai'), findsWidgets);
      expect(find.text('Keluarga'), findsWidgets);

      // Check destinations are displayed
      expect(find.text('Hutan Bambu Keputih'), findsOneWidget);
      expect(find.text('Pantai Kenjeran Lama'), findsOneWidget);

      // Tap on a category tab (e.g. Pantai)
      await tester.tap(find.text('Pantai').first);
      await tester.pumpAndSettle();

      // After filtering, only Pantai Kenjeran Lama should be displayed
      expect(find.text('Pantai Kenjeran Lama'), findsOneWidget);
    }, MockHttpOverrides());
  });

  testWidgets('MyItineraryScreen displays list of purchased tickets', (WidgetTester tester) async {
    await HttpOverrides.runWithHttpOverrides(() async {
      final mockProvider = MockWisataProvider();

      mockProvider.setMockTickets([
        TourismTicket(
          id: 'ticket-1',
          destinationTitle: 'Hutan Bambu Keputih',
          location: 'Surabaya Timur',
          date: 'Minggu, 24 Mei 2026',
          time: '09:00 WIB',
          guests: '2 orang',
          price: 'Gratis',
          status: 'Hari Ini',
        ),
        TourismTicket(
          id: 'ticket-2',
          destinationTitle: 'Pantai Kenjeran Lama',
          location: 'Kenjeran, Surabaya',
          date: 'Senin, 25 Mei 2026',
          time: '13:00 WIB',
          guests: '1 orang',
          price: 'Rp 10.000',
          status: 'Mendatang',
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WisataProvider>.value(
            value: mockProvider,
            child: const MyItineraryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check count in header
      expect(find.text('2 rencana perjalanan'), findsOneWidget);

      // Check ticket details
      expect(find.text('Hutan Bambu Keputih'), findsOneWidget);
      expect(find.text('Surabaya Timur'), findsOneWidget);
      expect(find.text('Hari Ini'), findsOneWidget);

      expect(find.text('Pantai Kenjeran Lama'), findsOneWidget);
      expect(find.text('Kenjeran, Surabaya'), findsOneWidget);
      expect(find.text('Mendatang'), findsOneWidget);
    }, MockHttpOverrides());
  });
}
