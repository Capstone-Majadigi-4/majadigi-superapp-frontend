import 'package:flutter/material.dart';
import 'info_card.dart';

class TbcOperasionalTab extends StatelessWidget {
  const TbcOperasionalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Link Layanan
          InfoCard(
            title: 'Link Layanan',
            content: InkWell(
              onTap: () {
                // Link action
              },
              child: const Text(
                'https://etibi.dinkes.jatimprov.go.id/',
                style: TextStyle(
                  color: Color(0xFF155DFC),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  height: 1.43,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Alamat
          const InfoCard(
            title: 'Alamat',
            content: Text(
              'Jl. Ahmad Yani 118 Surabaya, 60231',
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
          
          // Jam Operasional
          const InfoCard(
            title: 'Jam Operasional',
            content: Text(
              'Buka 24 jam',
              style: TextStyle(
                color: Color(0xFF00A63E),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Media Sosial
          InfoCard(
            title: 'Media Sosial',
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSocialIcon(Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.camera_alt), // Instagram placeholder
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.language), // Website placeholder
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.chat), // Twitter/X placeholder
              ],
            ),
          ),
          const SizedBox(height: 100), // Space for bottom button
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Icon(icon, color: const Color(0xFF101828), size: 24),
    );
  }
}
