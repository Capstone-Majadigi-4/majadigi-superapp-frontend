import 'package:flutter/material.dart';

class SapabansosOperasionalTab extends StatelessWidget {
  const SapabansosOperasionalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Link Layanan Card
          _buildInfoCard(
            title: 'Link Layanan',
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'https://sapabansos.dinsos.jatimprov.go.id/',
                style: TextStyle(
                  color: Color(0xFF155DFC),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Alamat Card
          _buildInfoCard(
            title: 'Alamat',
            child: const Text(
              'Jl. Gayungkebonsari 56B, Surabaya, Jawa Timur, 60235.',
              style: TextStyle(
                color: Color(0xFF364153),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Jam Operasional Card
          _buildInfoCard(
            title: 'Jam Operasional',
            child: Column(
              children: [
                _buildBulletRow('Senin-Kamis: 07.30-16.00'),
                const SizedBox(height: 10),
                _buildBulletRow('Jumat: 07.30-16.30'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Media Sosial Card
          _buildInfoCard(
            title: 'Media Sosial',
            child: Row(
              children: [
                _buildSocialIcon(Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.camera_alt_outlined), // Instagram placeholder
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.language), // Twitter/Web placeholder
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.play_circle_outline), // YouTube placeholder
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildBulletRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF364153),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF364153),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF101828), size: 24),
    );
  }
}
