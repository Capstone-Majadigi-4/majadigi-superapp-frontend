import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/etibi_model.dart';
import 'package:majadigi_superapp_frontend/services/api/etibi_repository.dart';

class EtibiProvider extends ChangeNotifier {
  final EtibiRepository _repository = EtibiRepository();

  List<ScreeningQuestion> _questions = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool? _lastScreeningResult;
  MedicationAdherenceStatus? _adherenceStatus;
  List<MedicationCalendarEntry> _calendarEntries = [];

  List<ScreeningQuestion> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get lastScreeningResult => _lastScreeningResult;
  MedicationAdherenceStatus? get adherenceStatus => _adherenceStatus;
  List<MedicationCalendarEntry> get calendarEntries => _calendarEntries;

  Future<void> fetchQuestions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _repository.getScreeningQuestions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> fetchLastScreeningResult() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastScreeningResult = await _repository.getLastScreeningResult();
      return _lastScreeningResult;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitScreening(Map<int, bool> answers) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.submitScreening(answers);
      _lastScreeningResult = result;
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAdherenceStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _adherenceStatus = await _repository.getAdherenceStatus();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCalendarEntries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _calendarEntries = await _repository.getCalendarEntries();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmMedicationIntake() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.confirmMedicationIntake();
      if (success) {
        // Refresh adherence status and calendar entries from repository
        _adherenceStatus = await _repository.getAdherenceStatus();
        _calendarEntries = await _repository.getCalendarEntries();
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

  Future<void> toggleReminder(bool isEnabled) async {
    if (_adherenceStatus == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateReminderSettings(isEnabled, _adherenceStatus!.dailyReminderTime);
      _adherenceStatus = await _repository.getAdherenceStatus();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateReminderTime(String time) async {
    if (_adherenceStatus == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateReminderSettings(_adherenceStatus!.isReminderEnabled, time);
      _adherenceStatus = await _repository.getAdherenceStatus();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
