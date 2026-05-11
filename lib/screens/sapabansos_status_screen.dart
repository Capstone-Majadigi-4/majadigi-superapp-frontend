import 'package:flutter/material.dart';
import '../widgets/sapabansos_program_card.dart';
import '../widgets/sapabansos_info_section.dart';

class SapabansosStatusScreen extends StatelessWidget {
  const SapabansosStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0065FF),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -50,
                  top: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      "https://placehold.co/449x253",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'SAPABANSOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.04,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB), // Light grey background for content
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status Banner Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFB9F8CF),
                                  width: 1.33,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Status: Terdaftar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0D542B),
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      height: 1.40,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Anda terdaftar sebagai penerima bantuan sosial',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF008236),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            const Text(
                              'Program yang Anda Terima',
                              style: TextStyle(
                                color: Color(0xFF0A0A0A),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.56,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Program List
                            const SapabansosProgramCard(
                              title: 'PKH (Program Keluarga Harapan)',
                              status: 'Aktif',
                              nominal: 'Rp 3.000.000/tahun',
                              distributionDate: '15 Mei 2025',
                            ),
                            
                            const SizedBox(height: 16),
                            
                            const SapabansosProgramCard(
                              title: 'BPNT (Bantuan Pangan Non Tunai)',
                              status: 'Aktif',
                              nominal: 'Rp 200.000/bulan',
                              distributionDate: '10 April 2025',
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Important Info Section
                            const SapabansosInfoSection(
                              bulletPoints: [
                                'Pastikan data diri Anda selalu update',
                                'Hubungi Dinas Sosial jika ada perubahan data',
                                'Penyaluran akan dilakukan sesuai jadwal',
                              ],
                            ),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
