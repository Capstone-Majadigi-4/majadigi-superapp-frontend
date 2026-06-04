class Destination {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String openHours;
  final String route;
  final String distance;
  final String price;
  final String category; // 'Alam', 'Pantai', 'Keluarga'

  Destination({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.openHours,
    required this.route,
    required this.distance,
    required this.price,
    required this.category,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['nama_destinasi'] ?? '',
      description: json['description'] ?? json['deskripsi'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? json['foto'] ?? '',
      duration: json['duration'] ?? json['durasi'] ?? '',
      openHours: json['openHours'] ?? json['jam_buka'] ?? '',
      route: json['route'] ?? json['rute'] ?? '',
      distance: json['distance'] ?? json['jarak'] ?? '',
      price: json['price'] ?? json['harga'] ?? '',
      category: json['category'] ?? json['kategori'] ?? 'Semua',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'openHours': openHours,
      'route': route,
      'distance': distance,
      'price': price,
      'category': category,
    };
  }
}

class TourismTicket {
  final String id;
  final String destinationTitle;
  final String location;
  final String date;
  final String time;
  final String guests; // e.g. "1 orang"
  final String price; // e.g. "Rp 35.000"
  final String status; // 'Hari Ini', 'Mendatang'

  TourismTicket({
    required this.id,
    required this.destinationTitle,
    required this.location,
    required this.date,
    required this.time,
    required this.guests,
    required this.price,
    required this.status,
  });

  factory TourismTicket.fromJson(Map<String, dynamic> json) {
    return TourismTicket(
      id: json['id']?.toString() ?? '',
      destinationTitle: json['destination_title'] ?? json['nama_destinasi'] ?? '',
      location: json['location'] ?? json['lokasi'] ?? '',
      date: json['date'] ?? json['tanggal'] ?? '',
      time: json['time'] ?? json['waktu'] ?? '',
      guests: json['guests'] ?? json['jumlah_pengunjung'] ?? '1 orang',
      price: json['price'] ?? json['harga'] ?? '',
      status: json['status'] ?? 'Mendatang',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination_title': destinationTitle,
      'location': location,
      'date': date,
      'time': time,
      'guests': guests,
      'price': price,
      'status': status,
    };
  }
}
