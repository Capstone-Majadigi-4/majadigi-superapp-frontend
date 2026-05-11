import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:majadigi_superapp_frontend/models/service_module.dart';

// Screens
import 'package:majadigi_superapp_frontend/screens/bapenda_screen.dart';
import 'package:majadigi_superapp_frontend/screens/tourist_destinations_screen.dart';
import 'package:majadigi_superapp_frontend/screens/sinaker_screen.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_saiful_anwar_screen.dart';
import 'package:majadigi_superapp_frontend/screens/tbc_screening_screen.dart';
import 'package:majadigi_superapp_frontend/screens/siskaperbapo_screen.dart';
import 'package:majadigi_superapp_frontend/screens/islamic_center_screen.dart';
import 'package:majadigi_superapp_frontend/screens/transjatim_screen.dart';
import 'package:majadigi_superapp_frontend/screens/emergency_numbers_screen.dart';

class ModuleProvider extends ChangeNotifier {
  static const String _prefKey = 'installed_modules';
  SharedPreferences? _prefs;

  List<String> _installedModuleIds = [];
  
  // The global catalog of available modules
  final List<ServiceModule> _availableModules = [
    const ServiceModule(
      id: 'bapenda',
      title: 'Bapenda',
      emoji: '💰',
      bgColor: Color(0xFF2563EB),
      category: 'Ekonomi dan Bisnis',
      description: 'Layanan Pajak Daerah Kota Malang',
      features: [
        'Cek tagihan pajak PBB dengan NOP',
        'Bayar pajak online langsung dari aplikasi',
        'Riwayat pembayaran tersimpan otomatis',
        'Unduh bukti pembayaran digital'
      ],
      destinationScreen: BapendaScreen(),
    ),
    const ServiceModule(
      id: 'transjatim',
      title: 'TransJatim',
      emoji: '🚌',
      bgColor: Color(0xFF4F46E5),
      category: 'Infrastruktur',
      description: 'Transportasi Publik Jawa Timur',
      features: [
        'Lihat rute dan halte TransJatim lengkap',
        'Jadwal keberangkatan real-time',
        'Status bus sedang berjalan atau datang',
        'Navigasi langsung ke halte pilihan'
      ],
      destinationScreen: TransjatimScreen(),
    ),
    const ServiceModule(
      id: 'emergency',
      title: 'Nomor Darurat',
      emoji: '📞',
      bgColor: Color(0xFFE11D48),
      category: 'Keamanan',
      description: 'Layanan Gawat Darurat 24 Jam',
      features: [
        'Akses cepat ke semua nomor darurat',
        'Panggil langsung dengan satu ketukan',
        'Informasi layanan untuk tiap kontak',
        'Tips menelepon dalam keadaan darurat'
      ],
      destinationScreen: EmergencyNumbersScreen(),
    ),
    const ServiceModule(
      id: 'sinaker',
      title: 'Sinaker',
      emoji: '💼',
      bgColor: Color(0xFFD97706),
      category: 'Ketenagakerjaan',
      description: 'Sistem Informasi Ketenagakerjaan',
      features: [
        'Cari lowongan kerja di Malang & sekitarnya',
        'Filter berdasarkan tipe pekerjaan',
        'Informasi gaji dan benefit lengkap',
        'Lamar langsung dari aplikasi'
      ],
      destinationScreen: SinakerScreen(),
    ),
    const ServiceModule(
      id: 'islamic_center',
      title: 'Islamic Center',
      emoji: '🕌',
      bgColor: Color(0xFF059669),
      category: 'Pariwisata & Kebudayaan',
      description: 'Jadwal Sholat & Event Islami',
      features: [
        'Jadwal sholat akurat untuk Kota Malang',
        'Daftar event kajian dan festival islami',
        'Pendaftaran event online langsung',
        'Informasi pembicara dan lokasi lengkap'
      ],
      destinationScreen: IslamicCenterScreen(),
    ),
    const ServiceModule(
      id: 'rsud',
      title: 'RSUD Dr. Saiful Anwar',
      emoji: '🏥',
      bgColor: Color(0xFFE11D48),
      category: 'Kesehatan',
      description: 'Layanan Kesehatan Rumah Sakit',
      features: [
        'Ambil antrean online untuk berbagai poli',
        'Lihat jadwal dokter spesialis',
        'Pilih dokter dan waktu yang sesuai',
        'Riwayat kunjungan tersimpan otomatis'
      ],
      destinationScreen: RsudSaifulAnwarScreen(),
    ),
    const ServiceModule(
      id: 'wisata',
      title: 'Destinasi Wisata',
      emoji: '🏞️',
      bgColor: Color(0xFF0EA5E9),
      category: 'Pariwisata & Kebudayaan',
      description: 'Explore Wisata Malang & Jawa Timur',
      features: [
        'Temukan destinasi wisata populer',
        'Informasi lengkap lokasi dan harga tiket',
        'Navigasi langsung ke Google Maps',
        'Membeli tiket sebelum kehabisan'
      ],
      destinationScreen: TouristDestinationsScreen(),
    ),
    const ServiceModule(
      id: 'tbc',
      title: 'Skrining E-Tibi',
      emoji: '🧪',
      bgColor: Color(0xFF0891B2),
      category: 'Kesehatan',
      description: 'Deteksi Dini Tuberkulosis',
      features: [
        'Skrining TBC gratis dalam 2-3 menit',
        '6 pertanyaan deteksi dini sederhana',
        'Hasil dan rekomendasi langsung',
        'Panduan langkah selanjutnya yang jelas'
      ],
      destinationScreen: TbcScreeningScreen(),
    ),
    const ServiceModule(
      id: 'siskaperbapo',
      title: 'Siskaperbapo',
      emoji: '🛒',
      bgColor: Color(0xFF0D9488),
      category: 'Ekonomi dan Bisnis',
      description: 'Informasi Harian seputar Bahan pokok',
      features: [
        'Melihat Harga Bahan Pokok realtime',
        'Alarm jika ada kenaikan harga',
        'Perbandingan Harga Koperasi Merah Putih',
        'Grafik Harga Bahan Pokok'
      ],
      destinationScreen: SiskaperbapoScreen(),
    ),
    const ServiceModule(
      id: 'sapabansos',
      title: 'Info Bansos',
      emoji: '💵',
      bgColor: Color(0xFFFCE7F3),
      category: 'Sosial',
      description: 'Bantuan Sosial Pemerintah',
      features: [
        'Cek status penerima bansos dengan NIK',
        'Informasi program bantuan aktif',
        'Rincian jumlah bantuan per program',
        'Panduan pendaftaran bantuan sosial'
      ],
      destinationScreen: Scaffold(body: Center(child: Text('SapaBansos Coming Soon'))),
    ),
  ];

  List<String> get installedModuleIds => _installedModuleIds;
  List<ServiceModule> get availableModules => _availableModules;

  List<ServiceModule> get installedModules {
    return _availableModules.where((m) => _installedModuleIds.contains(m.id)).toList();
  }

  ModuleProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? saved = _prefs?.getStringList(_prefKey);
    if (saved != null) {
      _installedModuleIds = saved;
    } else {
      _installedModuleIds = ['bapenda', 'transjatim', 'emergency'];
      await _prefs?.setStringList(_prefKey, _installedModuleIds);
    }
    notifyListeners();
  }

  Future<void> installModule(String id) async {
    if (!_installedModuleIds.contains(id)) {
      _installedModuleIds.add(id);
      await _prefs?.setStringList(_prefKey, _installedModuleIds);
      notifyListeners();
    }
  }

  Future<void> uninstallModule(String id) async {
    if (_installedModuleIds.contains(id)) {
      _installedModuleIds.remove(id);
      await _prefs?.setStringList(_prefKey, _installedModuleIds);
      notifyListeners();
    }
  }

  bool isInstalled(String id) {
    return _installedModuleIds.contains(id);
  }
}
