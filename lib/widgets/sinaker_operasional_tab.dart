import 'package:flutter/material.dart';
import 'info_card.dart';

class SinakerOperasionalTab extends StatelessWidget {
  const SinakerOperasionalTab({super.key});

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
                'https://sinaker.disnakertrans.jatimprov.go.id',
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
          
          // Alamat
          const InfoCard(
            title: 'Alamat',
            content: Text(
              'Jl. Dukuh Menanggal Sel. No.124-126, Dukuh Menanggal, Kec. Gayungan, Surabaya, Jawa Timur 60234',
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
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Senin-Kamis: 07.00-15.30',
                  style: TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
                Text(
                  'Jumat: 07.00-14.30',
                  style: TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ],
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
                _buildSocialIcon(Icons.camera_alt),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.language),
              ],
            ),
          ),
          const SizedBox(height: 100),
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
