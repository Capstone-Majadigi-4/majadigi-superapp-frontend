import 'package:flutter/material.dart';
import '../widgets/sapabansos_program_info_card.dart';

class SapabansosInfoProgramScreen extends StatelessWidget {
  const SapabansosInfoProgramScreen({super.key});

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
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informasi Program Bansos',
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
                            const SapabansosProgramInfoCard(
                              title: 'PKH (Program Keluarga Harapan)',
                              description: 'Bantuan sosial untuk lansia miskin sebagai tambahan dari PKH nasional',
                              totalFunds: 'Rp 26.875.000.000',
                              quota: '50.000 penerima',
                            ),
                            
                            const SizedBox(height: 16),
                            
                            const SapabansosProgramInfoCard(
                              title: 'ASPD',
                              description: 'Bantuan untuk penyandang disabilitas berat agar kebutuhan dasar terpenuhi',
                              totalFunds: 'Rp 20.000.000.000',
                              quota: '5.000 penerima',
                            ),
                            
                            const SizedBox(height: 16),
                            
                            const SapabansosProgramInfoCard(
                              title: 'KPM JAWARA',
                              description: 'Bantuan kewirausahaan bagi keluarga penerima manfaat agar mandiri secara ekonomi',
                              totalFunds: 'Rp 2.100.000.000',
                              quota: '700 penerima',
                            ),
                            
                            const SizedBox(height: 32),
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
