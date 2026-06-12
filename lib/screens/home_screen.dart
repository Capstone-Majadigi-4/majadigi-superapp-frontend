import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Screens
import 'package:majadigi_superapp_frontend/screens/bapenda_screen.dart';
import 'package:majadigi_superapp_frontend/screens/profile_screen.dart';
import 'package:majadigi_superapp_frontend/screens/transjatim_screen.dart';

// Provider & Models
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/providers/dashboard_provider.dart';
import 'package:majadigi_superapp_frontend/providers/darurat_provider.dart';
import 'package:majadigi_superapp_frontend/models/service_module.dart';
import 'package:majadigi_superapp_frontend/screens/module_center_screen.dart';
import 'package:majadigi_superapp_frontend/screens/module_welcome_screen.dart';
import 'package:majadigi_superapp_frontend/widgets/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // STATE: Menyimpan tab mana yang sedang aktif
  // 0 = Favorit, 1 = Semua Layanan, 2 = Nawa Bhakti
  int _selectedTabIndex = 0; 

  // Bottom Navigation Index (0 = Home, 1 = Layanan, 2 = Favorit, 3 = Profile)
  int _bottomNavIndex = 0;

  // Slider Banner
  Timer? _bannerTimer;
  final PageController _bannerPageController = PageController();
  int _currentBannerPage = 0;
  bool _hasNotificationBadge = true;
  String _selectedRegion = 'Jawa Timur';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchBapokTicker();
      context.read<AuthProvider>().fetchUserProfile();
      context.read<ModuleProvider>().reload();
    });

    // Auto-play timer for sliding banner
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients) {
        final nextPage = (_currentBannerPage + 1) % 3;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  } 

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }


  // ===================== LOGIKA DARURAT (SOS) =====================
  Future<void> _handleEmergencyCall(BuildContext context, String title, String number) async {
    PermissionStatus status = await Permission.location.request();
    Position? position;
    
    if (status.isGranted) {
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        debugPrint("Error getting location: $e");
      }
    }

    String userNik = "3578000000000001"; 
    String gpsCoords = position != null ? "${position.latitude},${position.longitude}" : "Unknown";
    debugPrint("EMERGENCY PAYLOAD SENT: NIK: $userNik, LOC: $gpsCoords, TO: $title ($number)");

    // Call DaruratProvider API integration
    if (context.mounted) {
      context.read<DaruratProvider>().triggerPanicButton(title, number, gpsCoords);
    }

    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat melakukan panggilan ke $number')),
        );
      }
    }
  }

  void _showEmergencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.only(bottom: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Layanan Darurat Majadigi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE11D48),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const Text(
              'Pilih kategori bantuan yang Anda butuhkan.\nLokasi Anda akan dikirimkan otomatis.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildEmergencyCategory(context, '112 Pusat', '🆘', '112', const Color(0xFFFFE4E6)),
                  _buildEmergencyCategory(context, '110 Polisi', '👮', '110', const Color(0xFFDBEAFE)),
                  _buildEmergencyCategory(context, '119 Medis', '🚑', '119', const Color(0xFFDCFCE7)),
                  _buildEmergencyCategory(context, '113 Damkar', '🚒', '113', const Color(0xFFFFEDD4)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCategory(BuildContext context, String title, String emoji, String number, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _handleEmergencyCall(context, title, number);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== LOGIKA PENGELOMPOKAN KATEGORI =====================
  Map<String, List<ServiceModule>> _groupModulesByCategory(List<ServiceModule> modules) {
    final Map<String, List<ServiceModule>> grouped = {};
    for (var m in modules) {
      if (!grouped.containsKey(m.category)) {
        grouped[m.category] = [];
      }
      grouped[m.category]!.add(m);
    }
    return grouped;
  }

  String? _getModuleTransitionImage(String moduleId) {
    const Map<String, String> images = {
      'bapenda': 'assets/images/Bapenda/gambar bapenda.png',
      'sinaker': 'assets/images/SINAKER/Gambar SINAKER.png',
      'rsud': 'assets/images/RSUD saiful/gambar RSUD saiful anwar.png',
      'emergency': 'assets/images/Npmer darurat/Foto Nomer darurat.png',
      'tbc': 'assets/images/SKRINING/Manfaat skring tbc1.png',
      'sapabansos': 'assets/images/sapa bansos/gambar sapa bansos.png',
      'wisata': 'assets/images/destinasi wisata/Gambar wisata bromo.png',
      'islamic_center': 'assets/images/islamic/Islamic.png',
      'siskaperbapo': 'assets/images/bahan pokok/gambar siskaperbapo.png',
    };
    return images[moduleId];
  }

  // ===================== LOGIKA PREVIEW LAYANAN =====================
  void _showModulePreviewDialog(BuildContext context, ServiceModule module) {
    bool isDownloading = false;
    double progress = 0.0;
    String downloadText = 'Menyiapkan unduhan...';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white38, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(module.emoji, style: const TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      module.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(module.emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 12),
                        const Text(
                          'Fitur Layanan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF101828),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...module.features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 16),
                    // Tips Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Color(0xFF3B82F6), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tips: Pastikan koneksi internet Anda stabil untuk pengalaman terbaik',
                              style: TextStyle(
                                color: Color(0xFF1E40AF),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    Consumer<ModuleProvider>(
                      builder: (context, provider, child) {
                        return StatefulBuilder(
                          builder: (context, setDialogState) {
                            final isInstalled = provider.isInstalled(module.id);
                            
                            if (isInstalled) {
                              return SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    final transitionImage = _getModuleTransitionImage(module.id);
                                    if (transitionImage != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ModuleWelcomeScreen(
                                            module: module,
                                            imagePath: transitionImage,
                                          ),
                                          settings: RouteSettings(name: '/${module.id}/welcome'),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => module.destinationScreen,
                                          settings: RouteSettings(name: '/${module.id}'),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0085FF),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Lanjutkan ke ${module.title}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                            
                            if (isDownloading) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: const Color(0xFFE2E8F0),
                                      color: const Color(0xFF0085FF),
                                      minHeight: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        downloadText,
                                        style: const TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${(progress * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Color(0xFF0085FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  setDialogState(() {
                                    isDownloading = true;
                                    progress = 0.0;
                                    downloadText = 'Mengunduh data...';
                                  });
                                  
                                  Timer.periodic(const Duration(milliseconds: 150), (timer) {
                                    if (!context.mounted) {
                                      timer.cancel();
                                      return;
                                    }
                                    
                                    setDialogState(() {
                                      progress += 0.08;
                                      if (progress >= 0.4 && progress < 0.8) {
                                        downloadText = 'Menginstal modul...';
                                      } else if (progress >= 0.8 && progress < 1.0) {
                                        downloadText = 'Menyelesaikan pemasangan...';
                                      }
                                      
                                      if (progress >= 1.0) {
                                        progress = 1.0;
                                        isDownloading = false;
                                        timer.cancel();
                                        provider.installModule(module.id);
                                      }
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.download_rounded, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Unduh Layanan (${module.title})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== WIDGET UTAMA =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      extendBody: true, 
      
      // Floating Action Button (Mascot / Smart Widget / SOS)
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _showEmergencyBottomSheet(context),
        backgroundColor: const Color(0xFFE11D48),
        shape: const CircleBorder(),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            'assets/images/mascot.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.smart_toy, color: Colors.white, size: 36),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 20,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kiri
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomNavItem(Icons.home_outlined, 'Home', _bottomNavIndex == 0, 0),
                    _buildBottomNavItem(Icons.grid_view_rounded, 'Layanan', _bottomNavIndex == 1, 1),
                  ],
                ),
              ),
              const SizedBox(width: 48), // Ruang untuk FAB
              // Kanan
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomNavItem(Icons.bookmark_border_rounded, 'Favorit', _bottomNavIndex == 2, 2),
                    _buildBottomNavItem(Icons.person_outline_rounded, 'Profile', _bottomNavIndex == 3, 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      body: IndexedStack(
        index: _bottomNavIndex,
        children: [
          SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // Header Biru Background
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3B82F6), // Biru Muda
                    Color(0xFF1D4ED8), // Biru Tua
                  ],
                ),
              ),
            ),
            
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 1. Profil & Notifikasi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        // Avatar Profil
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white54, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/header.png', // Placeholder foto profil
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Sapaan
                        Expanded(
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              if (auth.isLoading && auth.user == null) {
                                return const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.rectangular(height: 10, width: 80),
                                    SizedBox(height: 6),
                                    Shimmer.rectangular(height: 16, width: 140),
                                  ],
                                );
                              }
                              final user = auth.user;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat pagi',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    user?.nama ?? 'Pengunjung kelompok 4',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        // Notifikasi
                        GestureDetector(
                          onTap: () => _showNotificationBottomSheet(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                                if (_hasNotificationBadge)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.red, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white.withOpacity(0.7), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Cari layanan...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // 3. Floating Banner Layanan Terpadu (Slider/Carousel)
                  SizedBox(
                    height: 145,
                    child: PageView(
                      controller: _bannerPageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentBannerPage = index;
                        });
                      },
                      children: [
                        _buildBannerSlide(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0078FF), Color(0xFF0046B2)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          title: 'Layanan Terpadu',
                          subtitle: '10 Layanan',
                          desc: 'Untuk Masyarakat Jawa Timur',
                          icon: Icons.account_balance,
                          pageIndex: 0,
                        ),
                        _buildBannerSlide(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          title: 'Informasi Wisata',
                          subtitle: 'Destinasi Favorit',
                          desc: 'Jelajahi keindahan Jawa Timur',
                          icon: Icons.landscape,
                          pageIndex: 1,
                        ),
                        _buildBannerSlide(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          title: 'Darurat & Siaga',
                          subtitle: 'Hubungi Bantuan',
                          desc: 'Respon cepat darurat 24 jam',
                          icon: Icons.phone_in_talk,
                          pageIndex: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Smart Widget Notification (Pengingat Jatuh Tempo)
                  _buildSmartNotification(),

                  const SizedBox(height: 24),

                  // 4. Segmented Tab Bar (Dinamis dengan state)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 0),
                              child: _buildSegmentTab('Favorit', _selectedTabIndex == 0),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 1),
                              child: _buildSegmentTab('Semua Layanan', _selectedTabIndex == 1),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = 2),
                              child: _buildSegmentTab('Nawa Bhakti', _selectedTabIndex == 2),
                            ),
                          ),
                        ]
                      )
                    )
                  ),

                  const SizedBox(height: 24),

                  // 5. Area Konten Dinamis Berdasarkan Tab
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Consumer<ModuleProvider>(
                      builder: (context, provider, child) {
                        if (_selectedTabIndex == 0) {
                          return _buildFavoritContent(provider);
                        } else if (_selectedTabIndex == 1) {
                          return _buildSemuaLayananContent(provider);
                        } else {
                          return _buildNawaBhaktiContent();
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 6. Bottom Image Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/onboarding_banner.png',
                        width: double.infinity,
                        height: 250, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Text('Banner Image Missing'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 7. Slicer & Info Tambahan
                  _buildJatimDalamAngka(),
                  const SizedBox(height: 16),
                  _buildLayananDaerah(),
                  const SizedBox(height: 16),
                  _buildAgendaJatim(),
                  const SizedBox(height: 16),
                  _buildBeritaJatim(),
                  const SizedBox(height: 16),
                  _buildPerkiraanCuaca(),

                  const SizedBox(height: 120), // Extra space for FAB and Navbar
                ],
              ),
            ),
          ],
        ),
      ),
          const ModuleCenterScreen(showBackButton: false),
          _buildFavoritTabContent(),
          const ProfileScreen(showBackButton: false),
        ],
      ),
    );
  }

  // ===================== WIDGET SECTION BAWAH (INFO JATIM) =====================

  Widget _buildSectionHeader(String title, IconData icon, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFE11D48), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                fontFamily: 'Inter',
              ),
            ),
          ),
          if (showSeeAll)
            const Text(
              'Lihat semua',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
        ],
      ),
    );
  }

  // 1. Jawa Timur Dalam Angka
  Widget _buildJatimDalamAngka() {
    return Column(
      children: [
        _buildSectionHeader('Jawa Timur Dalam Angka', Icons.show_chart),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildStatCard(
                Icons.people_outline,
                'Jumlah Penduduk',
                '42.089.271',
                const Color(0xFF3B82F6),
                'Data Badan Pusat Statistik (BPS) Provinsi Jawa Timur menunjukkan total populasi mencapai 42+ juta jiwa yang tersebar di 29 Kabupaten dan 9 Kota.',
              ),
              _buildStatCard(
                Icons.trending_up,
                'Pertumbuhan Penduduk',
                '0,73 %',
                const Color(0xFF3B82F6),
                'Rasio pertumbuhan penduduk tahunan Jawa Timur tercatat stabil di kisaran 0.73% per tahun dengan tingkat persebaran terpadat di wilayah perkotaan.',
              ),
              _buildStatCard(
                Icons.account_balance_wallet_outlined,
                'Penduduk Miskin',
                '9,56 %',
                const Color(0xFF3B82F6),
                'Persentase tingkat kemiskinan di Jawa Timur mengalami tren penurunan berkat realisasi berbagai program bantuan sosial daerah (seperti Sapa Bansos).',
              ),
              _buildStatCard(
                Icons.work_outline,
                'Pengangguran Terbuka',
                '3,59 %',
                const Color(0xFF3B82F6),
                'Tingkat Pengangguran Terbuka (TPT) berada di angka 3.59%, didorong oleh pembukaan lapangan kerja baru melalui platform ketenagakerjaan daerah (Sinaker).',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, Color iconColor, String desc) {
    return GestureDetector(
      onTap: () => _showStatDetailDialog(context, title, value, desc),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontFamily: 'Inter'),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Inter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getSelectedRegionMap() {
    switch (_selectedRegion) {
      case 'Kabupaten Banyuwangi':
        return 'assets/images/map_banyuwangi.png';
      case 'Kabupaten Tuban':
        return 'assets/images/map_tuban.png';
      case 'Kota Surabaya':
        return 'assets/images/map_surabaya.png';
      case 'Kabupaten Lamongan':
        return 'assets/images/map_lamongan.png';
      case 'Kabupaten Tulungagung':
        return 'assets/images/map_tulungagung.png';
      case 'Jawa Timur':
      default:
        return 'assets/images/map_jatim.png';
    }
  }

  // 2. Layanan Daerah
  Widget _buildLayananDaerah() {
    return Column(
      children: [
        _buildSectionHeader('Layanan Daerah', Icons.map_outlined, showSeeAll: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildRegionChip('Jawa Timur', _selectedRegion == 'Jawa Timur'),
              _buildRegionChip('Kabupaten Banyuwangi', _selectedRegion == 'Kabupaten Banyuwangi'),
              _buildRegionChip('Kabupaten Tuban', _selectedRegion == 'Kabupaten Tuban'),
              _buildRegionChip('Kota Surabaya', _selectedRegion == 'Kota Surabaya'),
              _buildRegionChip('Kabupaten Lamongan', _selectedRegion == 'Kabupaten Lamongan'),
              _buildRegionChip('Kabupaten Tulungagung', _selectedRegion == 'Kabupaten Tulungagung'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransjatimScreen()),
              );
            },
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset(
                      _getSelectedRegionMap(),
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.green.shade50,
                        child: Center(
                          child: Icon(Icons.map_outlined, size: 50, color: Colors.green.shade400),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedRegion == 'Jawa Timur'
                                ? 'Peta Koridor TransJatim'
                                : 'Peta Koridor ${_selectedRegion.replaceAll("Kabupaten ", "").replaceAll("Kota ", "")}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ketuk untuk melacak bus & rute halte',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRegion = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE11D48) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: isSelected ? const Color(0xFFE11D48) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // 3. Agenda Jawa Timur
  Widget _buildAgendaJatim() {
    return Column(
      children: [
        _buildSectionHeader('Agenda Jawa Timur', Icons.calendar_today_outlined, showSeeAll: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
              ]
            ),
            child: Column(
              children: [
                _buildAgendaItem(
                  'Kamis, 01 Januari',
                  '00:30 - 12:00',
                  'BAHANA BERSAHAJA',
                  'Kabupaten Madiun',
                  'Gelar budaya tahunan Kabupaten Madiun yang menampilkan parade tari tradisional, pameran UMKM lokal unggulan, dan pertunjukan wayang kulit semalam suntuk di Alun-Alun Reksogati.',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildAgendaItem(
                  'Rabu, 01 April 2026',
                  '00:30 - 12:00',
                  'Upacara Adat Labuh Laut Pantai Sine',
                  'Kabupaten Tulungagung',
                  'Upacara adat tahunan melarung sesaji ke laut sebagai bentuk rasa syukur nelayan Pantai Sine atas limpahan hasil laut dan memohon keselamatan dalam melaut.',
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                _buildAgendaItem(
                  'Rabu, 01 April 2026',
                  '00:30 - 12:00',
                  'Gelar Kesenian dan Pameran Produk Ek...',
                  'Kabupaten Tulungagung',
                  'Eksibisi seni pertunjukan khas Tulungagung (Reog Kendang) dipadukan dengan bazar produk kerajinan batu marmer ekspor unggulan daerah di GOR Jayabaya.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaItem(String date, String time, String title, String location, String detail) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Inter')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontFamily: 'Inter')),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontFamily: 'Inter')),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFFE11D48)),
                    const SizedBox(width: 6),
                    Text(location, style: const TextStyle(fontSize: 11, color: Color(0xFFE11D48), fontFamily: 'Inter')),
                  ],
                ),
                const SizedBox(height: 16),
                Text(detail, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5, fontFamily: 'Inter')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontFamily: 'Inter')),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time, size: 12, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontFamily: 'Inter')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B), fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(location, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Inter')),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance, color: Color(0xFF94A3B8)),
            )
          ],
        ),
      ),
    );
  }

  // 4. Berita Jawa Timur
  Widget _buildBeritaJatim() {
    return Column(
      children: [
        _buildSectionHeader('Berita Jawa Timur', Icons.article_outlined, showSeeAll: true),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildBeritaCard(
                'assets/images/header.png',
                'Sabtu, 04 Apr 2026',
                'PJT Perketat Pengamanan Bendungan Karangkates',
                'Perum Jasa Tirta (PJT) I memperketat pengamanan di sekitar Bendungan Karangkates, Malang. Langkah ini diambil untuk memastikan keamanan infrastruktur strategis nasional dari potensi gangguan, serta memonitor debit air pasca tingginya curah hujan di wilayah hulu Sungai Brantas dalam beberapa pekan terakhir.',
              ), 
              _buildBeritaCard(
                'assets/images/header.png',
                'Jumat, 03 Apr 2026',
                'TransJatim Tambah Armada Bus Koridor Baru',
                'Pemerintah Pemprov Jawa Timur berencana meluncurkan tambahan 10 armada bus baru untuk koridor penghubung Surabaya-Gresik guna mengurangi waktu tunggu penumpang di halte utama. Penambahan armada ini juga dibarengi dengan integrasi GPS real-time yang lebih presisi ke aplikasi Majadigi.',
              ),
              _buildBeritaCard(
                'assets/images/header.png',
                'Kamis, 02 Apr 2026',
                'Bapenda Jatim Gelar Pemutihan Pajak PBB',
                'Badan Pendapatan Daerah (Bapenda) kembali menyelenggarakan program pemutihan denda pajak kendaraan bermotor (PKB) dan pajak bumi bangunan (PBB). Wajib pajak dihimbau untuk memanfaatkan momen ini melalui pembayaran online terintegrasi via e-samsat di aplikasi Majadigi.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBeritaCard(String imgPath, String date, String title, String summary) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Inter'),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imgPath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      height: 120,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 10, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Inter'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  summary,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5, fontFamily: 'Inter'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imgPath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  height: 100, 
                  color: Colors.grey.shade100, 
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 10, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontFamily: 'Inter')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Inter'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Perkiraan Cuaca
  Widget _buildPerkiraanCuaca() {
    return Column(
      children: [
        _buildSectionHeader('Perkiraan Cuaca\nJawa Timur', Icons.cloud_outlined, showSeeAll: true),
        SizedBox(
          height: 125,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCuacaCard('Kota Surabaya', '32°C', 'Cerah'),
              _buildCuacaCard('Kota Malang', '26°C', 'Berawan'),
              _buildCuacaCard('Kota Batu', '22°C', 'Hujan'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCuacaCard(String city, String temp, String condition) {
    IconData weatherIcon = Icons.cloud;
    Color iconColor = const Color(0xFF7DD3FC);
    
    if (condition == 'Cerah') {
      weatherIcon = Icons.wb_sunny_rounded;
      iconColor = const Color(0xFFF59E0B);
    } else if (condition == 'Hujan') {
      weatherIcon = Icons.umbrella_rounded;
      iconColor = const Color(0xFF3B82F6);
    }

    return GestureDetector(
      onTap: () => _showWeatherDetailBottomSheet(context, city, temp, condition),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city, 
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Inter'), 
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Icon(weatherIcon, size: 28, color: iconColor), 
            const SizedBox(height: 6),
            Text(
              temp,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Inter'),
            ),
            const SizedBox(height: 2),
            Text(
              condition,
              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== KONTEN TAB 0: FAVORIT =====================
  Widget _buildFavoritContent(ModuleProvider provider) {
    final favoriteModules = provider.favoriteModules;
    
    if (favoriteModules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: const Text(
          'Dashboard Masih Kosong\nTambahkan layanan melalui menu Semua Layanan.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
        mainAxisSpacing: 24,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75, 
      ),
      itemCount: favoriteModules.length + 1, // +1 for the Add button
      itemBuilder: (context, index) {
        if (index < favoriteModules.length) {
          final module = favoriteModules[index];
          return GestureDetector(
            onTap: () {
              _showModulePreviewDialog(context, module);
            },
            child: _buildServiceItem(module.title, module.emoji, module.bgColor),
          );
        } else {
          // Add Module Button yang mengarah ke tab Semua Layanan
          return GestureDetector(
            onTap: () {
              setState(() => _selectedTabIndex = 1); // Pindah ke Semua Layanan
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.add, color: Color(0xFF64748B), size: 28),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tambah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // ===================== KONTEN TAB 1: SEMUA LAYANAN =====================
  Widget _buildSemuaLayananContent(ModuleProvider provider) {
    final groupedModules = _groupModulesByCategory(provider.availableModules);
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedModules.keys.length,
      itemBuilder: (context, index) {
        String category = groupedModules.keys.elementAt(index);
        List<ServiceModule> modules = groupedModules[category]!;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ExpansionTile(
              initiallyExpanded: index == 0, // Kategori pertama terbuka otomatis
              shape: const Border(),
              iconColor: const Color(0xFF0065FF),
              title: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF101828),
                  fontFamily: 'Inter',
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.95, // Rasio kartu (lebar/tinggi)
                    ),
                    itemCount: modules.length,
                    itemBuilder: (context, idx) {
                      final module = modules[idx];
                      final isFavorite = provider.isFavorite(module.id);
                      
                      return GestureDetector(
                        onTap: () {
                          _showModulePreviewDialog(context, module);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon Layanan
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: module.bgColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(module.emoji, style: const TextStyle(fontSize: 24)),
                                  ),
                                  const Spacer(),
                                  // Title
                                  Text(
                                    module.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF101828),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Subtitle / Kategori
                                  Text(
                                    module.category,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              // Tombol Star (Favorit)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: GestureDetector(
                                  onTap: () {
                                    provider.toggleFavorite(module.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: isFavorite ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===================== KONTEN TAB 2: NAWA BHAKTI =====================
  Widget _buildNawaBhaktiContent() {
    return Column(
      children: [
        // Header Card Nawa Bhakti Satya
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nawa Bhakti Satya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '9 Program Unggulan',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Program Gubernur Jawa Timur untuk kesejahteraan masyarakat.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),

        // List Program Nawa Bhakti
        _buildNawaBhaktiItem('1', 'Jatim Sejahtera', 'Program perlindungan sosial'),
        _buildNawaBhaktiItem('2', 'Jatim Kerja', 'Pengurangan pengangguran'),
        _buildNawaBhaktiItem('3', 'Jatim Cerdas & Sehat', 'Pendidikan dan kesehatan'),
        _buildNawaBhaktiItem('4', 'Jatim Akses', 'Infrastruktur dan transportasi'),
        _buildNawaBhaktiItem('5', 'Jatim Berkah', 'Kesejahteraan keagamaan'),
        _buildNawaBhaktiItem('6', 'Jatim Amanah', 'Tata kelola pemerintahan bersih'),
      ],
    );
  }

  Widget _buildNawaBhaktiItem(String number, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Number Circle
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF1D4ED8),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF101828),
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Arrow Icon
          Icon(Icons.chevron_right, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildBannerSlide({
    required Gradient gradient,
    required String title,
    required String subtitle,
    required String desc,
    required IconData icon,
    required int pageIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (gradient as LinearGradient).colors.last.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  Row(
                    children: List.generate(3, (dotIndex) {
                      final isActive = dotIndex == pageIndex;
                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: isActive ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  )
                ]
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, color: Colors.white, size: 70) 
          ]
        )
      ),
    );
  }

  Widget _buildSmartNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tax Warning
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2), 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.warning_rounded, color: Color(0xFFEF4444)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jatuh Tempo Pajak',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF991B1B),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pajak PBB Anda (NOP: 3573...) akan jatuh tempo dalam 3 hari. Segera lakukan pembayaran.',
                        style: TextStyle(
                          color: Color(0xFF7F1D1D),
                          fontSize: 12,
                          height: 1.4,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          // Arahkan langsung ke Bapenda Screen
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const BapendaScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {}, // Close alert placeholder
                  child: const Icon(Icons.close, size: 16, color: Color(0xFF991B1B)),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Bapok Ticker Smart Widget (Fase 2)
        Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Shimmer.circular(width: 20, height: 20),
                          const SizedBox(width: 8),
                          const Shimmer.rectangular(height: 12, width: 140),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) => Shimmer.rounded(height: 60, width: 90, borderRadius: 12)),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (provider.tickerData.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.trending_up_rounded, color: Color(0xFF2563EB), size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Harga Komoditas (Bapok)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.tickerData.length,
                        itemBuilder: (context, index) {
                          final item = provider.tickerData[index];
                          final isUp = (item.perubahanPersen ?? 0) >= 0;
                          
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.nama,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp${item.hargaRataRata.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                          color: isUp ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                                          size: 8,
                                        ),
                                        Text(
                                          '${item.perubahanPersen?.abs()}%',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: isUp ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSegmentTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF155DFC) : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF6A7282),
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          fontSize: 12,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildServiceItem(String label, String emoji, Color bgColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive, int index) {
    final color = isActive ? const Color(0xFF0065FF) : const Color(0xFF64748B);
    return MaterialButton(
      minWidth: 40,
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritTabContent() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0065FF),
        title: const Text(
          'Layanan Favorit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ModuleProvider>(
        builder: (context, provider, child) {
          final favoriteModules = provider.favoriteModules;
          if (favoriteModules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Layanan Favorit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unduh & tambahkan layanan ke favorit Anda.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bottomNavIndex = 1; // Pindah ke Layanan (App Center)
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0065FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cari Layanan'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.85,
            ),
            itemCount: favoriteModules.length,
            itemBuilder: (context, index) {
              final module = favoriteModules[index];
              return GestureDetector(
                onTap: () {
                  _showModulePreviewDialog(context, module);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: module.bgColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          module.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          module.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Inter',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showNotificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (_hasNotificationBadge)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _hasNotificationBadge = false;
                              });
                              setSheetState(() {});
                            },
                            icon: const Icon(Icons.done_all, size: 16, color: Color(0xFF0065FF)),
                            label: const Text(
                              'Tandai Semua Dibaca',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0065FF),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildNotificationCard(
                          title: 'Jatuh Tempo Pajak',
                          message: 'Pajak PBB Anda (NOP: 3573...) akan jatuh tempo dalam 3 hari. Segera lakukan pembayaran.',
                          time: '3 menit yang lalu',
                          icon: Icons.warning_rounded,
                          iconColor: const Color(0xFFEF4444),
                          bgColor: const Color(0xFFFEF2F2),
                          borderColor: const Color(0xFFFECACA),
                          isUnread: _hasNotificationBadge,
                        ),
                        const SizedBox(height: 12),
                        _buildNotificationCard(
                          title: 'Antrean RSUD Dr Saiful Anwar',
                          message: 'Poli Anak - Nomor Antrean A-001. Silakan bersiap menuju ruang periksa.',
                          time: '1 jam yang lalu',
                          icon: Icons.notifications_active,
                          iconColor: const Color(0xFF0065FF),
                          bgColor: const Color(0xFFEFF6FF),
                          borderColor: const Color(0xFFBFDBFE),
                          isUnread: _hasNotificationBadge,
                        ),
                        const SizedBox(height: 12),
                        _buildNotificationCard(
                          title: 'Pendaftaran Kajian Berhasil',
                          message: 'Pendaftaran Kajian Akbar Ramadhan bersama Ustadz Dr. Ahmad Zainuddin telah dikonfirmasi.',
                          time: '2 jam yang lalu',
                          icon: Icons.event_available,
                          iconColor: const Color(0xFF8B5CF6),
                          bgColor: const Color(0xFFF5F3FF),
                          borderColor: const Color(0xFFDDD6FE),
                          isUnread: _hasNotificationBadge,
                        ),
                        const SizedBox(height: 12),
                        _buildNotificationCard(
                          title: 'E-Ticket Transjatim Aktif',
                          message: 'Pembelian tiket berhasil. Tiket Koridor I Anda siap digunakan.',
                          time: '1 hari yang lalu',
                          icon: Icons.directions_bus,
                          iconColor: const Color(0xFF10B981),
                          bgColor: const Color(0xFFECFDF5),
                          borderColor: const Color(0xFFA7F3D0),
                          isUnread: false,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isUnread ? borderColor : const Color(0xFFE2E8F0), width: isUnread ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isUnread ? const Color(0xFF0F172A) : const Color(0xFF475569),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0065FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: isUnread ? const Color(0xFF334155) : const Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWeatherDetailBottomSheet(BuildContext context, String city, String temp, String condition) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prakiraan Cuaca Hari Ini',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: condition == 'Cerah'
                        ? const Color(0xFFFFF7ED)
                        : condition == 'Hujan'
                            ? const Color(0xFFEFF6FF)
                            : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    condition,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: condition == 'Cerah'
                          ? const Color(0xFFC2410C)
                          : condition == 'Hujan'
                              ? const Color(0xFF1D4ED8)
                              : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeatherStatItem(Icons.thermostat, 'Suhu', temp),
                _buildWeatherStatItem(Icons.water_drop_outlined, 'Kelembaban', '65%'),
                _buildWeatherStatItem(Icons.air, 'Kecepatan Angin', '12 km/h'),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFF1F5F9), thickness: 1),
            const SizedBox(height: 16),
            const Text(
              'Prakiraan 3 Hari Ke Depan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E293B),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            _buildWeatherForecastRow('Besok', '27°C - 33°C', Icons.wb_sunny_rounded, const Color(0xFFF59E0B)),
            const SizedBox(height: 8),
            _buildWeatherForecastRow('Minggu', '25°C - 31°C', Icons.cloud, const Color(0xFF7DD3FC)),
            const SizedBox(height: 8),
            _buildWeatherForecastRow('Senin', '24°C - 30°C', Icons.umbrella_rounded, const Color(0xFF3B82F6)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0065FF), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Inter'),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Inter'),
        ),
      ],
    );
  }

  Widget _buildWeatherForecastRow(String day, String range, IconData icon, Color iconColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontFamily: 'Inter'),
        ),
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Text(
              range,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569), fontFamily: 'Inter'),
            ),
          ],
        ),
      ],
    );
  }

  void _showStatDetailDialog(BuildContext context, String title, String value, String desc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1E293B),
            fontFamily: 'Inter',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE11D48),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
