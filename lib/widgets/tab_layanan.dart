import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapenda_provider.dart';
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

class TabLayanan extends StatefulWidget {
  const TabLayanan({super.key});

  @override
  State<TabLayanan> createState() => _TabLayananState();
}

class _TabLayananState extends State<TabLayanan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BapendaProvider>(context, listen: false).fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Consumer<BapendaProvider>(
            builder: (context, provider, child) {
              if (provider.isLoadingVehicles) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
                    ),
                  ),
                );
              }

              if (provider.errorVehicles != null) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Gagal mengambil data kendaraan. Silakan coba lagi.',
                              style: TextStyle(
                                color: Color(0xFFB91C1C),
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => provider.fetchVehicles(),
                        icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                        label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (provider.vehicles.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car_filled_outlined, color: Colors.grey.shade400, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada kendaraan terdaftar',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.vehicles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final vehicle = provider.vehicles[index];
                  return VehicleCard(
                    platNomor: vehicle.platNomor,
                    merk: vehicle.merk,
                    tipe: vehicle.tipe,
                    tanggalJatuhTempo: vehicle.tanggalJatuhTempo,
                    isWarning: vehicle.isWarning,
                    statusText: vehicle.statusText,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
