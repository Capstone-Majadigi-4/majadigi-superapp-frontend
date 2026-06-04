class Koridor {
  final String id;
  final String kode;
  final String nama;
  final String asal;
  final String tujuan;
  final bool isActive;
  final String tarif;
  final String jarak;
  final String durasi;
  final int jumlahBus;

  Koridor({
    required this.id,
    required this.kode,
    required this.nama,
    required this.asal,
    required this.tujuan,
    required this.isActive,
    this.tarif = 'Rp 5.000',
    this.jarak = '25 km',
    this.durasi = '45 menit',
    this.jumlahBus = 8,
  });

  factory Koridor.fromJson(Map<String, dynamic> json) {
    return Koridor(
      id: json['id'] ?? '',
      kode: json['kode'] ?? '',
      nama: json['nama'] ?? '',
      asal: json['asal'] ?? '',
      tujuan: json['tujuan'] ?? '',
      isActive: json['is_active'] ?? true,
      tarif: json['tarif'] ?? 'Rp 5.000',
      jarak: json['jarak'] ?? '25 km',
      durasi: json['durasi'] ?? '45 menit',
      jumlahBus: json['jumlah_bus'] ?? 8,
    );
  }
}

class Ticket {
  final String id;
  final String userNik;
  final String koridorId;
  final int jumlah;
  final String total;
  final String qrTotp;
  final String status;
  final String validSampai;
  final String? digunakanAt;
  final String createdAt;
  final Koridor? koridor;

  Ticket({
    required this.id,
    required this.userNik,
    required this.koridorId,
    required this.jumlah,
    required this.total,
    required this.qrTotp,
    required this.status,
    required this.validSampai,
    this.digunakanAt,
    required this.createdAt,
    this.koridor,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      userNik: json['user_nik'] ?? '',
      koridorId: json['koridor_id'] ?? '',
      jumlah: json['jumlah'] ?? 1,
      total: json['total']?.toString() ?? '0',
      qrTotp: json['qr_totp'] ?? '',
      status: json['status'] ?? '',
      validSampai: json['valid_sampai'] ?? '',
      digunakanAt: json['digunakan_at'],
      createdAt: json['created_at'] ?? '',
      koridor: json['koridor'] != null ? Koridor.fromJson(json['koridor']) : null,
    );
  }
}

class TicketPurchaseResponse {
  final Ticket ticket;
  final String qrImage;

  TicketPurchaseResponse({
    required this.ticket,
    required this.qrImage,
  });

  factory TicketPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return TicketPurchaseResponse(
      ticket: Ticket.fromJson(json['tiket'] ?? {}),
      qrImage: json['qr_image'] ?? '',
    );
  }
}

class Armada {
  final String id;
  final String koridorId;
  final String kodeBus;
  final int kapasitas;
  final double? lat;
  final double? lng;
  final String status;
  final String updatedAt;

  Armada({
    required this.id,
    required this.koridorId,
    required this.kodeBus,
    required this.kapasitas,
    this.lat,
    this.lng,
    required this.status,
    required this.updatedAt,
  });

  factory Armada.fromJson(Map<String, dynamic> json) {
    return Armada(
      id: json['id'] ?? '',
      koridorId: json['koridor_id'] ?? '',
      kodeBus: json['kode_bus'] ?? '',
      kapasitas: json['kapasitas'] ?? 0,
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
      status: json['status'] ?? 'aktif',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
