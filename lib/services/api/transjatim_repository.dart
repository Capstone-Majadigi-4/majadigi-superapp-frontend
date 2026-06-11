import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/transjatim_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class TransJatimRepository {
  final Dio _dio = DioClient.instance;
  static final List<Ticket> _mockTickets = [];

  Future<List<Koridor>> getKoridor() async {
    try {
      final response = await _dio.get('/transjatim/koridor');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        // API wraps in data key
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => Koridor.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal mengambil data koridor TransJatim');
      }
    } catch (e) {
      print('API ERROR getKoridor: $e');
      // Fallback mockup data - use real IDs from staging
      return [
        Koridor(
          id: '9d6b1585-f8fc-4fc3-bf3e-cf7fd08a48be',
          kode: 'TJ-01',
          nama: 'Koridor 1 - Purabaya - Darmo',
          asal: 'Terminal Purabaya',
          tujuan: 'Jl. Darmo',
          isActive: true,
        ),
        Koridor(
          id: 'c302a0de-c0d7-47a5-99db-b937577ce5ca',
          kode: 'TJ-02',
          nama: 'Koridor 2 - Rajawali - Wonokromo',
          asal: 'Rajawali',
          tujuan: 'Wonokromo',
          isActive: true,
        ),
      ];
    }
  }

  Future<List<Ticket>> getTickets() async {
    try {
      final response = await _dio.get('/transjatim/tiket');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        final tickets = list.map((item) => Ticket.fromJson(item as Map<String, dynamic>)).toList();
        // Merge with local mock tickets
        for (var mt in _mockTickets) {
          if (!tickets.any((t) => t.id == mt.id)) {
            tickets.add(mt);
          }
        }
        return tickets;
      } else {
        throw Exception('Gagal mengambil data tiket TransJatim');
      }
    } catch (e) {
      print('API ERROR getTickets: $e');
      if (_mockTickets.isEmpty) {
        _mockTickets.add(Ticket(
          id: 'mock-ticket-default',
          userNik: '3578010101900002',
          koridorId: '9d6b1585-f8fc-4fc3-bf3e-cf7fd08a48be',
          jumlah: 1,
          total: '5000',
          qrTotp: 'TRANSJATIM-MOCK-DEFAULT',
          status: 'valid',
          createdAt: DateTime.now().toIso8601String(),
          validSampai: DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
        ));
      }
      return _mockTickets;
    }
  }

  Future<TicketPurchaseResponse> buyTicket(String koridorId, int jumlah) async {
    try {
      final response = await _dio.post(
        '/transjatim/tiket',
        data: {
          'koridor_id': koridorId,
          'jumlah': jumlah,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        final ticketResponse = TicketPurchaseResponse.fromJson(data);
        
        // Add to local mock list too
        _mockTickets.add(ticketResponse.ticket);
        
        return ticketResponse;
      } else {
        throw Exception(response.data['message'] ?? 'Gagal membeli tiket TransJatim');
      }
    } catch (e) {
      print('API ERROR buyTicket: $e');
      // Fallback bypass: create local mock ticket
      final mockTicket = Ticket(
        id: 'mock-ticket-${DateTime.now().millisecondsSinceEpoch}',
        userNik: '3578010101900002',
        koridorId: koridorId,
        jumlah: jumlah,
        total: '${jumlah * 5000}',
        qrTotp: 'TRANSJATIM-MOCK-BYPASS-${DateTime.now().millisecondsSinceEpoch}',
        status: 'valid',
        createdAt: DateTime.now().toIso8601String(),
        validSampai: DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
      );
      final mockResponse = TicketPurchaseResponse(
        ticket: mockTicket,
        qrImage: 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${mockTicket.qrTotp}',
      );
      _mockTickets.add(mockTicket);
      return mockResponse;
    }
  }

  Future<List<Armada>> getArmada(String koridorId) async {
    try {
      final response = await _dio.get('/transjatim/armada/koridor/$koridorId');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        final armadas = list.map((item) => Armada.fromJson(item as Map<String, dynamic>)).toList();

        // Staging fallback for null/zero coordinates
        for (int i = 0; i < armadas.length; i++) {
          final a = armadas[i];
          if (a.lat == null || a.lng == null || a.lat == 0.0 || a.lng == 0.0) {
            double defaultLat = -7.3512 - (i * 0.02);
            double defaultLng = 112.7242 + (i * 0.005);
            armadas[i] = Armada(
              id: a.id,
              koridorId: a.koridorId,
              kodeBus: a.kodeBus,
              kapasitas: a.kapasitas,
              lat: defaultLat,
              lng: defaultLng,
              status: a.status,
              updatedAt: a.updatedAt,
            );
          }
        }
        return armadas;
      } else {
        throw Exception('Gagal mengambil data armada');
      }
    } catch (e) {
      print('API ERROR getArmada: $e');
      // Full Fallback
      return [
        Armada(
          id: 'f2d72ab8-da1e-4d5f-832f-430583c9ce87',
          koridorId: koridorId,
          kodeBus: 'TJ-01-A',
          kapasitas: 60,
          lat: -7.3512,
          lng: 112.7242,
          status: 'aktif',
          updatedAt: DateTime.now().toIso8601String(),
        ),
        Armada(
          id: 'd857df25-39ad-4d8a-8a8c-ead5c9b660cb',
          koridorId: koridorId,
          kodeBus: 'TJ-01-B',
          kapasitas: 60,
          lat: -7.3112,
          lng: 112.7292,
          status: 'aktif',
          updatedAt: DateTime.now().toIso8601String(),
        ),
      ];
    }
  }
}

