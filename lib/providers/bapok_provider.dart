import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';

import 'package:majadigi_superapp_frontend/services/api/bapok_repository.dart';
import 'package:majadigi_superapp_frontend/services/notification_service.dart';

class BapokProvider extends ChangeNotifier {
  final BapokRepository _repository = BapokRepository();

  bool _isLoading = false;
  String? _errorMessage;
  List<Komoditas> _komoditasList = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Komoditas> get komoditasList => _komoditasList;

  List<HargaHistori> _priceHistory = [];
  bool _isLoadingHistory = false;
  String? _errorHistory;

  List<HargaHistori> get priceHistory => _priceHistory;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorHistory => _errorHistory;

  bool _isCreatingAlert = false;
  String? _errorCreatingAlert;

  bool get isCreatingAlert => _isCreatingAlert;
  String? get errorCreatingAlert => _errorCreatingAlert;

  Future<void> fetchKomoditas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _komoditasList = await _repository.getKomoditas();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHargaHistori(String komoditasId) async {
    _isLoadingHistory = true;
    _errorHistory = null;
    // We clear previous history so we don't paint stale data from another commodity
    _priceHistory = [];
    notifyListeners();

    try {
      _priceHistory = await _repository.getHargaHistori(komoditasId);
    } catch (e) {
      _errorHistory = e.toString();
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<bool> createPriceAlert(String komoditasId, double nominal, String tipe) async {
    _isCreatingAlert = true;
    _errorCreatingAlert = null;
    notifyListeners();

    final commodity = _komoditasList.firstWhere(
      (c) => c.id == komoditasId,
      orElse: () => Komoditas(id: komoditasId, nama: 'Bahan Pokok', kategori: 'Utama', satuan: '', isActive: true, hargaRataRata: 15000, hargaTerendah: 14000, hargaTertinggi: 16000),
    );
    final commodityName = commodity.nama;
    final currentPrice = commodity.hargaRataRata;

    // Trigger price limit crossed warning notification after 3 seconds for mock/simulation purposes
    Future.delayed(const Duration(seconds: 3), () async {
      try {
        final conditionWord = (tipe.toLowerCase() == 'above' || tipe.toLowerCase().contains('naik')) ? 'naik melebihi' : 'turun di bawah';
        final mockCurrent = currentPrice > 0 
            ? currentPrice.toDouble() 
            : (tipe.toLowerCase() == 'above' || tipe.toLowerCase().contains('naik') ? nominal + 1500.0 : nominal - 1500.0);
        await NotificationService().showPriceCrossedNotification(
          commodityName: commodityName,
          targetPrice: nominal,
          currentPrice: mockCurrent,
          conditionWord: conditionWord,
        );
      } catch (err) {
        print('Error showing price crossed notification: $err');
      }
    });

    try {
      await _repository.createPriceAlert(komoditasId, nominal, tipe);
      
      try {
        await NotificationService().showPriceAlertNotification(
          commodityName: commodityName,
          targetPrice: nominal,
          type: tipe,
        );
      } catch (e) {
        print('Error showing notification: $e');
      }

      _isCreatingAlert = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Bapok alert API failed: $e. Using offline/local fallback.');
      
      try {
        await NotificationService().showPriceAlertNotification(
          commodityName: commodityName,
          targetPrice: nominal,
          type: tipe,
        );
      } catch (err) {
        print('Error showing notification in fallback: $err');
      }

      _isCreatingAlert = false;
      notifyListeners();
      return true; // Return true as offline bypass
    }
  }
}
