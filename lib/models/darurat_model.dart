class EmergencyAgency {
  final String id;
  final String title;
  final String subtitle;
  final String number;
  final String distance;

  EmergencyAgency({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.number,
    required this.distance,
  });

  factory EmergencyAgency.fromJson(Map<String, dynamic> json) {
    return EmergencyAgency(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['nama_instansi'] ?? '',
      subtitle: json['subtitle'] ?? json['deskripsi'] ?? '',
      number: json['number'] ?? json['nomor_telepon'] ?? '',
      distance: json['distance'] ?? json['jarak'] ?? '0 km',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'number': number,
      'distance': distance,
    };
  }
}

class PanicReport {
  final String id;
  final String category; // e.g. "Polisi", "Medis", "Damkar", "112 Pusat"
  final String number;
  final String gpsCoords;
  final String timestamp;
  final String status; // 'Diterima', 'Petugas Meluncur', 'Selesai'

  PanicReport({
    required this.id,
    required this.category,
    required this.number,
    required this.gpsCoords,
    required this.timestamp,
    required this.status,
  });

  factory PanicReport.fromJson(Map<String, dynamic> json) {
    return PanicReport(
      id: json['id']?.toString() ?? '',
      category: json['category'] ?? json['kategori'] ?? '',
      number: json['number'] ?? json['nomor'] ?? '',
      gpsCoords: json['gpsCoords'] ?? json['koordinat_gps'] ?? '',
      timestamp: json['timestamp'] ?? json['waktu'] ?? '',
      status: json['status'] ?? 'Diterima',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'number': number,
      'gpsCoords': gpsCoords,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
