import 'package:flutter/material.dart';
import '../widgets/job_application_card.dart';
import '../widgets/job_recommendation_card.dart';
import '../widgets/sinaker_status_dialog.dart';

class SinakerJobsScreen extends StatelessWidget {
  const SinakerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0065FF), Color(0xFF155DFC)],
              ),
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
                        child: Center(
                          child: Text(
                            'SINAKER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_outline, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[400]),
                              const SizedBox(width: 12),
                              Text(
                                'Cari posisi atau perusahaan..',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF155DFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Lamaran Saya Section
                            _buildSectionHeader('Lamaran Saya'),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Column(
                                children: [
                                  const JobApplicationCard(
                                    title: 'Full Stack Developer',
                                    company: 'PT Digital Teknologi',
                                    date: '1 Apr 2025',
                                    status: 'Sedang Direview',
                                    statusColor: Color(0xFFECEEF2),
                                    statusTextColor: Color(0xFF030213),
                                  ),
                                  const SizedBox(height: 12),
                                  const JobApplicationCard(
                                    title: 'Backend Developer',
                                    company: 'PT Tech Inovasi',
                                    date: '28 Mar 2025',
                                    status: 'Panggilan Interview',
                                    statusColor: Color(0xFF155DFC),
                                    statusTextColor: Colors.white,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Lihat lainnya',
                                        style: TextStyle(
                                          color: Color(0xFF0065FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Rekomendasi Section
                            const Text(
                              'Rekomendasi untuk Anda',
                              style: TextStyle(
                                color: Color(0xFF0A0A0A),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            JobRecommendationCard(
                              title: 'Full Stack Developer',
                              company: 'PT Digital Teknologi',
                              match: '95%',
                              location: 'Surabaya',
                              salary: 'Rp 8.000.000 - 12.000.000',
                              type: 'Full Time',
                              posted: '2 hari lalu',
                              onApply: () {
                                showSinakerStatusDialog(
                                  context,
                                  status: SinakerStatus.sent,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            JobRecommendationCard(
                              title: 'UI/UX Designer',
                              company: 'CV Kreatif Indonesia',
                              match: '85%',
                              location: 'Malang',
                              salary: 'Rp 6.000.000 - 9.000.000',
                              type: 'Full Time',
                              posted: '1 minggu lalu',
                              onApply: () {
                                showSinakerStatusDialog(
                                  context,
                                  status: SinakerStatus.sent,
                                );
                              },
                            ),
                            const SizedBox(height: 80),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF0A0A0A),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
