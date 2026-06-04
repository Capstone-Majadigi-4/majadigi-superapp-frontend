import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/sinaker_model.dart';
import 'package:majadigi_superapp_frontend/services/api/sinaker_repository.dart';

class SinakerProvider extends ChangeNotifier {
  final SinakerRepository _repository = SinakerRepository();

  List<JobVacancy> _vacancies = [];
  List<JobApplication> _applications = [];
  SinakerProfile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  List<JobVacancy> get vacancies => _vacancies;
  List<JobApplication> get applications => _applications;
  SinakerProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVacancies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vacancies = await _repository.getVacancies();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _applications = await _repository.getApplications();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getProfile();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> applyJob(String vacancyId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.applyJob(vacancyId);
      if (success) {
        // Refresh local list of applications
        _applications = await _repository.getApplications();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(SinakerProfile profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.updateProfile(profile);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
