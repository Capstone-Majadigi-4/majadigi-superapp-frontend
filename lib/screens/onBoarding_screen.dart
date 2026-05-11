import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4285F4),
              Color(0xFF2B5CC4),
              Color(0xFF1A3A8A),
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

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  // 1. Bagian Atas: Logo dan Teks yang mengisi sisa ruang
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Gambar dengan bounding box besar
                        Image.asset(
                          'assets/images/elemen,logo.png',
                          width: MediaQuery.of(context).size.width * 1.0,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.white, size: 200),
                        ),
                        
                        // Teks dipusatkan di tengah gambar, lalu digeser ke bawah
                        Transform.translate(
                          offset: const Offset(0, 120), // Sesuaikan angka ini (misal 100-150) agar teks pas di bawah jaring-jaring
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Penting agar Column tidak mengambil sisa ruang vertikal penuh
                            children: [
                              const Text(
                                'Majadigi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  'Platform layanan publik Jawa Timur.\nSimple. Cerdas.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 2. Bagian Bawah: Tombol Mulai dan Login (Akan selalu tertahan di bawah layar)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDF2F8),
                          foregroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black45,
                        ),
                        child: const Text(
                          'Mulai',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'I already have an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0065FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Ruang kosong di dasar layar agar tidak terlalu mepet
                ],
              ),
            ),
          ],
        ),
      ),
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
