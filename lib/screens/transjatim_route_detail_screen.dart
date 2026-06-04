import 'package:flutter/material.dart';

class TransjatimRouteDetailScreen extends StatelessWidget {
  final String corridorId;
  final String corridorName;

  const TransjatimRouteDetailScreen({
    super.key,
    this.corridorId = '1',
    this.corridorName = 'Koridor 1',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Header with Image/Pattern
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 253,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0065FF), Color(0xFF0040A1)],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Detail Rute',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

          // Content
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Corridor Info Card
                    _buildCorridorHeader(),

                    const SizedBox(height: 24),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatItem('Jarak', '25 km', const Color(0xFFF9FAFB), const Color(0xFF6A7282)),
                        const SizedBox(width: 12),
                        _buildStatItem('Durasi', '45 menit', const Color(0xFFF9FAFB), const Color(0xFF6A7282)),
                        const SizedBox(width: 12),
                        _buildStatItem('Bus Aktif', '8', const Color(0xFFF0FDF4), const Color(0xFF008236)),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Route List Header
                    const Text(
                      'Daftar Halte',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rute: Terminal Purabaya → Bandara Juanda',
                      style: TextStyle(
                        color: const Color(0xFF4A5565).withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stops List
                    _buildStopItem('Terminal Purabaya', 'Titik Awal', isStart: true),
                    _buildRouteLine(),
                    _buildStopItem('Halte Bungurasih', '2 menit', isMiddle: true),
                    _buildRouteLine(),
                    _buildStopItem('Halte Medaeng', '5 menit', isMiddle: true),
                    _buildRouteLine(),
                    _buildStopItem('Halte Waru', '8 menit', isMiddle: true),
                    _buildRouteLine(),
                    _buildStopItem('Halte Gedangan', '15 menit', isMiddle: true),
                    _buildRouteLine(),
                    _buildStopItem('Halte Aloha', '20 menit', isMiddle: true),
                    _buildRouteLine(),
                    _buildStopItem('Halte Sedati', '30 menit', isMiddle: true),
                    _buildRouteLine(),
                    _buildStopItem('Bandara Juanda', 'Titik Akhir', isEnd: true),

                    const SizedBox(height: 40),

                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0065FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Lihat di Peta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorridorHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0065FF),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              corridorId,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  corridorName,
                  style: const TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sidoarjo - Surabaya',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF0B100)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Rp 5.000',
              style: TextStyle(
                color: Color(0xFFA65F00),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: bgColor == const Color(0xFFF9FAFB) 
              ? Border.all(color: const Color(0xFFE5E7EB))
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6A7282),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopItem(String name, String detail, {bool isStart = false, bool isEnd = false, bool isMiddle = false}) {
    Color dotColor = const Color(0xFFD1D5DB);
    if (isStart) dotColor = const Color(0xFF00A63E);
    if (isEnd) dotColor = const Color(0xFFEF4444);
    if (isMiddle) dotColor = const Color(0xFF0065FF);

    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: dotColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: const Color(0xFF101828),
                  fontSize: 15,
                  fontWeight: isStart || isEnd ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              Text(
                detail,
                style: TextStyle(
                  color: const Color(0xFF667085),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (!isStart && !isEnd)
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF98A2B3)),
      ],
    );
  }

  Widget _buildRouteLine() {
    return Container(
      margin: const EdgeInsets.only(left: 7),
      width: 2,
      height: 24,
      color: const Color(0xFFE5E7EB),
    );
  }
}
