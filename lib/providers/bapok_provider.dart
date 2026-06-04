import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';

import 'package:majadigi_superapp_frontend/services/api/bapok_repository.dart';

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

    try {
      await _repository.createPriceAlert(komoditasId, nominal, tipe);
      _isCreatingAlert = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorCreatingAlert = e.toString();
      _isCreatingAlert = false;
      notifyListeners();
      return false;
    }
  }
}
