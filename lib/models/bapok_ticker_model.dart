class Komoditas {
  final String id;
  final String nama;
  final String kategori;
  final String satuan;
  final String? ikonUrl;
  final bool isActive;
  final double hargaRataRata;
  final double hargaTerendah;
  final double hargaTertinggi;
  final String? tanggalHarga;
  final double? perubahanPersen; // opsional untuk volatilitas ticker

  Komoditas({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.satuan,
    this.ikonUrl,
    required this.isActive,
    required this.hargaRataRata,
    required this.hargaTerendah,
    required this.hargaTertinggi,
    this.tanggalHarga,
    this.perubahanPersen,
  });

  factory Komoditas.fromJson(Map<String, dynamic> json) {
    return Komoditas(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] as String? ?? '',
      kategori: json['kategori'] as String? ?? '',
      satuan: json['satuan'] as String? ?? '',
      ikonUrl: json['ikon_url'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      hargaRataRata: (json['harga_rata_rata'] as num? ?? 0).toDouble(),
      hargaTerendah: (json['harga_terendah'] as num? ?? 0).toDouble(),
      hargaTertinggi: (json['harga_tertinggi'] as num? ?? 0).toDouble(),
      tanggalHarga: json['tanggal_harga'] as String?,
      perubahanPersen: json['perubahan_persen'] != null 
          ? (json['perubahan_persen'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'satuan': satuan,
      'ikon_url': ikonUrl,
      'is_active': isActive,
      'harga_rata_rata': hargaRataRata,
      'harga_terendah': hargaTerendah,
      'harga_tertinggi': hargaTertinggi,
      'tanggal_harga': tanggalHarga,
      'perubahan_persen': perubahanPersen,
    };
  }
}

class HargaHistori {
  final String tanggal;
  final double harga;
  final String pasarId;
  final String namaPasar;

  HargaHistori({
    required this.tanggal,
    required this.harga,
    required this.pasarId,
    required this.namaPasar,
  });

  factory HargaHistori.fromJson(Map<String, dynamic> json) {
    return HargaHistori(
      tanggal: json['tanggal'] as String? ?? '',
      harga: (json['harga'] as num? ?? 0).toDouble(),
      pasarId: json['pasar_id']?.toString() ?? '',
      namaPasar: json['nama_pasar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'harga': harga,
      'pasar_id': pasarId,
      'nama_pasar': namaPasar,
    };
  }
}
