class ScreeningQuestion {
  final int id;
  final String text;
  final String category; // 'keluhan' or 'info_lainnya'

  ScreeningQuestion({
    required this.id,
    required this.text,
    required this.category,
  });

  factory ScreeningQuestion.fromJson(Map<String, dynamic> json) {
    return ScreeningQuestion(
      id: json['id'] is int ? json['id'] : int.parse(json['id']?.toString() ?? '0'),
      text: json['text'] ?? json['pertanyaan'] ?? '',
      category: json['category'] ?? json['kategori'] ?? 'keluhan',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
    };
  }
}

class MedicationCalendarEntry {
  final String date;
  final String status; // 'Sudah', 'Terlewat'
  final bool isDone;

  MedicationCalendarEntry({
    required this.date,
    required this.status,
    required this.isDone,
  });

  factory MedicationCalendarEntry.fromJson(Map<String, dynamic> json) {
    return MedicationCalendarEntry(
      date: json['date'] ?? json['tanggal'] ?? '',
      status: json['status'] ?? '',
      isDone: json['isDone'] ?? json['sudah_minum'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'status': status,
      'isDone': isDone,
    };
  }
}

class MedicationAdherenceStatus {
  final int adherencePercentage;
  final String currentProgress; // e.g. "75/180 hari"
  final String startDate;
  final String dailyReminderTime; // e.g. "08:00"
  final bool isReminderEnabled;

  MedicationAdherenceStatus({
    required this.adherencePercentage,
    required this.currentProgress,
    required this.startDate,
    required this.dailyReminderTime,
    required this.isReminderEnabled,
  });

  factory MedicationAdherenceStatus.fromJson(Map<String, dynamic> json) {
    return MedicationAdherenceStatus(
      adherencePercentage: json['adherencePercentage'] ?? json['persentase_kepatuhan'] ?? 0,
      currentProgress: json['currentProgress'] ?? json['progres_minum'] ?? '0/180 hari',
      startDate: json['startDate'] ?? json['tanggal_mulai'] ?? '',
      dailyReminderTime: json['dailyReminderTime'] ?? json['waktu_pengingat'] ?? '08:00',
      isReminderEnabled: json['isReminderEnabled'] ?? json['pengingat_aktif'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adherencePercentage': adherencePercentage,
      'currentProgress': currentProgress,
      'startDate': startDate,
      'dailyReminderTime': dailyReminderTime,
      'isReminderEnabled': isReminderEnabled,
    };
  }
}
