import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/models/etibi_model.dart';
import 'package:majadigi_superapp_frontend/services/api/etibi_repository.dart';
import 'package:majadigi_superapp_frontend/services/notification_service.dart';

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
    _isLoading = true;
    notifyListeners();

    _adherenceStatus ??= MedicationAdherenceStatus(
      startDate: DateTime.now().toIso8601String().substring(0, 10),
      currentProgress: '1/180 hari',
      adherencePercentage: 100,
      isReminderEnabled: false,
      dailyReminderTime: '08:00',
    );

    final time = _adherenceStatus!.dailyReminderTime;

    try {
      await _repository.updateReminderSettings(isEnabled, time);
      _adherenceStatus = await _repository.getAdherenceStatus();
    } catch (e) {
      print('Etibi toggle reminder API failed: $e. Using local/offline fallback.');
      _adherenceStatus = MedicationAdherenceStatus(
        startDate: _adherenceStatus!.startDate,
        currentProgress: _adherenceStatus!.currentProgress,
        adherencePercentage: _adherenceStatus!.adherencePercentage,
        isReminderEnabled: isEnabled,
        dailyReminderTime: time,
      );
    } finally {
      if (isEnabled) {
        try {
          await NotificationService().showTbcMedicineNotification(time: time);
        } catch (err) {
          print('Error showing TBC notification: $err');
        }
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateReminderTime(String time) async {
    _isLoading = true;
    notifyListeners();

    _adherenceStatus ??= MedicationAdherenceStatus(
      startDate: DateTime.now().toIso8601String().substring(0, 10),
      currentProgress: '1/180 hari',
      adherencePercentage: 100,
      isReminderEnabled: true,
      dailyReminderTime: '08:00',
    );

    final isEnabled = _adherenceStatus!.isReminderEnabled;

    try {
      await _repository.updateReminderSettings(isEnabled, time);
      _adherenceStatus = await _repository.getAdherenceStatus();
    } catch (e) {
      print('Etibi update reminder time API failed: $e. Using local/offline fallback.');
      _adherenceStatus = MedicationAdherenceStatus(
        startDate: _adherenceStatus!.startDate,
        currentProgress: _adherenceStatus!.currentProgress,
        adherencePercentage: _adherenceStatus!.adherencePercentage,
        isReminderEnabled: isEnabled,
        dailyReminderTime: time,
      );
    } finally {
      if (isEnabled) {
        try {
          await NotificationService().showTbcMedicineNotification(time: time);
        } catch (err) {
          print('Error showing TBC notification: $err');
        }
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
