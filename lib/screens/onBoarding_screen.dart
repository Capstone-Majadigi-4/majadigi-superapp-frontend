import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:majadigi_superapp_frontend/screens/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<int> _selectedCategories = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage < 2) {
      if (_currentPage == 1 && _selectedCategories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal 1 kategori untuk melanjutkan'),
            backgroundColor: Color(0xFFE11D48),
          ),
        );
        return;
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    final List<String> moduleIds = [];
    for (final catId in _selectedCategories) {
      switch (catId) {
        case 0: // Kesehatan
          moduleIds.add('rsud');
          moduleIds.add('tbc');
          break;
        case 1: // Transportasi
          moduleIds.add('transjatim');
          break;
        case 2: // Pajak & Administrasi
          moduleIds.add('bapenda');
          moduleIds.add('siskaperbapo');
          break;
        case 3: // Bantuan Sosial
          moduleIds.add('sapabansos');
          break;
        case 4: // Pariwisata & Budaya
          moduleIds.add('wisata');
          moduleIds.add('islamic_center');
          break;
        case 5: // Lowongan Kerja
          moduleIds.add('sinaker');
          break;
      }
    }

    if (mounted) {
      await Provider.of<ModuleProvider>(context, listen: false)
          .setInitialModulesFromOnboarding(moduleIds);
    }

    try {
      await Permission.location.request();
    } catch (e) {
      debugPrint("Error requesting location: $e");
    }

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B82F6), // Light Blue
              Color(0xFF1D4ED8), // Deep Blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Bubbles
            Positioned(
              top: 50, left: -80,
              child: _buildBubble(320, Colors.white.withOpacity(0.12)),
            ),
            Positioned(
              top: 300, right: -50,
              child: _buildBubble(280, Colors.white.withOpacity(0.08)),
            ),
            Positioned(
              bottom: 150, left: 20,
              child: _buildBubble(120, Colors.white.withOpacity(0.06)),
            ),
            Positioned(
              bottom: -100, right: 40,
              child: _buildBubble(400, Colors.white.withOpacity(0.15)),
            ),
            Positioned(
              top: -100, right: 100,
              child: _buildBubble(200, Colors.white.withOpacity(0.05)),
            ),

            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        _buildWelcomePage(),
                        _buildCategoryPage(),
                        _buildLocationPage(),
                      ],
                    ),
                  ),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.white38,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0065FF),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == 2 ? 'Izinkan Akses lokasimu' : 'Selanjutnya',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            if (_currentPage != 2) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Text(
          'Selamat datang di\nMajadigi!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Platform layanan publik Jawa Timur. Simple, cerdas, dan terhubung sepenuhnya.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/images/elemen,logo.png',
          width: MediaQuery.of(context).size.width * 0.85,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.white, size: 200),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildCategoryPage() {
    final categories = [
      {'id': 0, 'title': 'Kesehatan', 'desc': 'RSUD, Skrining TBC,\nlayanan medis', 'emoji': '🏥', 'color': const Color(0xFFEF4444)},
      {'id': 1, 'title': 'Transportasi', 'desc': 'TransJatim, rute bus,\njadwal', 'emoji': '🚌', 'color': const Color(0xFF3B82F6)},
      {'id': 2, 'title': 'Pajak & Administrasi', 'desc': 'Bapenda, PBB, PKB,\nBPHTB', 'emoji': '💰', 'color': const Color(0xFF10B981)},
      {'id': 3, 'title': 'Bantuan Sosial', 'desc': 'Info bansos, PKH,\nBPNT, subsidi', 'emoji': '💝', 'color': const Color(0xFFEC4899)},
      {'id': 4, 'title': 'Pariwisata & Budaya', 'desc': 'Destinasi wisata, event,\nbudaya', 'emoji': '🏖️', 'color': const Color(0xFF8B5CF6)},
      {'id': 5, 'title': 'Lowongan Kerja', 'desc': 'Sinaker, info kerja,\nkarir', 'emoji': '💼', 'color': const Color(0xFFF59E0B)},
    ];

    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Pilih layanan yang\npaling Anda butuhkan',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Pilih minimal 1 kategori. Dashboard Anda akan disesuaikan berdasarkan pilihan ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategories.clear();
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${_selectedCategories.length} dipilih ',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: List.generate(6, (index) {
                      final isSelected = _selectedCategories.contains(index);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.white : Colors.white24,
                        ),
                      );
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategories.contains(cat['id']);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCategories.remove(cat['id']);
                    } else {
                      _selectedCategories.add(cat['id'] as int);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFE11D48) : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: (cat['color'] as Color).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat['emoji'] as String,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            cat['title'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat['desc'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? const Color(0xFFE11D48).withOpacity(0.8) : const Color(0xFF64748B),
                              fontFamily: 'Inter',
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Color(0xFFE11D48),
                            child: Icon(Icons.check, size: 10, color: Colors.white),
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
    );
  }

  Widget _buildLocationPage() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Izinkan\nAkses Lokasimu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Untuk memberikan pengalaman Majadigi yang lebih baik, izinkan kami untuk mengakses lokasimu',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'Inter',
              height: 1.4,
            ),
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/images/lokasi.png',
          width: MediaQuery.of(context).size.width * 0.85,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.location_on, color: Colors.white, size: 200),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              _buildChecklistItem('Layanan terdekat dari posisi Anda'),
              const SizedBox(height: 12),
              _buildChecklistItem('Harga bahan pokok di area Anda'),
              const SizedBox(height: 12),
              _buildChecklistItem('Fasilitas kesehatan terdekat'),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildChecklistItem(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 1.5),
          ),
          child: const Icon(
            Icons.check,
            size: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [color, color.withOpacity(0)],
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }
}
