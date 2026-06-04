import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/rsud_provider.dart';
import 'package:majadigi_superapp_frontend/widgets/shimmer.dart';

class RoomAvailabilityTable extends StatelessWidget {
  const RoomAvailabilityTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RsudProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingKamar) {
          return _buildShimmerTable();
        }

        final rooms = provider.kamarList;

        if (rooms.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.domain_disabled, size: 40, color: Color(0xFF94A3B8)),
                SizedBox(height: 12),
                Text(
                  'Kamar Rawat Tidak Ditemukan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                SizedBox(height: 4),
                Text(
                  'Tidak ada data ketersediaan kamar rawat inap saat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Ruang',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF18181B),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Kapasitas',
                        textAlign: TextAlign.center,
                        style: _headerStyle(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Terisi',
                        textAlign: TextAlign.center,
                        style: _headerStyle(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Tersedia',
                        textAlign: TextAlign.center,
                        style: _headerStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              
              // Table Body
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rooms.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  
                  // Color mapped from room class or fallback
                  Color statusColor = Colors.green;
                  if (room.tersedia == 0) {
                    statusColor = Colors.red;
                  } else if (room.tersedia < 3) {
                    statusColor = Colors.orange;
                  } else if (room.kelas.contains('VIP')) {
                    statusColor = Colors.purple;
                  } else if (room.kelas.contains('1')) {
                    statusColor = Colors.blue;
                  } else {
                    statusColor = Colors.lightBlue;
                  }

                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  room.nama,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF18181B),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${room.kapasitas}',
                            textAlign: TextAlign.center,
                            style: _cellStyle(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${room.terisi}',
                            textAlign: TextAlign.center,
                            style: _cellStyle(color: const Color(0xFFD97706)), // Orange-600
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${room.tersedia}',
                            textAlign: TextAlign.center,
                            style: _cellStyle(color: const Color(0xFF059669)), // Emerald-600
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text('Ruang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF18181B))),
                ),
                Expanded(child: Text('Kapasitas', textAlign: TextAlign.center, style: _headerStyle())),
                Expanded(child: Text('Terisi', textAlign: TextAlign.center, style: _headerStyle())),
                Expanded(child: Text('Tersedia', textAlign: TextAlign.center, style: _headerStyle())),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Shimmer.circular(width: 10, height: 10),
                          const SizedBox(width: 8),
                          Shimmer.rectangular(height: 12, width: 120),
                        ],
                      ),
                    ),
                    Expanded(child: Center(child: Shimmer.rectangular(height: 12, width: 20))),
                    Expanded(child: Center(child: Shimmer.rectangular(height: 12, width: 20))),
                    Expanded(child: Center(child: Shimmer.rectangular(height: 12, width: 20))),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Color(0xFF18181B),
    );
  }

  TextStyle _cellStyle({Color color = const Color(0xFF18181B)}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: 'Inter',
    );
  }
}
