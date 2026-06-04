import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/bapenda_model.dart';
import 'package:majadigi_superapp_frontend/services/api/bapenda_repository.dart';

class BapendaProvider extends ChangeNotifier {
  final BapendaRepository _repository = BapendaRepository();

  bool _isLoadingVehicles = false;
  bool _isLoadingBill = false;
  bool _isPaying = false;
  bool _isLoadingHistory = false;
  bool _isLoadingEtbpkb = false;

  String? _errorVehicles;
  String? _errorBill;
  String? _errorPaying;
  String? _errorHistory;
  String? _errorEtbpkb;

  List<BapendaVehicle> _vehicles = [];
  BapendaBillDetail? _currentBill;
  List<BapendaPaymentHistory> _paymentHistory = [];
  BapendaEtbpkb? _currentEtbpkb;

  // Getters
  bool get isLoadingVehicles => _isLoadingVehicles;
  bool get isLoadingBill => _isLoadingBill;
  bool get isPaying => _isPaying;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get isLoadingEtbpkb => _isLoadingEtbpkb;

  String? get errorVehicles => _errorVehicles;
  String? get errorBill => _errorBill;
  String? get errorPaying => _errorPaying;
  String? get errorHistory => _errorHistory;
  String? get errorEtbpkb => _errorEtbpkb;

  List<BapendaVehicle> get vehicles => _vehicles;
  BapendaBillDetail? get currentBill => _currentBill;
  List<BapendaPaymentHistory> get paymentHistory => _paymentHistory;
  BapendaEtbpkb? get currentEtbpkb => _currentEtbpkb;

  Future<void> fetchVehicles() async {
    _isLoadingVehicles = true;
    _errorVehicles = null;
    notifyListeners();

    try {
      _vehicles = await _repository.getVehicles();
    } catch (e) {
      _errorVehicles = e.toString();
    } finally {
      _isLoadingVehicles = false;
      notifyListeners();
    }
  }

  Future<void> fetchBillDetail(String platNomor) async {
    _isLoadingBill = true;
    _errorBill = null;
    _currentBill = null;
    notifyListeners();

    try {
      _currentBill = await _repository.getBillDetail(platNomor);
    } catch (e) {
      _errorBill = e.toString();
    } finally {
      _isLoadingBill = false;
      notifyListeners();
    }
  }

  Future<bool> payVehicleBill(String platNomor) async {
    _isPaying = true;
    _errorPaying = null;
    notifyListeners();

    try {
      await _repository.payBill(platNomor);
      // Refresh current bill details & list of vehicles to reflect new status
      await fetchBillDetail(platNomor);
      await fetchVehicles();
      return true;
    } catch (e) {
      _errorPaying = e.toString();
      return false;
    } finally {
      _isPaying = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentHistory() async {
    _isLoadingHistory = true;
    _errorHistory = null;
    notifyListeners();

    try {
      _paymentHistory = await _repository.getPaymentHistory();
    } catch (e) {
      _errorHistory = e.toString();
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> fetchEtbpkb(String id) async {
    _isLoadingEtbpkb = true;
    _errorEtbpkb = null;
    _currentEtbpkb = null;
    notifyListeners();

    try {
      _currentEtbpkb = await _repository.getEtbpkb(id);
    } catch (e) {
      _errorEtbpkb = e.toString();
    } finally {
      _isLoadingEtbpkb = false;
      notifyListeners();
    }
  }
}
