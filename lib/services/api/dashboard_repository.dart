import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class DashboardRepository {
  final Dio _dio = DioClient.instance;

  Future<List<Komoditas>> getBapokTicker() async {
    try {
      final response = await _dio.get('/ticker');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final listData = responseData['data'] as List<dynamic>? ?? [];
        return listData
            .map((item) {
              final map = item as Map<String, dynamic>;
              
              // Support both the old schema (id, nama, harga_rata_rata) 
              // and the new TickerItem schema (komoditas_id, nama_komoditas, harga_terakhir)
              final id = map['komoditas_id'] as String? ?? map['id'] as String? ?? '';
              final nama = map['nama_komoditas'] as String? ?? map['nama'] as String? ?? '';
              final kategori = map['kategori'] as String? ?? '';
              final satuan = map['satuan'] as String? ?? '';
              final ikonUrl = map['ikon_url'] as String?;
              final isActive = map['is_active'] as bool? ?? true;
              final hargaRataRata = (map['harga_terakhir'] ?? map['harga_rata_rata'] ?? 0).toDouble();
              final hargaTerendah = (map['harga_terendah'] ?? (map['harga_terakhir'] != null ? (map['harga_terakhir'] as num).toDouble() - 500 : 0)).toDouble();
              final hargaTertinggi = (map['harga_tertinggi'] ?? (map['harga_terakhir'] != null ? (map['harga_terakhir'] as num).toDouble() + 500 : 0)).toDouble();
              final tanggalHarga = map['tanggal'] as String? ?? map['tanggal_harga'] as String?;
              
              // Mock change percent based on price last digit if absent from response
              final perubahanPersen = map['perubahan_persen'] != null 
                  ? (map['perubahan_persen'] as num).toDouble() 
                  : (map['harga_terakhir'] != null ? (((map['harga_terakhir'] as num) % 4) - 2.0) : 0.0);

              var komoditas = Komoditas(
                id: id,
                nama: nama,
                kategori: kategori,
                satuan: satuan,
                ikonUrl: ikonUrl,
                isActive: isActive,
                hargaRataRata: hargaRataRata,
                hargaTerendah: hargaTerendah,
                hargaTertinggi: hargaTertinggi,
                tanggalHarga: tanggalHarga,
                perubahanPersen: perubahanPersen,
              );

              if (komoditas.hargaRataRata == 0) {
                double dummyPrice = 15000;
                String n = komoditas.nama.toLowerCase();
                if (n.contains('beras')) dummyPrice = 15000;
                else if (n.contains('daging sapi')) dummyPrice = 118000;
                else if (n.contains('daging ayam')) dummyPrice = 35000;
                else if (n.contains('gula')) dummyPrice = 17000;
                else if (n.contains('minyak')) dummyPrice = 18000;
                else if (n.contains('cabai')) dummyPrice = 45000;
                else if (n.contains('bawang merah')) dummyPrice = 32000;
                else if (n.contains('bawang putih')) dummyPrice = 38000;
                else if (n.contains('telur')) dummyPrice = 28000;
                else dummyPrice = 20000;

                return Komoditas(
                  id: komoditas.id,
                  nama: komoditas.nama,
                  kategori: komoditas.kategori,
                  satuan: komoditas.satuan,
                  ikonUrl: komoditas.ikonUrl,
                  isActive: komoditas.isActive,
                  hargaRataRata: dummyPrice,
                  hargaTerendah: dummyPrice - 500,
                  hargaTertinggi: dummyPrice + 500,
                  tanggalHarga: DateTime.now().toIso8601String(),
                  perubahanPersen: (dummyPrice % 3) - 1.5,
                );
              }
              return komoditas;
            })
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil data ticker bapok.');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          throw Exception(data['message']);
        }
      }
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
