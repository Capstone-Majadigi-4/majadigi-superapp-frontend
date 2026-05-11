import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/bapenda_vehicle_detail_screen.dart';

class VehicleCard extends StatelessWidget {
  final String platNomor;
  final String merk;
  final String tipe;
  final String tanggalJatuhTempo;
  final bool isWarning;
  final String statusText;

  const VehicleCard({
    super.key,
    required this.platNomor,
    required this.merk,
    required this.tipe,
    required this.tanggalJatuhTempo,
    required this.isWarning,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BapendaVehicleDetailScreen(
              platNomor: platNomor,
              merk: '$merk / $tipe',
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isWarning ? const Color(0xFFEF4444) : const Color(0xFFE5E7EB),
            width: isWarning ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isWarning 
                  ? const Color(0xFFEF4444).withValues(alpha: 0.1) 
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Plat Nomor
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101828), // Biru dongker pekat
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    platNomor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                // Badge Status
                if (isWarning)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Teks Kendaraan
            Text(
              '$merk / $tipe',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700, // Bold
                color: Color(0xFF101828),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            // Tanggal Jatuh Tempo
            Text(
              'Jatuh Tempo: $tanggalJatuhTempo',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4A5565),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabLayanan extends StatelessWidget {
  const TabLayanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        shrinkWrap: true, // Karena berada di dalam SingleChildScrollView di bapenda_screen
        physics: const NeverScrollableScrollPhysics(), 
        children: [
          const Text(
            'Daftar Kendaraan Anda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700, // Bold
              color: Color(0xFF101828),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data kendaraan ditarik otomatis berdasarkan NIK Anda.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6A7282), // Abu-abu
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          // Dummy 1 (Warning)
          const VehicleCard(
            platNomor: 'L 1234 AB',
            merk: 'HONDA',
            tipe: 'VARIO 150',
            tanggalJatuhTempo: '15 Mei 2026',
            isWarning: true,
            statusText: 'Jatuh tempo H-8',
          ),
          const SizedBox(height: 16),
          // Dummy 2 (Active)
          const VehicleCard(
            platNomor: 'W 5678 CD',
            merk: 'TOYOTA',
            tipe: 'AVANZA 1.5 G',
            tanggalJatuhTempo: '20 November 2026',
            isWarning: false,
            statusText: 'Aktif',
          ),
        ],
      ),
    );
  }
}
