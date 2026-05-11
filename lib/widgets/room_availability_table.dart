import 'package:flutter/material.dart';

class RoomAvailabilityTable extends StatelessWidget {
  const RoomAvailabilityTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the table
    final List<Map<String, dynamic>> rooms = [
      {'name': 'R.PICU KRAKATAU', 'capacity': 17, 'filled': 14, 'available': 3, 'color': Colors.orange},
      {'name': 'R.TOBA (BAYI)', 'capacity': 1, 'filled': 0, 'available': 1, 'color': Colors.red},
      {'name': 'R.TOBA (BAYI)', 'capacity': 1, 'filled': 0, 'available': 1, 'color': Colors.red},
      {'name': 'R.WIJAYA KUSUMA', 'capacity': 8, 'filled': 2, 'available': 4, 'color': Colors.red},
      {'name': 'R.NICU MANINJAU', 'capacity': 12, 'filled': 6, 'available': 5, 'color': Colors.lightBlue},
      {'name': 'R.GALUNGGUNG', 'capacity': 16, 'filled': 15, 'available': 1, 'color': Colors.blue},
      {'name': 'R.PANGANDARAN', 'capacity': 35, 'filled': 31, 'available': 4, 'color': Colors.green},
      {'name': 'R.TOBA (IBU)', 'capacity': 10, 'filled': 7, 'available': 3, 'color': Colors.green},
      {'name': 'R.BROMO', 'capacity': 42, 'filled': 35, 'available': 7, 'color': Colors.red},
      {'name': 'R.TOBA (IBU)', 'capacity': 8, 'filled': 3, 'available': 5, 'color': Colors.red},
      {'name': 'R.LANTAI 4', 'capacity': 24, 'filled': 10, 'available': 13, 'color': Colors.amber},
      {'name': 'R.HCU KAWI', 'capacity': 9, 'filled': 3, 'available': 6, 'color': Colors.blueAccent},
      {'name': 'RUANG ROE', 'capacity': 10, 'filled': 5, 'available': 5, 'color': Colors.indigo},
      {'name': 'R.RANU KUMBOLO', 'capacity': 18, 'filled': 8, 'available': 10, 'color': Colors.indigoAccent},
    ];

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
                              color: room['color'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              room['name'],
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
                        '${room['capacity']}',
                        textAlign: TextAlign.center,
                        style: _cellStyle(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${room['filled']}',
                        textAlign: TextAlign.center,
                        style: _cellStyle(color: const Color(0xFFD97706)), // Orange-600
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${room['available']}',
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
