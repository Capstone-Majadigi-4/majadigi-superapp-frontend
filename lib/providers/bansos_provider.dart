import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/bansos_model.dart';
import 'package:majadigi_superapp_frontend/services/api/bansos_repository.dart';

class BansosProvider extends ChangeNotifier {
  final BansosRepository _repository = BansosRepository();

  BansosStatus? _bansosStatus;
  List<BansosProgramInfo> _programs = [];
  bool _isLoading = false;
  String? _errorMessage;

  BansosStatus? get bansosStatus => _bansosStatus;
  List<BansosProgramInfo> get programs => _programs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBansosStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bansosStatus = await _repository.getBansosStatus();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBansosPrograms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _programs = await _repository.getBansosPrograms();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
