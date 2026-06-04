import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/wisata_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class WisataRepository {
  final Dio _dio = DioClient.instance;

  // Static list for local simulation and fallback data
  static final List<TourismTicket> _localTickets = [
    TourismTicket(
      id: 'ticket-1',
      destinationTitle: 'Gunung Bromo',
      location: 'Probolinggo',
      date: '6 Apr',
      time: '09:00',
      guests: '1 orang',
      price: 'Rp 35.000',
      status: 'Hari Ini',
    ),
    TourismTicket(
      id: 'ticket-2',
      destinationTitle: 'Pantai Tiga Warna',
      location: 'Malang',
      date: '8 Apr',
      time: '10:30',
      guests: '2 orang',
      price: 'Rp 50.000',
      status: 'Mendatang',
    ),
    TourismTicket(
      id: 'ticket-3',
      destinationTitle: 'Kawah Ijen',
      location: 'Banyuwangi',
      date: '12 Apr',
      time: '02:00',
      guests: '1 orang',
      price: 'Rp 25.000',
      status: 'Mendatang',
    ),
  ];

  Future<List<Destination>> getDestinations() async {
    try {
      final response = await _dio.get('/wisata');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => Destination.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal memuat destinasi wisata');
      }
    } catch (e) {
      print('API ERROR getDestinations: $e');
      // High-fidelity fallback list
      return [
        Destination(
          id: '1',
          title: 'Gunung Bromo',
          description: 'Gunung berapi aktif dengan pemandangan sunrise spektakuler dan lautan pasir yang menakjubkan.',
          imageUrl: 'https://images.unsplash.com/photo-1536704689578-8eff5322b70b?q=80&w=1000&auto=format&fit=crop',
          duration: '4-5 jam',
          openHours: '03:00 - 17:00 WIB',
          route: 'Koridor Probolinggo • Terminal Probolinggo',
          distance: '15 km',
          price: 'Rp 35.000',
          category: 'Alam',
        ),
        Destination(
          id: '2',
          title: 'Pantai Tiga Warna',
          description: 'Pantai indah dengan gradasi tiga warna air laut yang menawan, area konservasi mangrove dan terumbu karang.',
          imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000&auto=format&fit=crop',
          duration: '3-4 jam',
          openHours: '07:00 - 16:00 WIB',
          route: 'Koridor Malang • Dampit',
          distance: '30 km',
          price: 'Rp 50.000',
          category: 'Pantai',
        ),
        Destination(
          id: '3',
          title: 'Kawah Ijen',
          description: 'Kawah asam dengan fenomena api biru (Blue Fire) legendaris yang hanya ada dua di dunia.',
          imageUrl: 'https://images.unsplash.com/photo-1588666309990-d68f08e3d4a6?q=80&w=1000&auto=format&fit=crop',
          duration: '5-6 jam',
          openHours: '01:00 - 12:00 WIB',
          route: 'Koridor Banyuwangi • Licin',
          distance: '22 km',
          price: 'Rp 25.000',
          category: 'Alam',
        ),
        Destination(
          id: '4',
          title: 'Jatim Park 3',
          description: 'Taman belajar dan rekreasi keluarga dengan tema dinosaurus megah dan wahana teknologi interaktif.',
          imageUrl: 'https://images.unsplash.com/photo-1572111504031-628bf16f6b0f?auto=format&fit=crop&q=80&w=800',
          duration: '6-8 jam',
          openHours: '11:00 - 20:00 WIB',
          route: 'Koridor Batu • Terminal Batu',
          distance: '8 km',
          price: 'Rp 100.000',
          category: 'Keluarga',
        ),
      ];
    }
  }

  Future<bool> buyTicket(String destinationId, int quantity, String date, String time) async {
    try {
      final response = await _dio.post('/wisata/$destinationId/beli-tiket', data: {
        'quantity': quantity,
        'date': date,
        'time': time,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final destinations = await getDestinations();
        final dest = destinations.firstWhere((d) => d.id == destinationId);
        _addLocalTicket(dest, quantity, date, time);
        return true;
      } else {
        throw Exception('Gagal melakukan pembelian tiket');
      }
    } catch (e) {
      print('API ERROR buyTicket: $e');
      // Mock Fallback implementation
      try {
        final destinations = await getDestinations();
        final dest = destinations.firstWhere((d) => d.id == destinationId);
        _addLocalTicket(dest, quantity, date, time);
      } catch (_) {
        // Fallback-fallback
        _localTickets.insert(
          0,
          TourismTicket(
            id: 'ticket-${DateTime.now().millisecondsSinceEpoch}',
            destinationTitle: 'Destinasi Wisata',
            location: 'Jawa Timur',
            date: date,
            time: time,
            guests: '$quantity orang',
            price: 'Rp ${(25000 * quantity).toString()}',
            status: 'Mendatang',
          ),
        );
      }
      return true;
    }
  }

  void _addLocalTicket(Destination dest, int qty, String date, String time) {
    // Parse price
    final cleanedPrice = dest.price.replaceAll('Rp', '').replaceAll('.', '').replaceAll(' ', '').trim();
    final numericPrice = int.tryParse(cleanedPrice) ?? 35000;
    final totalVal = numericPrice * qty;
    
    // Format price
    final formattedPrice = 'Rp ${_formatRupiah(totalVal)}';

    _localTickets.insert(
      0,
      TourismTicket(
        id: 'ticket-${DateTime.now().millisecondsSinceEpoch}',
        destinationTitle: dest.title,
        location: dest.route.split('•').first.replaceAll('Koridor', '').trim(),
        date: date,
        time: time,
        guests: '$qty orang',
        price: formattedPrice,
        status: 'Mendatang',
      ),
    );
  }

  String _formatRupiah(int val) {
    final str = val.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }

  Future<List<TourismTicket>> getTickets() async {
    try {
      final response = await _dio.get('/wisata/tiket-saya');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => TourismTicket.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal memuat tiket saya');
      }
    } catch (e) {
      print('API ERROR getTickets: $e');
      return _localTickets;
    }
  }
}
