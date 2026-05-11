import 'package:flutter/material.dart';
import 'expandable_info_card.dart';

class SinakerKetentuanTab extends StatelessWidget {
  const SinakerKetentuanTab({super.key});

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sinaker Jatim (Sistem Informasi Ketenagakerjaan Jawa Timur) adalah platform digital resmi dari Dinas Tenaga Kerja dan Transmigrasi Provinsi Jawa Timur. Aplikasi ini berfungsi sebagai pusat layanan ketenagakerjaan terintegrasi, khususnya untuk pendaftaran pelatihan di berbagai Balai Latihan Kerja (BLK) di bawah Disnakertrans Jatim.',
                  style: TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Prosedur Section (Optional, keeping consistent with previous structure but simplified)
          ExpandableInfoCard(
            title: 'Prosedur Pendaftaran',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildListItem(
                  number: '1.',
                  text: 'Pilih jenis pelatihan yang sesuai dengan minat dan kualifikasi Anda.',
                ),
                const SizedBox(height: 12),
                _buildListItem(
                  number: '2.',
                  text: 'Lengkapi data diri dan dokumen pendukung yang diperlukan.',
                ),
                const SizedBox(height: 12),
                _buildListItem(
                  number: '3.',
                  text: 'Tunggu proses seleksi dan pengumuman jadwal pelatihan.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildListItem({required String number, required String text}) {
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
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF364153),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.63,
            ),
          ),
        ),
      ],
    );
  }
}
