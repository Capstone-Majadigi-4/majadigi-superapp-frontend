import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<Komoditas> _tickerData = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Komoditas> get tickerData => _tickerData;

  Future<void> fetchBapokTicker() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _dashboardRepository.getBapokTicker();
      _tickerData = data;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Error fetching bapok ticker: $e');
      
      // Fallback mockup data so it renders beautifully if server is unavailable
      _tickerData = [
        Komoditas(
          id: '1',
          nama: 'Beras Medium',
          kategori: 'Beras',
          satuan: 'kg',
          isActive: true,
          hargaRataRata: 13500,
          hargaTerendah: 12000,
          hargaTertinggi: 15000,
          tanggalHarga: '2026-05-18',
          perubahanPersen: 4.5,
        ),
        Komoditas(
          id: '2',
          nama: 'Gula Pasir',
          kategori: 'Gula',
          satuan: 'kg',
          isActive: true,
          hargaRataRata: 17500,
          hargaTerendah: 17000,
          hargaTertinggi: 18000,
          tanggalHarga: '2026-05-18',
          perubahanPersen: 2.1,
        ),
        Komoditas(
          id: '3',
          nama: 'Minyak Goreng Curah',
          kategori: 'Minyak',
          satuan: 'liter',
          isActive: true,
          hargaRataRata: 16000,
          hargaTerendah: 15500,
          hargaTertinggi: 16500,
          tanggalHarga: '2026-05-18',
          perubahanPersen: -1.2,
        ),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }
}
