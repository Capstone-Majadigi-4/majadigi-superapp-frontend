import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String bapenda = '/bapenda';
  static const String hargaBahanPokok = '/harga-bahan-pokok';
  static const String islamicCenter = '/islamic-center';
  static const String rsud = '/rsud';
  static const String nomerDarurat = '/nomer-darurat';
  static const String destinasiWisata = '/destinasi-wisata';
  static const String infoBansos = '/info-bansos';
  static const String etibi = '/etibi';
  static const String sinaker = '/sinaker';
  static const String transjatim = '/transjatim';
}

class ModuleInfo {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const ModuleInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

const List<ModuleInfo> allModules = [
  ModuleInfo(
    title: 'Bapenda Jatim',
    subtitle: 'Pajak Kendaraan',
    icon: Icons.directions_car_outlined,
    color: Color(0xFF1565C0),
    route: AppRoutes.bapenda,
  ),
  ModuleInfo(
    title: 'Harga Bahan Pokok',
    subtitle: 'Komoditas & Price Alert',
    icon: Icons.shopping_basket_outlined,
    color: Color(0xFF2E7D32),
    route: AppRoutes.hargaBahanPokok,
  ),
  ModuleInfo(
    title: 'Islamic Center',
    subtitle: 'Event & Booking Gedung',
    icon: Icons.mosque_outlined,
    color: Color(0xFF6A1B9A),
    route: AppRoutes.islamicCenter,
  ),
  ModuleInfo(
    title: 'RSUD Dr. Saiful Anwar',
    subtitle: 'Antrean Online Poli',
    icon: Icons.local_hospital_outlined,
    color: Color(0xFFC62828),
    route: AppRoutes.rsud,
  ),
  ModuleInfo(
    title: 'Nomer Darurat',
    subtitle: 'Manajemen Kontak Darurat',
    icon: Icons.emergency_outlined,
    color: Color(0xFFE65100),
    route: AppRoutes.nomerDarurat,
  ),
  ModuleInfo(
    title: 'Destinasi Wisata',
    subtitle: 'Katalog & E-Ticketing',
    icon: Icons.landscape_outlined,
    color: Color(0xFF00695C),
    route: AppRoutes.destinasiWisata,
  ),
  ModuleInfo(
    title: 'Info Bansos',
    subtitle: 'Status Penerima Bantuan',
    icon: Icons.volunteer_activism_outlined,
    color: Color(0xFFF57F17),
    route: AppRoutes.infoBansos,
  ),
  ModuleInfo(
    title: 'Skrining E-Tibi',
    subtitle: 'Pemantauan Pasien TBC',
    icon: Icons.health_and_safety_outlined,
    color: Color(0xFF00838F),
    route: AppRoutes.etibi,
  ),
  ModuleInfo(
    title: 'Sinaker',
    subtitle: 'Lowongan Kerja',
    icon: Icons.work_outline,
    color: Color(0xFF283593),
    route: AppRoutes.sinaker,
  ),
  ModuleInfo(
    title: 'Transjatim',
    subtitle: 'Armada Bus & E-Ticket',
    icon: Icons.directions_bus_outlined,
    color: Color(0xFF558B2F),
    route: AppRoutes.transjatim,
  ),
];
