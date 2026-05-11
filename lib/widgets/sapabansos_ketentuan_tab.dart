import 'package:flutter/material.dart';
import 'expandable_info_card.dart';

class SapabansosKetentuanTab extends StatelessWidget {
  const SapabansosKetentuanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ExpandableInfoCard(
            title: 'Apa itu SAPA BANSOS Jatim?',
            content:
                'SAPA BANSOS Jatim adalah program dan sistem data milik Dinas Sosial Jatim untuk menyalurkan berbagai bantuan sosial secara terpadu. Program ini bertujuan memperkuat perlindungan sosial dan kemandirian ekonomi masyarakat Jawa Timur.',
          ),
          SizedBox(height: 12),
          ExpandableInfoCard(
            title: 'Manfaat & Program',
            content:
                'SAPA BANSOS mencakup berbagai penyaluran bantuan sosial seperti:\n\n• PKH Plus\n• ASPD (Asistensi Sosial Penyandang Disabilitas)\n• Pemberdayaan Masyarakat\n• Perlindungan Sosial Terpadu\n\nBantuan ini sering kali disalurkan langsung oleh Pemprov Jatim untuk menjamin ketepatan sasaran.',
          ),
          SizedBox(height: 12),
          ExpandableInfoCard(
            title: 'Ketentuan Penerima',
            content:
                '1. Terdaftar dalam DTKS (Data Terpadu Kesejahteraan Sosial).\n2. Memenuhi kriteria spesifik setiap program bantuan.\n3. Berdomisili di wilayah Jawa Timur.\n4. Melengkapi administrasi yang diperlukan melalui sistem SAPABANSOS.',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
