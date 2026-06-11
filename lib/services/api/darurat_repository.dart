import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/darurat_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class DaruratRepository {
  final Dio _dio = DioClient.instance;

  // Local static reports list for simulating panic reports
  static final List<PanicReport> _localReports = [
    PanicReport(
      id: 'report-1',
      category: '119 Medis',
      number: '119',
      gpsCoords: '-7.250445, 112.768845',
      timestamp: 'Jumat, 22 Mei 2026, 14:30 WIB',
      status: 'Selesai',
    ),
    PanicReport(
      id: 'report-2',
      category: '110 Polisi',
      number: '110',
      gpsCoords: '-7.263889, 112.748611',
      timestamp: 'Rabu, 20 Mei 2026, 21:15 WIB',
      status: 'Selesai',
    ),
  ];

  static final List<EmergencyAgency> _fallbackAgencies = [
    EmergencyAgency(
      id: 'agency-1',
      title: 'Call Center 112',
      subtitle: 'Layanan Darurat Terpadu Jawa Timur',
      number: '112',
      distance: '0.5 km',
    ),
    EmergencyAgency(
      id: 'agency-2',
      title: 'Polisi',
      subtitle: 'Kepolisian Negara RI',
      number: '110',
      distance: '1.2 km',
    ),
    EmergencyAgency(
      id: 'agency-3',
      title: 'Ambulans/Medis',
      subtitle: 'Layanan Kesehatan Darurat',
      number: '119',
      distance: '2.0 km',
    ),
    EmergencyAgency(
      id: 'agency-4',
      title: 'Pemadam Kebakaran',
      subtitle: 'Dinas Pemadam Kebakaran',
      number: '113',
      distance: '2.5 km',
    ),
    EmergencyAgency(
      id: 'agency-5',
      title: 'SAR',
      subtitle: 'Search and Rescue Indonesia',
      number: '115',
      distance: '4.8 km',
    ),
    EmergencyAgency(
      id: 'agency-6',
      title: 'PLN',
      subtitle: 'Gangguan Listrik',
      number: '123',
      distance: '3.1 km',
    ),
    EmergencyAgency(
      id: 'agency-7',
      title: 'PDAM',
      subtitle: 'Gangguan Air PDAM',
      number: '1500651',
      distance: '5.2 km',
    ),
  ];

  Future<List<EmergencyAgency>> getAgencies() async {
    try {
      final response = await _dio.get('/darurat/instansi');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        if (list.isEmpty) {
          return _fallbackAgencies;
        }
        return list.map((item) => EmergencyAgency.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal memuat kontak darurat');
      }
    } catch (e) {
      print('API ERROR getAgencies: $e');
      return _fallbackAgencies;
    }
  }

  Future<PanicReport?> sendPanicReport(String category, String number, String gpsCoords) async {
    try {
      final response = await _dio.post('/darurat/panic', data: {
        'category': category,
        'number': number,
        'gps_coords': gpsCoords,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] ?? responseData;
        final report = PanicReport.fromJson(data as Map<String, dynamic>);
        _localReports.insert(0, report);
        return report;
      } else {
        throw Exception('Gagal mengirim laporan panic');
      }
    } catch (e) {
      print('API ERROR sendPanicReport: $e');
      // Create local fallback panic report
      final now = DateTime.now();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
      final dateStr = '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
      final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
      
      final report = PanicReport(
        id: 'report-${DateTime.now().millisecondsSinceEpoch}',
        category: category,
        number: number,
        gpsCoords: gpsCoords,
        timestamp: '$dateStr, $timeStr',
        status: 'Diterima',
      );
      _localReports.insert(0, report);
      return report;
    }
  }

  Future<List<PanicReport>> getPanicReports() async {
    try {
      final response = await _dio.get('/darurat/riwayat');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => PanicReport.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal memuat riwayat panic');
      }
    } catch (e) {
      print('API ERROR getPanicReports: $e');
      return _localReports;
    }
  }
}
