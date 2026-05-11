import 'package:flutter/material.dart';
import 'islamic_center_ticket_detail_screen.dart';

class IslamicCenterRegistrationSuccessScreen extends StatelessWidget {
  final String roomName;
  final String date;
  final String bookingId;

  const IslamicCenterRegistrationSuccessScreen({
    super.key,
    required this.roomName,
    required this.date,
    this.bookingId = 'IC-BK-2024001',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF),
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            left: -150,
            top: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: -100,
            bottom: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Success Icon & Message
                _buildSuccessHeader(),
                
                const SizedBox(height: 40),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail Pendaftaran',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          _buildDetailCard(),
                          
                          const SizedBox(height: 32),
                          
                          _buildInfoSection(
                            icon: Icons.info_outline,
                            title: 'Apa Selanjutnya?',
                            description: 'E-Tiket Anda telah diterbitkan. Anda dapat menunjukkannya kepada petugas saat hari pelaksanaan acara.',
                          ),
                          
                          const SizedBox(height: 60),
                          
                          _buildPrimaryButton(context),
                          const SizedBox(height: 16),
                          _buildSecondaryButton(context),
                          
                          const SizedBox(height: 40),
                        ],
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

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 80,
            color: Color(0xFF10B981),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Pendaftaran Berhasil!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ID Booking: $bookingId',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildDetailRow('Layanan', 'Booking Ruangan Islamic Center'),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          _buildDetailRow('Ruangan', roomName),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          _buildDetailRow('Tanggal', date),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          _buildDetailRow('Status Pembayaran', 'Berhasil', valueColor: const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0065FF)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IslamicCenterTicketDetailScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0065FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text(
          'Lihat Tiket Saya',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF0065FF),
          side: const BorderSide(color: Color(0xFF0065FF)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Kembali ke Beranda',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}
