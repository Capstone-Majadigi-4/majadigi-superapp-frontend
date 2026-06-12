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

  // NJKB State
  bool _isLoadingTypes = false;
  bool _isLoadingBrands = false;
  bool _isLoadingModels = false;
  bool _isLoadingSubTypes = false;
  bool _isLoadingYears = false;
  bool _isCheckingNjkb = false;

  String? _errorTypes;
  String? _errorBrands;
  String? _errorModels;
  String? _errorSubTypes;
  String? _errorYears;
  String? _errorCheckingNjkb;

  List<String> _vehicleTypes = [];
  List<String> _vehicleBrands = [];
  List<String> _vehicleModels = [];
  List<String> _vehicleSubTypes = [];
  List<String> _vehicleYears = [];

  String? _selectedType;
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedSubType;
  String? _selectedYear;

  BapendaNjkbResult? _njkbResult;

  // Getters
  bool get isLoadingTypes => _isLoadingTypes;
  bool get isLoadingBrands => _isLoadingBrands;
  bool get isLoadingModels => _isLoadingModels;
  bool get isLoadingSubTypes => _isLoadingSubTypes;
  bool get isLoadingYears => _isLoadingYears;
  bool get isCheckingNjkb => _isCheckingNjkb;

  String? get errorTypes => _errorTypes;
  String? get errorBrands => _errorBrands;
  String? get errorModels => _errorModels;
  String? get errorSubTypes => _errorSubTypes;
  String? get errorYears => _errorYears;
  String? get errorCheckingNjkb => _errorCheckingNjkb;

  List<String> get vehicleTypes => _vehicleTypes;
  List<String> get vehicleBrands => _vehicleBrands;
  List<String> get vehicleModels => _vehicleModels;
  List<String> get vehicleSubTypes => _vehicleSubTypes;
  List<String> get vehicleYears => _vehicleYears;

  String? get selectedType => _selectedType;
  String? get selectedBrand => _selectedBrand;
  String? get selectedModel => _selectedModel;
  String? get selectedSubType => _selectedSubType;
  String? get selectedYear => _selectedYear;

  BapendaNjkbResult? get njkbResult => _njkbResult;

  void setSelectedType(String? value) {
    if (_selectedType != value) {
      _selectedType = value;
      _selectedBrand = null;
      _selectedModel = null;
      _selectedSubType = null;
      _selectedYear = null;
      _vehicleBrands = [];
      _vehicleModels = [];
      _vehicleSubTypes = [];
      _vehicleYears = [];
      _njkbResult = null;
      notifyListeners();
      if (value != null) {
        fetchVehicleBrands(value);
      }
    }
  }

  void setSelectedBrand(String? value) {
    if (_selectedBrand != value) {
      _selectedBrand = value;
      _selectedModel = null;
      _selectedSubType = null;
      _selectedYear = null;
      _vehicleModels = [];
      _vehicleSubTypes = [];
      _vehicleYears = [];
      _njkbResult = null;
      notifyListeners();
      if (value != null) {
        fetchVehicleModels(value);
      }
    }
  }

  void setSelectedModel(String? value) {
    if (_selectedModel != value) {
      _selectedModel = value;
      _selectedSubType = null;
      _selectedYear = null;
      _vehicleSubTypes = [];
      _vehicleYears = [];
      _njkbResult = null;
      notifyListeners();
      if (value != null) {
        fetchVehicleTypesOfModel(value);
      }
    }
  }

  void setSelectedSubType(String? value) {
    if (_selectedSubType != value) {
      _selectedSubType = value;
      _selectedYear = null;
      _vehicleYears = [];
      _njkbResult = null;
      notifyListeners();
      if (value != null) {
        fetchVehicleYears(value);
      }
    }
  }

  void setSelectedYear(String? value) {
    if (_selectedYear != value) {
      _selectedYear = value;
      _njkbResult = null;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleTypes() async {
    _isLoadingTypes = true;
    _errorTypes = null;
    notifyListeners();
    try {
      _vehicleTypes = await _repository.getVehicleTypes();
    } catch (e) {
      _errorTypes = e.toString();
    } finally {
      _isLoadingTypes = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleBrands(String jenis) async {
    _isLoadingBrands = true;
    _errorBrands = null;
    notifyListeners();
    try {
      _vehicleBrands = await _repository.getVehicleBrands(jenis);
    } catch (e) {
      _errorBrands = e.toString();
    } finally {
      _isLoadingBrands = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleModels(String merk) async {
    _isLoadingModels = true;
    _errorModels = null;
    notifyListeners();
    try {
      _vehicleModels = await _repository.getVehicleModels(merk);
    } catch (e) {
      _errorModels = e.toString();
    } finally {
      _isLoadingModels = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleTypesOfModel(String model) async {
    _isLoadingSubTypes = true;
    _errorSubTypes = null;
    notifyListeners();
    try {
      _vehicleSubTypes = await _repository.getVehicleTypesOfModel(model);
    } catch (e) {
      _errorSubTypes = e.toString();
    } finally {
      _isLoadingSubTypes = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleYears(String tipe) async {
    _isLoadingYears = true;
    _errorYears = null;
    notifyListeners();
    try {
      _vehicleYears = await _repository.getVehicleYears(tipe);
    } catch (e) {
      _errorYears = e.toString();
    } finally {
      _isLoadingYears = false;
      notifyListeners();
    }
  }

  Future<void> checkVehicleNjkb() async {
    if (_selectedType == null ||
        _selectedBrand == null ||
        _selectedModel == null ||
        _selectedSubType == null ||
        _selectedYear == null) {
      return;
    }

    _isCheckingNjkb = true;
    _errorCheckingNjkb = null;
    _njkbResult = null;
    notifyListeners();

    try {
      final int yearInt = int.parse(_selectedYear!);
      _njkbResult = await _repository.checkNjkb(
        jenis: _selectedType!,
        merk: _selectedBrand!,
        model: _selectedModel!,
        tipe: _selectedSubType!,
        tahun: yearInt,
      );
    } catch (e) {
      _errorCheckingNjkb = e.toString();
    } finally {
      _isCheckingNjkb = false;
      notifyListeners();
    }
  }

  void resetNjkbSelection() {
    _selectedType = null;
    _selectedBrand = null;
    _selectedModel = null;
    _selectedSubType = null;
    _selectedYear = null;
    _vehicleTypes = [];
    _vehicleBrands = [];
    _vehicleModels = [];
    _vehicleSubTypes = [];
    _vehicleYears = [];
    _njkbResult = null;
    _errorTypes = null;
    _errorBrands = null;
    _errorModels = null;
    _errorSubTypes = null;
    _errorYears = null;
    _errorCheckingNjkb = null;
    notifyListeners();
  }
}
