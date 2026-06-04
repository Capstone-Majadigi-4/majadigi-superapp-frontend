import 'package:dio/dio.dart';
import 'package:majadigi_superapp_frontend/models/etibi_model.dart';
import 'package:majadigi_superapp_frontend/services/api/dio_client.dart';

class EtibiRepository {
  final Dio _dio = DioClient.instance;

  // Local static stores for mockup fallbacks
  static final List<ScreeningQuestion> _fallbackQuestions = [
    ScreeningQuestion(id: 0, text: 'Batuk lebih dari 2 minggu', category: 'keluhan'),
    ScreeningQuestion(id: 1, text: 'Demam', category: 'keluhan'),
    ScreeningQuestion(id: 2, text: 'Berkeringat malam hari tanpa aktivitas', category: 'keluhan'),
    ScreeningQuestion(id: 3, text: 'Sesak nafas', category: 'keluhan'),
    ScreeningQuestion(id: 4, text: 'Nyeri dada', category: 'keluhan'),
    ScreeningQuestion(id: 5, text: 'Ada benjolan di leher/bawah rahang/bawah telinga/ketiak', category: 'keluhan'),
    ScreeningQuestion(id: 6, text: 'Batuk berdarah', category: 'keluhan'),
    ScreeningQuestion(id: 7, text: 'Batuk kurang dari 2 minggu', category: 'keluhan'),
    ScreeningQuestion(id: 8, text: 'Nafsu makan turun (atau hilang nafsu makan selama berhari-hari)', category: 'keluhan'),
    ScreeningQuestion(id: 9, text: 'Mudah lelah (atau sering kecapekan tanpa aktivitas fisik yang berarti)', category: 'keluhan'),
    ScreeningQuestion(id: 10, text: 'Pernah kontak satu rumah dengan pasien TBC', category: 'info_lainnya'),
    ScreeningQuestion(id: 11, text: 'Pernah didiagnosis TBC sebelumnya', category: 'info_lainnya'),
    ScreeningQuestion(id: 12, text: 'Memiliki penyakit penyerta (DM, HIV, dll)', category: 'info_lainnya'),
  ];

  static final List<MedicationCalendarEntry> _localCalendar = [
    MedicationCalendarEntry(date: '4 Apr', status: 'Sudah', isDone: true),
    MedicationCalendarEntry(date: '3 Apr', status: 'Terlewat', isDone: false),
    MedicationCalendarEntry(date: '2 Apr', status: 'Sudah', isDone: true),
    MedicationCalendarEntry(date: '1 Apr', status: 'Sudah', isDone: true),
  ];

  static MedicationAdherenceStatus _localStatus = MedicationAdherenceStatus(
    adherencePercentage: 95,
    currentProgress: '75/180 hari',
    startDate: '15 Januari 2025',
    dailyReminderTime: '08:00',
    isReminderEnabled: true,
  );

  static bool? _lastScreeningResult; // true if high risk, false if low risk, null if not screened yet

