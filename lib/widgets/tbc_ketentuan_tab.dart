import 'package:flutter/material.dart';
import 'expandable_info_card.dart';

class TbcKetentuanTab extends StatelessWidget {
  const TbcKetentuanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          
          // Manfaat Section
          ExpandableInfoCard(
            title: 'Manfaat',
            isInitiallyExpanded: true,
            child: Column(
              children: [
                _buildRichListItem(
                  number: '1.',
                  key: 'Skrining mandiri:',
                  value: ' E TIBI memudahkan masyarakat untuk bisa melakukan screening mandiri secara online.',
                ),
                const SizedBox(height: 12),
                _buildRichListItem(
                  number: '2.',
                  key: 'Deteksi dini:',
                  value: ' Peningkatan deteksi dini kasus TBC, sehingga pengobatan bisa dilakukan lebih cepat dan efektif.',
                ),
                const SizedBox(height: 12),
                _buildRichListItem(
                  number: '3.',
                  key: 'Monitoring pasien & pengobatan:',
                  value: ' Petugas kesehatan atau kader lebih mudah melakukan pendampingan pasien dan monitoring pengobatan pasien TBC selama enam bulan.',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Pendaftaran Online Section
          ExpandableInfoCard(
            title: 'Pendaftaran Online',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Berikut prosedur pengolahan data E TIBI',
                  style: TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRichListItem(
                  number: '1.',
                  key: 'Form self assessment:',
                  value: ' Pengguna mengisi form asesemen yang secara online sesuai dengan kondisi',
                ),
                const SizedBox(height: 12),
                _buildRichListItem(
                  number: '2.',
                  key: 'Proses pengolahan data assesment:',
                  value: ' Sistem akan menganalisa form yang sudah dikirimkan oleh pengguna.',
                ),
                const SizedBox(height: 12),
                _buildRichListItem(
                  number: '3.',
                  key: 'Hasil pengisian self assesment:',
                  value: ' Hasil asessmen muncul pada halaman berikutnya.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Space for bottom button
        ],
      ),
    );
  }

  Widget _buildRichListItem({
    required String number,
    required String key,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Text(
            number,
            style: const TextStyle(
              color: Color(0xFF364153),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.63,
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: key,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.63,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
