class Dokter {
  final String id;
  final String nama;
  final String spesialis;
  final String? fotoUrl;
  final String jamMulai;
  final String jamSelesai;
  final int kuotaPerHari;
  final List<String> jadwal;

  Dokter({
    required this.id,
    required this.nama,
    required this.spesialis,
    this.fotoUrl,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kuotaPerHari,
    required this.jadwal,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    final jadwalRaw = json['jadwal'] as List<dynamic>? ?? [];
    return Dokter(
      id: json['id'] ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      spesialis: json['spesialis'] ?? json['specialty'] ?? '',
      fotoUrl: json['foto_url'] as String?,
      jamMulai: json['jam_mulai'] ?? json['hari_kerja'] ?? '08:00',
      jamSelesai: json['jam_selesai'] ?? json['jam_kerja'] ?? '12:00',
      kuotaPerHari: json['kuota_per_hari'] ?? 30,
      jadwal: jadwalRaw.map((e) => e.toString()).toList(),
    );
  }

  /// Formatted jadwal string like "Senin - Jumat"
  String get jadwalFormatted {
    if (jadwal.isEmpty) return '-';
    if (jadwal.length == 1) return _capitalize(jadwal.first);
    return '${_capitalize(jadwal.first)} - ${_capitalize(jadwal.last)}';
  }

  /// Formatted jam like "08:00 - 12:00"
  String get jamFormatted {
    final s = jamMulai.length >= 5 ? jamMulai.substring(0, 5) : jamMulai;
    final e = jamSelesai.length >= 5 ? jamSelesai.substring(0, 5) : jamSelesai;
    return '$s - $e';
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class Poliklinik {
  final String id;
  final String nama;
  final String lantai;
  final bool isActive;
  final List<Dokter> daftarDokter;

  Poliklinik({
    required this.id,
    required this.nama,
    this.lantai = '',
    required this.isActive,
    required this.daftarDokter,
  });

  factory Poliklinik.fromJson(Map<String, dynamic> json) {
    // API uses 'dokter' key, not 'daftar_dokter'
    final doctorsList = json['dokter'] as List<dynamic>?
        ?? json['daftar_dokter'] as List<dynamic>?
        ?? [];
    return Poliklinik(
      id: json['id'] ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      lantai: json['lantai'] ?? '',
      isActive: json['is_active'] ?? true,
      daftarDokter: doctorsList.map((d) => Dokter.fromJson(d as Map<String, dynamic>)).toList(),
    );
  }
}

class Kamar {
  final String id;
  final String nama;
  final String kelas;
  final int kapasitas;
  final int terisi;
  final int tersedia;
  final bool isActive;

  Kamar({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.kapasitas,
    required this.terisi,
    required this.tersedia,
    required this.isActive,
  });

  factory Kamar.fromJson(Map<String, dynamic> json) {
    return Kamar(
      id: json['id'] ?? '',
      nama: json['nama'] ?? json['room_name'] ?? '',
      kelas: json['kelas'] ?? json['class'] ?? 'Kelas 1',
      kapasitas: json['kapasitas'] ?? json['capacity'] ?? 0,
      terisi: json['terisi'] ?? json['filled'] ?? 0,
      tersedia: json['tersedia'] ?? json['available'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

class KamarSummary {
  final int totalKamar;
  final int tersedia;
  final List<Kamar> ruangan;

  KamarSummary({
    required this.totalKamar,
    required this.tersedia,
    required this.ruangan,
  });

  factory KamarSummary.fromJson(Map<String, dynamic> json) {
    final ruanganList = json['ruangan'] as List<dynamic>? ?? [];
    return KamarSummary(
      totalKamar: json['total_kamar'] ?? 0,
      tersedia: json['tersedia'] ?? 0,
      ruangan: ruanganList.map((r) => Kamar.fromJson(r as Map<String, dynamic>)).toList(),
    );
  }
}

class AntreanRequest {
  final String poliId;
  final String dokterId;
  final String tanggal;

  AntreanRequest({
    required this.poliId,
    required this.dokterId,
    required this.tanggal,
  });

  Map<String, dynamic> toJson() {
    return {
      'poli_id': poliId,
      'dokter_id': dokterId,
      'tanggal': tanggal,
    };
  }
}

class Antrean {
  final String antreanId;
  final String nomorAntrean;
  final String poli;
  final String dokter;
  final String estimasiJam;
  final String qrCheckin;
  final String status;

  Antrean({
    required this.antreanId,
    required this.nomorAntrean,
    required this.poli,
    required this.dokter,
    required this.estimasiJam,
    required this.qrCheckin,
    required this.status,
  });

  factory Antrean.fromJson(Map<String, dynamic> json) {
    // estimasi_jam from server is HH:mm:ss → trim to HH:mm
    String rawJam = json['estimasi_jam'] ?? json['estimated_time'] ?? '';
    if (rawJam.length > 5) rawJam = rawJam.substring(0, 5);
    return Antrean(
      antreanId: json['antrean_id'] ?? json['id'] ?? '',
      nomorAntrean: json['nomor_antrean'] ?? json['queue_number'] ?? '',
      poli: json['poli'] ?? json['poliklinik'] ?? '',
      dokter: json['dokter'] ?? json['doctor'] ?? '',
      estimasiJam: rawJam,
      qrCheckin: json['qr_checkin'] ?? json['qr_code'] ?? '',
      status: json['status'] ?? 'menunggu',
    );
  }
}
