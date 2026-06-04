class BapendaVehicle {
  final String platNomor;
  final String merk;
  final String tipe;
  final String tanggalJatuhTempo;
  final bool isWarning;
  final String statusText;
  final String pemilik;
  final String noRangka;
  final String noMesin;
  final int tahun;

  BapendaVehicle({
    required this.platNomor,
    required this.merk,
    required this.tipe,
    required this.tanggalJatuhTempo,
    required this.isWarning,
    required this.statusText,
    required this.pemilik,
    required this.noRangka,
    required this.noMesin,
    required this.tahun,
  });

  factory BapendaVehicle.fromJson(Map<String, dynamic> json) {
    return BapendaVehicle(
      platNomor: json['plat_nomor'] ?? json['platNomor'] ?? '',
      merk: json['merk'] ?? '',
      tipe: json['tipe'] ?? '',
      tanggalJatuhTempo: json['tanggal_jatuh_tempo'] ?? json['tanggalJatuhTempo'] ?? '',
      isWarning: json['is_warning'] ?? json['isWarning'] ?? false,
      statusText: json['status_text'] ?? json['statusText'] ?? '',
      pemilik: json['pemilik'] ?? '',
      noRangka: json['no_rangka'] ?? json['noRangka'] ?? '',
      noMesin: json['no_mesin'] ?? json['noMesin'] ?? '',
      tahun: json['tahun'] ?? 2020,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plat_nomor': platNomor,
      'merk': merk,
      'tipe': tipe,
      'tanggal_jatuh_tempo': tanggalJatuhTempo,
      'is_warning': isWarning,
      'status_text': statusText,
      'pemilik': pemilik,
      'no_rangka': noRangka,
      'no_mesin': noMesin,
      'tahun': tahun,
    };
  }
}

class BapendaBillDetail {
  final String platNomor;
  final String merk;
  final String tipe;
  final String jatuhTempo;
  final double pkbPokok;
  final double swdkljj;
  final double biayaAdmin;
  final double denda;
  final double totalTagihan;
  final String statusBayar;

  BapendaBillDetail({
    required this.platNomor,
    required this.merk,
    required this.tipe,
    required this.jatuhTempo,
    required this.pkbPokok,
    required this.swdkljj,
    required this.biayaAdmin,
    required this.denda,
    required this.totalTagihan,
    required this.statusBayar,
  });

  factory BapendaBillDetail.fromJson(Map<String, dynamic> json) {
    return BapendaBillDetail(
      platNomor: json['plat_nomor'] ?? json['platNomor'] ?? '',
      merk: json['merk'] ?? '',
      tipe: json['tipe'] ?? '',
      jatuhTempo: json['jatuh_tempo'] ?? json['jatuhTempo'] ?? '',
      pkbPokok: (json['pkb_pokok'] ?? json['pkbPokok'] ?? 0.0).toDouble(),
      swdkljj: (json['swdkljj'] ?? 0.0).toDouble(),
      biayaAdmin: (json['biaya_admin'] ?? json['biayaAdmin'] ?? 0.0).toDouble(),
      denda: (json['denda'] ?? 0.0).toDouble(),
      totalTagihan: (json['total_tagihan'] ?? json['totalTagihan'] ?? 0.0).toDouble(),
      statusBayar: json['status_bayar'] ?? json['statusBayar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plat_nomor': platNomor,
      'merk': merk,
      'tipe': tipe,
      'jatuh_tempo': jatuhTempo,
      'pkb_pokok': pkbPokok,
      'swdkljj': swdkljj,
      'biaya_admin': biayaAdmin,
      'denda': denda,
      'total_tagihan': totalTagihan,
      'status_bayar': statusBayar,
    };
  }
}

class BapendaPaymentHistory {
  final String id;
  final String platNomor;
  final String tanggalBayar;
  final double jumlah;
  final String status;
  final String kodeBayar;

  BapendaPaymentHistory({
    required this.id,
    required this.platNomor,
    required this.tanggalBayar,
    required this.jumlah,
    required this.status,
    required this.kodeBayar,
  });

  factory BapendaPaymentHistory.fromJson(Map<String, dynamic> json) {
    return BapendaPaymentHistory(
      id: json['id'] ?? '',
      platNomor: json['plat_nomor'] ?? json['platNomor'] ?? '',
      tanggalBayar: json['tanggal_bayar'] ?? json['tanggalBayar'] ?? '',
      jumlah: (json['jumlah'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      kodeBayar: json['kode_bayar'] ?? json['kodeBayar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plat_nomor': platNomor,
      'tanggal_bayar': tanggalBayar,
      'jumlah': jumlah,
      'status': status,
      'kode_bayar': kodeBayar,
    };
  }
}

class BapendaEtbpkb {
  final String id;
  final String nopol;
  final String pemilik;
  final String merkTipe;
  final int tahun;
  final String tanggalBayar;
  final double jumlah;
  final String status;
  final String qrCodeData;

  BapendaEtbpkb({
    required this.id,
    required this.nopol,
    required this.pemilik,
    required this.merkTipe,
    required this.tahun,
    required this.tanggalBayar,
    required this.jumlah,
    required this.status,
    required this.qrCodeData,
  });

  factory BapendaEtbpkb.fromJson(Map<String, dynamic> json) {
    return BapendaEtbpkb(
      id: json['id'] ?? '',
      nopol: json['nopol'] ?? '',
      pemilik: json['pemilik'] ?? '',
      merkTipe: json['merk_tipe'] ?? json['merkTipe'] ?? '',
      tahun: json['tahun'] ?? 2020,
      tanggalBayar: json['tanggal_bayar'] ?? json['tanggalBayar'] ?? '',
      jumlah: (json['jumlah'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      qrCodeData: json['qr_code_data'] ?? json['qrCodeData'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nopol': nopol,
      'pemilik': pemilik,
      'merk_tipe': merkTipe,
      'tahun': tahun,
      'tanggal_bayar': tanggalBayar,
      'jumlah': jumlah,
      'status': status,
      'qr_code_data': qrCodeData,
    };
  }
}
