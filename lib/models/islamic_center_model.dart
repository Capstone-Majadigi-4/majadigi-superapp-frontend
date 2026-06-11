import 'package:flutter/material.dart';

class Acara {
  final String id;
  final String judul;
  final String tanggal;        // ISO date: "2026-05-22"
  final int kuotaMaksimal;
  final int kuotaTerisi;       // API uses kuota_terisi not sisa_kuota
  final String deskripsi;
  final String waktuMulai;     // "07:00:00"
  final String waktuSelesai;   // "09:00:00"
  final String lokasi;
  final String? pemateri;
  final String? posterUrl;     // API uses poster_url not banner_url
  final String status;

  Acara({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.kuotaMaksimal,
    required this.kuotaTerisi,
    required this.deskripsi,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.lokasi,
    this.pemateri,
    this.posterUrl,
    required this.status,
  });

  int get sisaKuota => kuotaMaksimal - kuotaTerisi;

  /// Format tanggal from "2026-05-22" to "22 Mei 2026"
  String get tanggalFormatted {
    try {
      final dt = DateTime.parse(tanggal);
      const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return tanggal;
    }
  }

  /// Format time "07:00:00" -> "07:00"
  String get waktuMulaiFormatted => waktuMulai.length >= 5 ? waktuMulai.substring(0, 5) : waktuMulai;
  String get waktuSelesaiFormatted => waktuSelesai.length >= 5 ? waktuSelesai.substring(0, 5) : waktuSelesai;

  factory Acara.fromJson(Map<String, dynamic> json) {
    return Acara(
      id: json['id']?.toString() ?? '',
      judul: json['judul'] ?? json['title'] ?? '',
      tanggal: json['tanggal'] ?? json['date'] ?? '',
      kuotaMaksimal: json['kuota_maksimal'] ?? json['capacity'] ?? 0,
      // API returns kuota_terisi, not sisa_kuota
      kuotaTerisi: json['kuota_terisi'] ?? json['sisa_kuota'] ?? 0,
      deskripsi: json['deskripsi'] ?? json['description'] ?? '',
      waktuMulai: json['waktu_mulai'] ?? json['time_start'] ?? '',
      waktuSelesai: json['waktu_selesai'] ?? json['time_end'] ?? '',
      lokasi: json['lokasi'] ?? json['location'] ?? '',
      pemateri: json['pemateri'] as String?,
      // API uses poster_url, not banner_url
      posterUrl: json['poster_url'] as String? ?? json['banner_url'] as String?,
      status: json['status'] ?? 'aktif',
    );
  }
}

class Fasilitas {
  final String id;
  final String nama;
  final int kapasitas;
  final double hargaPerHari;   // API returns string, need to parse
  final String deskripsi;
  final String? fotoUrl;
  final bool isActive;

  Fasilitas({
    required this.id,
    required this.nama,
    required this.kapasitas,
    required this.hargaPerHari,
    required this.deskripsi,
    this.fotoUrl,
    required this.isActive,
  });

  factory Fasilitas.fromJson(Map<String, dynamic> json) {
    // harga_per_hari can be a string ("2500000") or number
    double harga = 0;
    final raw = json['harga_per_hari'] ?? json['price_per_day'] ?? 0;
    if (raw is String) {
      harga = double.tryParse(raw) ?? 0;
    } else {
      harga = (raw as num).toDouble();
    }

    return Fasilitas(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      kapasitas: json['kapasitas'] ?? json['capacity'] ?? 0,
      hargaPerHari: harga,
      deskripsi: json['deskripsi'] ?? json['description'] ?? '',
      fotoUrl: json['foto_url'] as String?,
      isActive: json['is_active'] ?? true,
    );
  }
}

class BookingFasilitas {
  final String id;
  final String fasilitasId;
  final String userNik;
  final String namaAcara;
  final String tanggalMulai;
  final String tanggalSelesai;
  final int estimasiPeserta;
  final String? dokumenUrl;
  final String estimasiBiaya;
  final String kodeBayar;
  final String status;
  final String? catatanAdmin;
  final String createdAt;
  final Fasilitas? fasilitas;

  BookingFasilitas({
    required this.id,
    required this.fasilitasId,
    required this.userNik,
    required this.namaAcara,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.estimasiPeserta,
    this.dokumenUrl,
    required this.estimasiBiaya,
    required this.kodeBayar,
    required this.status,
    this.catatanAdmin,
    required this.createdAt,
    this.fasilitas,
  });

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String get tanggalFormatted {
    if (tanggalMulai == tanggalSelesai) {
      return _formatDate(tanggalMulai);
    } else {
      return '${_formatDate(tanggalMulai)} - ${_formatDate(tanggalSelesai)}';
    }
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending_review': return 'Pending';
      case 'approved': return 'Disetujui';
      case 'rejected': return 'Ditolak';
      case 'lunas': return 'Lunas';
      case 'batal': return 'Dibatalkan';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending_review': return const Color(0xFFD08700);
      case 'approved':
      case 'lunas': return const Color(0xFF00A63E);
      case 'rejected':
      case 'batal': return const Color(0xFFD32F2F);
      default: return const Color(0xFF6A7282);
    }
  }

  factory BookingFasilitas.fromJson(Map<String, dynamic> json) {
    return BookingFasilitas(
      id: json['id']?.toString() ?? '',
      fasilitasId: json['fasilitas_id']?.toString() ?? '',
      userNik: json['user_nik']?.toString() ?? '',
      namaAcara: json['nama_acara'] ?? '',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'] ?? '',
      estimasiPeserta: json['estimasi_peserta'] is int
          ? json['estimasi_peserta']
          : json['estimasi_peserta'] is String
              ? (int.tryParse(json['estimasi_peserta']) ?? 0)
              : 0,
      dokumenUrl: json['dokumen_url'] as String?,
      estimasiBiaya: json['estimasi_biaya']?.toString() ?? '0',
      kodeBayar: json['kode_bayar'] ?? '',
      status: json['status'] ?? '',
      catatanAdmin: json['catatan_admin'] as String?,
      createdAt: json['created_at'] ?? '',
      fasilitas: json['fasilitas'] != null ? Fasilitas.fromJson(json['fasilitas']) : null,
    );
  }
}

class PendaftaranAcara {
  final String id;
  final String acaraId;
  final String userNik;
  final String qrPayload;
  final String status;
  final String daftarAt;
  final Acara? acara;

  PendaftaranAcara({
    required this.id,
    required this.acaraId,
    required this.userNik,
    required this.qrPayload,
    required this.status,
    required this.daftarAt,
    this.acara,
  });

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'valid': return 'Aktif';
      case 'expired': return 'Selesai';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'valid': return const Color(0xFF00A63E);
      case 'expired': return const Color(0xFF6A7282);
      default: return const Color(0xFF6A7282);
    }
  }

  factory PendaftaranAcara.fromJson(Map<String, dynamic> json) {
    return PendaftaranAcara(
      id: json['id']?.toString() ?? '',
      acaraId: json['acara_id']?.toString() ?? '',
      userNik: json['user_nik']?.toString() ?? '',
      qrPayload: json['qr_payload'] ?? '',
      status: json['status'] ?? '',
      daftarAt: json['daftar_at'] ?? '',
      acara: json['acara'] != null ? Acara.fromJson(json['acara']) : null,
    );
  }
}
