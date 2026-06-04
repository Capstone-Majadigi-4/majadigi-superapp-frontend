import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/darurat_model.dart';
import 'package:majadigi_superapp_frontend/services/api/darurat_repository.dart';

class DaruratProvider with ChangeNotifier {
  final DaruratRepository _repository = DaruratRepository();

  List<EmergencyAgency> _agencies = [];
  List<PanicReport> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EmergencyAgency> get agencies => _agencies;
  List<PanicReport> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAgencies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _agencies = await _repository.getAgencies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPanicReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reports = await _repository.getPanicReports();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PanicReport?> triggerPanicButton(String category, String number, String gpsCoords) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final report = await _repository.sendPanicReport(category, number, gpsCoords);
      if (report != null) {
        await fetchPanicReports(); // Refresh history list
        return report;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