  Future<List<ScreeningQuestion>> getScreeningQuestions() async {
    try {
      final response = await _dio.get('/etibi/pertanyaan');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => ScreeningQuestion.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal mengambil pertanyaan skrining');
      }
    } catch (e) {
      print('API ERROR getScreeningQuestions: $e');
      return _fallbackQuestions;
    }
  }

  Future<bool> submitScreening(Map<int, bool> answers) async {
    try {
      final response = await _dio.post('/etibi/skrining', data: {
        'answers': answers.map((key, value) => MapEntry(key.toString(), value)),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final isAtRisk = responseData['isAtRisk'] ?? responseData['data']?['isAtRisk'] ?? false;
        _lastScreeningResult = isAtRisk;
        return isAtRisk;
      } else {
        throw Exception('Gagal submit hasil skrining');
      }
    } catch (e) {
      print('API ERROR submitScreening: $e');
      // local logic: high risk if any answer is true
      final isAtRisk = answers.values.any((val) => val == true);
      _lastScreeningResult = isAtRisk;
      return isAtRisk;
    }
  }

  Future<bool?> getLastScreeningResult() async {
    try {
      final response = await _dio.get('/etibi/hasil-skrining');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] ?? responseData;
        if (data == null || data['isAtRisk'] == null) return null;
        return data['isAtRisk'] as bool;
      } else {
        throw Exception('Gagal mendapatkan hasil skrining terakhir');
      }
    } catch (e) {
      print('API ERROR getLastScreeningResult: $e');
      return _lastScreeningResult;
    }
  }

  Future<MedicationAdherenceStatus> getAdherenceStatus() async {
    try {
      final response = await _dio.get('/etibi/status-pengobatan');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] ?? responseData;
        return MedicationAdherenceStatus.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Gagal mengambil status kepatuhan obat');
      }
    } catch (e) {
      print('API ERROR getAdherenceStatus: $e');
      return _localStatus;
    }
  }

  Future<List<MedicationCalendarEntry>> getCalendarEntries() async {
    try {
      final response = await _dio.get('/etibi/kalender-kepatuhan');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final list = responseData['data'] as List<dynamic>? ?? [];
        return list.map((item) => MedicationCalendarEntry.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal mengambil kalender kepatuhan');
      }
    } catch (e) {
      print('API ERROR getCalendarEntries: $e');
      return _localCalendar;
    }
  }

  Future<bool> confirmMedicationIntake() async {
    try {
      final response = await _dio.post('/etibi/konfirmasi-obat');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local state too
        _updateLocalConfirmState();
        return true;
      } else {
        throw Exception('Gagal melakukan konfirmasi minum obat');
      }
    } catch (e) {
      print('API ERROR confirmMedicationIntake: $e');
      _updateLocalConfirmState();
      return true;
    }
  }

  void _updateLocalConfirmState() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dateStr = '${now.day} ${months[now.month - 1]}';
    
    // Check if already confirmed for today to avoid duplicate entries
    final index = _localCalendar.indexWhere((entry) => entry.date == dateStr);
    if (index != -1) {
      _localCalendar[index] = MedicationCalendarEntry(date: dateStr, status: 'Sudah', isDone: true);
    } else {
      _localCalendar.insert(0, MedicationCalendarEntry(date: dateStr, status: 'Sudah', isDone: true));
    }

    // Update medication progress
    // Format: "75/180 hari" -> parse and increment 75 to 76
    final parts = _localStatus.currentProgress.split('/');
    int current = 75;
    int total = 180;
    if (parts.length == 2) {
      current = int.tryParse(parts[0]) ?? 75;
      total = int.tryParse(parts[1]) ?? 180;
    }
    // Only increment if we didn't confirm today already in the status (avoid multiple presses)
    if (_localCalendar.where((e) => e.date == dateStr).length == 1 && _localCalendar.first.isDone) {
      current = current + 1;
    }
    final percentage = ((current / total) * 100).round();

    _localStatus = MedicationAdherenceStatus(
      adherencePercentage: percentage,
      currentProgress: '$current/$total hari',
      startDate: _localStatus.startDate,
      dailyReminderTime: _localStatus.dailyReminderTime,
      isReminderEnabled: _localStatus.isReminderEnabled,
    );
  }

  Future<void> updateReminderSettings(bool isEnabled, String time) async {
    try {
      await _dio.post('/etibi/pengaturan-pengingat', data: {
        'is_reminder_enabled': isEnabled,
        'reminder_time': time,
      });
      _localStatus = MedicationAdherenceStatus(
        adherencePercentage: _localStatus.adherencePercentage,
        currentProgress: _localStatus.currentProgress,
        startDate: _localStatus.startDate,
        dailyReminderTime: time,
        isReminderEnabled: isEnabled,
      );
    } catch (e) {
      print('API ERROR updateReminderSettings: $e');
      _localStatus = MedicationAdherenceStatus(
        adherencePercentage: _localStatus.adherencePercentage,
        currentProgress: _localStatus.currentProgress,
        startDate: _localStatus.startDate,
        dailyReminderTime: time,
        isReminderEnabled: isEnabled,
      );
    }
  }
}
