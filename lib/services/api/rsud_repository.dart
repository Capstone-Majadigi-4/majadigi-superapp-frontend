import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/rsud_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class RsudRepository {
  final Dio _dio = DioClient.instance;

  Future<List<Poliklinik>> getPoliklinik() async {
    try {
      final response = await _dio.get('/rsud/poli');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => Poliklinik.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal mengambil data poliklinik');
      }
    } catch (e) {
      print('API ERROR getPoliklinik: $e');
      return [
        Poliklinik(
          id: '3bb1b554-a5a1-7d08-7c12-5e1d58984de5',
          nama: 'Poli Umum',
          lantai: 'Lantai 1',
          isActive: true,
          kuotaTersisa: 18,
          daftarDokter: [
            Dokter(id: '1', nama: 'dr. Andi Wijaya, Sp.U', spesialis: 'Spesialis Penyakit Dalam', jamMulai: '08:00', jamSelesai: '12:00', kuotaPerHari: 18, jadwal: ['senin','rabu','jumat']),
            Dokter(id: '2', nama: 'dr. Siti Rahma, Sp.PD', spesialis: 'Dokter Umum Senior', jamMulai: '08:00', jamSelesai: '12:00', kuotaPerHari: 15, jadwal: ['selasa','kamis']),
          ],
        ),
        Poliklinik(
          id: '6cab51a0-a519-f377-a089-7a67b575492c',
          nama: 'Poli Anak',
          lantai: 'Lantai 1',
          isActive: true,
          kuotaTersisa: 12,
          daftarDokter: [
            Dokter(id: '3', nama: 'dr. Sarah Sp.A', spesialis: 'Kesehatan Anak', jamMulai: '08:00', jamSelesai: '12:00', kuotaPerHari: 12, jadwal: ['senin','selasa','rabu']),
          ],
        ),
        Poliklinik(
          id: 'kandungan-id',
          nama: 'Poli Kandungan',
          lantai: 'Lantai 2',
          isActive: true,
          kuotaTersisa: 8,
          daftarDokter: [
            Dokter(id: '4', nama: 'dr. Maria Sp.OG', spesialis: 'Kebidanan & Kandungan', jamMulai: '09:00', jamSelesai: '13:00', kuotaPerHari: 8, jadwal: ['selasa','rabu','kamis']),
          ],
        ),
        Poliklinik(
          id: 'jantung-id',
          nama: 'Poli Jantung',
          lantai: 'Lantai 2',
          isActive: true,
          kuotaTersisa: 6,
          daftarDokter: [
            Dokter(id: '5', nama: 'dr. Hartono Sp.JP', spesialis: 'Jantung & Pembuluh Darah', jamMulai: '08:00', jamSelesai: '12:00', kuotaPerHari: 6, jadwal: ['senin','kamis']),
          ],
        ),
        Poliklinik(
          id: 'mata-id',
          nama: 'Poli Mata',
          lantai: 'Lantai 1',
          isActive: true,
          kuotaTersisa: 14,
          daftarDokter: [
            Dokter(id: '6', nama: 'dr. Indah Sp.M', spesialis: 'Kesehatan Mata', jamMulai: '08:00', jamSelesai: '12:00', kuotaPerHari: 14, jadwal: ['senin','selasa','rabu','jumat']),
          ],
        ),
        Poliklinik(
          id: 'paru-id',
          nama: 'Poli Paru',
          lantai: 'Lantai 1',
          isActive: true,
          kuotaTersisa: 10,
          daftarDokter: [
            Dokter(id: '7', nama: 'dr. Lukman Sp.P', spesialis: 'Spesialis Paru-Paru', jamMulai: '08:00', jamSelesai: '12:00', kuotaPerHari: 10, jadwal: ['selasa','kamis','jumat']),
          ],
        ),
        Poliklinik(
          id: 'saraf-id',
          nama: 'Poli Saraf',
          lantai: 'Lantai 2',
          isActive: true,
          kuotaTersisa: 5,
          daftarDokter: [
            Dokter(id: '8', nama: 'dr. Yudi Sp.N', spesialis: 'Spesialis Saraf', jamMulai: '09:00', jamSelesai: '12:00', kuotaPerHari: 5, jadwal: ['senin','rabu']),
          ],
        ),
        Poliklinik(
          id: 'gigi-id',
          nama: 'Poli Gigi',
          lantai: 'Lantai 1',
          isActive: false,
          kuotaTersisa: 0,
          daftarDokter: [],
        ),
      ];
    }
  }

  Future<KamarSummary> getKamarSummary() async {
    try {
      final response = await _dio.get('/rsud/kamar');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        // API returns data as object with 'ruangan' array, not direct array
        final data = responseData['data'] as Map<String, dynamic>;
        return KamarSummary.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data kamar');
      }
    } catch (e) {
      print('API ERROR getKamarSummary: $e');
      return KamarSummary(
        totalKamar: 487,
        tersedia: 174,
        ruangan: [
          Kamar(id: '1', nama: 'R.PICU KRAKATAU', kelas: 'ICU', kapasitas: 17, terisi: 14, tersedia: 3, isActive: true),
          Kamar(id: '2', nama: 'R.BROMO VIP', kelas: 'VIP', kapasitas: 20, terisi: 8, tersedia: 12, isActive: true),
          Kamar(id: '3', nama: 'R.AGUNG', kelas: 'Kelas II', kapasitas: 70, terisi: 45, tersedia: 25, isActive: true),
          Kamar(id: '4', nama: 'R.ICU UTAMA', kelas: 'ICU', kapasitas: 15, terisi: 10, tersedia: 5, isActive: true),
          Kamar(id: '5', nama: 'R.GALUNGGUNG', kelas: 'Kelas III', kapasitas: 80, terisi: 60, tersedia: 20, isActive: true),
          Kamar(id: '6', nama: 'R.SEMERU', kelas: 'Kelas III', kapasitas: 80, terisi: 55, tersedia: 25, isActive: true),
        ],
      );
    }
  }

  /// Legacy method for backward compat (returns flat list from summary)
  Future<List<Kamar>> getKamar() async {
    final summary = await getKamarSummary();
    return summary.ruangan;
  }

  Future<Antrean> ambilAntrean(AntreanRequest request) async {
    try {
      final response = await _dio.post('/rsud/antrean', data: request.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        return Antrean.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Gagal mendaftar antrean RSUD: ${response.statusCode}');
      }
    } catch (e) {
      print('API ERROR ambilAntrean: $e');
      // Return a mock Antrean to allow testing the UI queue status screen offline
      return Antrean(
        antreanId: 'mock-antrean-id-${DateTime.now().millisecondsSinceEpoch}',
        nomorAntrean: 'A-012',
        poli: request.poliId == '6cab51a0-a519-f377-a089-7a67b575492c' ? 'Poli Anak' : 'Poli Umum',
        dokter: request.dokterId == '3' ? 'dr. Sarah Sp.A' : 'dr. Andi Wijaya, Sp.U',
        estimasiJam: '08:45',
        qrCheckin: 'MOCK_QR_CODE_DATA_12345',
        status: 'menunggu',
      );
    }
  }
}
