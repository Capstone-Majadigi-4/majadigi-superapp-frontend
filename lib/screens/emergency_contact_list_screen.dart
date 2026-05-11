import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactListScreen extends StatelessWidget {
  const EmergencyContactListScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Could not launch phone dialer
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF), // Primary-Colors
      body: Stack(
        children: [
          // Header Background / Image Placeholder
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 253,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://placehold.co/449x253/0065FF/FFFFFF?text=Nomor+Darurat"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Nomor Darurat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Content Area
          Positioned.fill(
            top: 185,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Warning Banner
                    _buildWarningBanner(),
                    const SizedBox(height: 24),

                    // List of Emergency Cards
                    _buildEmergencyCard(
                      title: 'Call Center 112',
                      subtitle: 'Layanan Darurat Terpadu Jawa Timur',
                      number: '112',
                      onTap: () => _makePhoneCall('112'),
                    ),
                    const SizedBox(height: 12),
                    _buildEmergencyCard(
                      title: 'Polisi',
                      subtitle: 'Kepolisian Negara RI',
                      number: '110',
                      onTap: () => _makePhoneCall('110'),
                    ),
                    const SizedBox(height: 12),
                    _buildEmergencyCard(
                      title: 'Ambulans/Medis',
                      subtitle: 'Layanan Kesehatan Darurat',
                      number: '119',
                      onTap: () => _makePhoneCall('119'),
                    ),
                    const SizedBox(height: 12),
                    _buildEmergencyCard(
                      title: 'Pemadam Kebakaran',
                      subtitle: 'Dinas Pemadam Kebakaran',
                      number: '113',
                      onTap: () => _makePhoneCall('113'),
                    ),
                    const SizedBox(height: 12),
                    _buildEmergencyCard(
                      title: 'SAR',
                      subtitle: 'Search and Rescue Indonesia',
                      number: '115',
                      onTap: () => _makePhoneCall('115'),
                    ),
                    const SizedBox(height: 12),
                    _buildEmergencyCard(
                      title: 'PLN',
                      subtitle: 'Gangguan Listrik',
                      number: '123',
                      onTap: () => _makePhoneCall('123'),
                    ),
                    const SizedBox(height: 12),
                    _buildEmergencyCard(
                      title: 'PDAM',
                      subtitle: 'Gangguan Air PDAM',
                      number: '1500651',
                      onTap: () => _makePhoneCall('1500651'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFFEFCE8),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.33, color: Color(0xFFFFF085)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        '⚠️ Gunakan nomor darurat hanya untuk situasi gawat darurat',
        style: TextStyle(
          color: Color(0xFF733E0A),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 1.43,
        ),
      ),
    );
  }

  Widget _buildEmergencyCard({
    required String title,
    required String subtitle,
    required String number,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.33,
            color: Colors.black.withOpacity(0.10),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.56,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6A7282),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right side: Dial button
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: ShapeDecoration(
                color: const Color(0xFF00A63E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
