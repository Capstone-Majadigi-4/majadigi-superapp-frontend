import 'package:flutter/material.dart';
import 'transjatim_route_screen.dart';
import 'transjatim_ticket_active_screen.dart';

class TransjatimTrackingScreen extends StatefulWidget {
  const TransjatimTrackingScreen({super.key});

  @override
  State<TransjatimTrackingScreen> createState() => _TransjatimTrackingScreenState();
}

class _TransjatimTrackingScreenState extends State<TransjatimTrackingScreen> {
  bool _isLiveTrackingEnabled = true;
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF),
      body: Stack(
        children: [
          // Background Pattern
          Positioned(
            left: -276,
            top: -212,
            child: Container(
              width: 815,
              height: 1250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Transjatim',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.bookmark_border, color: Colors.white, size: 28),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Live Tracking Toggle Card
                        _buildLiveTrackingToggle(),

                        const SizedBox(height: 24),

                        // Sub Navigation (Tracking, Rute, Tiket)
                        _buildSubNavigation(),

                        const SizedBox(height: 24),

                        // Real-Time Monitoring Banner
                        _buildLiveBanner(),

                        const SizedBox(height: 16),

                        // Map Placeholder
                        _buildMapSection(),

                        const SizedBox(height: 24),

                        // Bus Terdekat Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              const Icon(Icons.bolt, color: Color(0xFFF0B100), size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Bus Terdekat (Real-time)',
                                style: TextStyle(
                                  color: Color(0xFF0A0A0A),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Bus List Item
                        _buildBusCard(
                          corridor: '1',
                          name: 'Koridor 1',
                          plate: 'L 7890 KL',
                          status: 'Beroperasi',
                          startStop: 'Terminal Purabaya',
                          endStop: 'Halte Juanda Airport',
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTrackingToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0065FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sensors, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Tracking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Update otomatis setiap 3 detik',
                    style: TextStyle(
                      color: const Color(0xFFFEF9C2).withOpacity(0.9),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isLiveTrackingEnabled,
              onChanged: (val) => setState(() => _isLiveTrackingEnabled = val),
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF00C950),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavItem(0, Icons.bolt, 'Tracking'),
            _buildNavItem(1, Icons.location_on_outlined, 'Rute'),
            _buildNavItem(2, Icons.confirmation_number_outlined, 'Tiket'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) { // Rute tab
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransjatimRouteScreen()),
            );
          } else if (index == 2) { // Tiket tab
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TransjatimTicketActiveScreen()),
            );
          } else {
            setState(() => _activeTabIndex = index);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? const Color(0xFF0065FF) : const Color(0xFF4A5565),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFF0065FF) : const Color(0xFF4A5565),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDCFCE7)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF00C950),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sensors, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Real-Time Monitoring',
                    style: TextStyle(
                      color: Color(0xFF065F46),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    '1 bus sedang beroperasi',
                    style: TextStyle(
                      color: Color(0xFF059669),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00C950),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 256,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDBEAFE), Color(0xFFCEFAFE)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative Dots
            Positioned(top: 40, left: 60, child: _buildMapDot(const Color(0xFF00C950))),
            Positioned(top: 100, right: 80, child: _buildMapDot(const Color(0xFF00C950))),
            Positioned(bottom: 60, right: 60, child: _buildMapDot(const Color(0xFFF0B100))),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Color(0xFF3B82F6), size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Peta Live Tracking Bus',
                  style: TextStyle(
                    color: Color(0xFF1C398E),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Update real-time posisi 3 bus',
                  style: TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard({
    required String corridor,
    required String name,
    required String plate,
    required String status,
    required String startStop,
    required String endStop,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0B100),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    corridor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                        name,
                        style: const TextStyle(
                          color: Color(0xFF101828),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        plate,
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C950),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStopRow(startStop, true),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 2,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 1),
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                    ),
                  ),
                  _buildStopRow(endStop, false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildActionIcon(Icons.near_me_outlined, const Color(0xFFEEF2FF), const Color(0xFF4F46E5)),
                const SizedBox(width: 12),
                _buildActionIcon(Icons.access_time, const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
                const SizedBox(width: 12),
                _buildActionIcon(Icons.trending_up, const Color(0xFFFDF2F8), const Color(0xFFDB2777)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopRow(String name, bool isStart) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isStart ? const Color(0xFF00C950) : const Color(0xFF3B82F6),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
