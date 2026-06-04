class BansosProgram {
  final String title;
  final String status;
  final String nominal;
  final String distributionDate;

  BansosProgram({
    required this.title,
    required this.status,
    required this.nominal,
    required this.distributionDate,
  });

  factory BansosProgram.fromJson(Map<String, dynamic> json) {
    return BansosProgram(
      title: json['title'] ?? json['nama_program'] ?? '',
      status: json['status'] ?? 'Aktif',
      nominal: json['nominal'] ?? 'Rp 0',
      distributionDate: json['distribution_date'] ?? json['tanggal_penyaluran'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'nominal': nominal,
      'distribution_date': distributionDate,
    };
  }
}

class BansosProgramInfo {
  final String title;
  final String description;
  final String totalFunds;
  final String quota;

  BansosProgramInfo({
    required this.title,
    required this.description,
    required this.totalFunds,
    required this.quota,
  });

  factory BansosProgramInfo.fromJson(Map<String, dynamic> json) {
    return BansosProgramInfo(
      title: json['title'] ?? json['nama_program'] ?? '',
      description: json['description'] ?? json['deskripsi'] ?? '',
      totalFunds: json['total_funds'] ?? json['total_dana'] ?? 'Rp 0',
      quota: json['quota'] ?? json['kuota'] ?? '0 penerima',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'total_funds': totalFunds,
      'quota': quota,
    };
  }
}

class BansosStatus {
  final bool isEligible;
  final String statusText;
  final String description;
  final List<BansosProgram> programs;

  BansosStatus({
    required this.isEligible,
    required this.statusText,
    required this.description,
    required this.programs,
  });

  factory BansosStatus.fromJson(Map<String, dynamic> json) {
    final list = json['programs'] as List<dynamic>? ?? [];
    return BansosStatus(
      isEligible: json['is_eligible'] ?? json['isEligible'] ?? false,
      statusText: json['status_text'] ?? json['statusText'] ?? 'Tidak Terdaftar',
      description: json['description'] ?? json['keterangan'] ?? 'Anda tidak terdaftar sebagai penerima bantuan sosial',
      programs: list.map((item) => BansosProgram.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_eligible': isEligible,
      'status_text': statusText,
      'description': description,
      'programs': programs.map((p) => p.toJson()).toList(),
    };
  }
}
