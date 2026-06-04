import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transjatim_provider.dart';
import '../models/transjatim_model.dart';
import 'transjatim_route_screen.dart';
import 'transjatim_ticket_active_screen.dart';

class TransjatimTrackingScreen extends StatefulWidget {
  const TransjatimTrackingScreen({super.key});

  @override
  State<TransjatimTrackingScreen> createState() => _TransjatimTrackingScreenState();
}

class _TransjatimTrackingScreenState extends State<TransjatimTrackingScreen> {
  bool _isLiveTrackingEnabled = true;
  Timer? _trackingTimer;
  double _simulationStep = 0.0;
  String _selectedKoridorId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransJatimProvider>(context, listen: false);
      provider.fetchKoridor().then((_) {
        if (provider.koridorList.isNotEmpty) {
          setState(() {
            _selectedKoridorId = provider.koridorList.first.id;
          });
          _startTracking();
        }
      });
    });
  }

  void _startTracking() {
    _trackingTimer?.cancel();
    Provider.of<TransJatimProvider>(context, listen: false).fetchArmada(_selectedKoridorId);
    
    _trackingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isLiveTrackingEnabled && _selectedKoridorId.isNotEmpty) {
        setState(() {
          _simulationStep += 0.0015;
          if (_simulationStep > 0.05) {
            _simulationStep = 0.0; // Loop simulation
          }
        });
        Provider.of<TransJatimProvider>(context, listen: false).fetchArmada(_selectedKoridorId);
      }
    });
  }

  void _stopTracking() {
    _trackingTimer?.cancel();
  }

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransJatimProvider>(context);
    final koridor = provider.koridorList.firstWhere(
      (k) => k.id == _selectedKoridorId,
      orElse: () => Koridor(
        id: '',
        kode: 'TJ-01',
        nama: 'Koridor 1 - Purabaya - Darmo',
        asal: 'Terminal Purabaya',
        tujuan: 'Jl. Darmo',
        isActive: true,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Background
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0065FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -100,
                  top: -100,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Navigation
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Transjatim',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark_border, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Navigation Tabs
                      Padding(
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
                              _buildNavItem('Tracking', true, () {}),
                              _buildNavItem('Rute', false, () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TransjatimRouteScreen()),
                                );
                              }),
                              _buildNavItem('Tiket', false, () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TransjatimTicketActiveScreen()),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Tracking Toggle Card
                  _buildLiveTrackingToggle(),

                  const SizedBox(height: 12),

                  // Corridor Selection Dropdown
                  _buildCorridorDropdown(provider),

                  const SizedBox(height: 16),

                  // Real-Time Monitoring Banner
                  _buildLiveBanner(provider),

                  const SizedBox(height: 16),

                  // Map Dynamic View
                  _buildMapSection(provider),

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

                  // Bus List Items
                  if (provider.isLoadingArmada && provider.armadaList.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
                        ),
                      ),
                    )
                  else if (provider.armadaList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.directions_bus_outlined, color: Colors.grey.shade400, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada armada aktif',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...provider.armadaList.map((bus) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildBusCard(
                          corridor: koridor.kode.replaceAll(RegExp(r'[^0-9]'), ''),
                          name: bus.kodeBus,
                          plate: bus.id.substring(0, 8).toUpperCase(),
                          status: bus.status == 'aktif' ? 'Beroperasi' : 'Tidak Aktif',
                          startStop: koridor.asal,
                          endStop: koridor.tujuan,
                        ),
                      );
                    }),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0065FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildCorridorDropdown(TransJatimProvider provider) {
    if (provider.koridorList.isEmpty) return const SizedBox.shrink();

    final currentExists = provider.koridorList.any((k) => k.id == _selectedKoridorId);
    if (!currentExists && provider.koridorList.isNotEmpty) {
      _selectedKoridorId = provider.koridorList.first.id;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedKoridorId.isEmpty ? null : _selectedKoridorId,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
            items: provider.koridorList.map((k) {
              return DropdownMenuItem<String>(
                value: k.id,
                child: Text(
                  '${k.kode} - ${k.nama}',
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedKoridorId = val;
                  _simulationStep = 0.0;
                });
                _startTracking();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBanner(TransJatimProvider provider) {
    final count = provider.armadaList.length;
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
                  Text(
                    '$count bus sedang beroperasi',
                    style: const TextStyle(
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

  Widget _buildMapSection(TransJatimProvider provider) {
    const double minLat = -7.38;
    const double maxLat = -7.25;
    const double minLng = 112.71;
    const double maxLng = 112.76;

    final koridor = provider.koridorList.firstWhere(
      (k) => k.id == _selectedKoridorId,
      orElse: () => provider.koridorList.firstOrNull ?? Koridor(
        id: '',
        kode: 'TJ-01',
        nama: 'Koridor 1',
        asal: 'Terminal Purabaya',
        tujuan: 'Jl. Darmo',
        isActive: true,
      ),
    );

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
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: CustomPaint(
                  painter: GridPainter(),
                ),
              ),
            ),

            if (provider.armadaList.isNotEmpty)
              Positioned.fill(
                child: CustomPaint(
                  painter: RoutePathPainter(
                    armadas: provider.armadaList,
                    simulationStep: _simulationStep,
                    minLat: minLat,
                    maxLat: maxLat,
                    minLng: minLng,
                    maxLng: maxLng,
                  ),
                ),
              ),

            if (provider.armadaList.isNotEmpty)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: List.generate(provider.armadaList.length, (i) {
                        final bus = provider.armadaList[i];
                        double latOffset = (i % 2 == 0) ? _simulationStep : -_simulationStep;
                        double lngOffset = (i % 2 == 0) ? _simulationStep * 0.4 : -_simulationStep * 0.4;

                        double finalLat = (bus.lat ?? -7.3512) + latOffset;
                        double finalLng = (bus.lng ?? 112.7242) + lngOffset;

                        double normLat = (finalLat - minLat) / (maxLat - minLat);
                        double normLng = (finalLng - minLng) / (maxLng - minLng);

                        normLat = normLat.clamp(0.05, 0.95);
                        normLng = normLng.clamp(0.05, 0.95);

                        final double top = (1.0 - normLat) * (256 - 50);
                        final double left = normLng * (constraints.maxWidth - 50);

                        return Positioned(
                          top: top,
                          left: left,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0065FF),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0065FF).withOpacity(0.3),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_bus,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF3B82F6), width: 0.5),
                                ),
                                child: Text(
                                  bus.kodeBus,
                                  style: const TextStyle(
                                    color: Color(0xFF1E3A8A),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.map_outlined, size: 14, color: Color(0xFF0065FF)),
                    const SizedBox(width: 6),
                    Text(
                      'Peta: ${koridor.nama}',
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  Widget _buildLiveTrackingToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0065FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.radar, color: Colors.white, size: 18),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Update otomatis setiap 3 detik',
                    style: TextStyle(
                      color: const Color(0xFFFEF9C2).withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isLiveTrackingEnabled,
              onChanged: (val) {
                setState(() {
                  _isLiveTrackingEnabled = val;
                });
                if (val) {
                  _startTracking();
                } else {
                  _stopTracking();
                }
              },
              activeColor: const Color(0xFF00C950),
              activeTrackColor: const Color(0xFF00C950).withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(0.2)
      ..strokeWidth = 1.0;

    const double step = 20.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoutePathPainter extends CustomPainter {
  final List<Armada> armadas;
  final double simulationStep;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;

  RoutePathPainter({
    required this.armadas,
    required this.simulationStep,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (armadas.length < 2) return;

    final paint = Paint()
      ..color = const Color(0xFF0065FF).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < armadas.length; i++) {
      final bus = armadas[i];
      double latOffset = (i % 2 == 0) ? simulationStep : -simulationStep;
      double lngOffset = (i % 2 == 0) ? simulationStep * 0.4 : -simulationStep * 0.4;

      double finalLat = (bus.lat ?? -7.3512) + latOffset;
      double finalLng = (bus.lng ?? 112.7242) + lngOffset;

      double normLat = (finalLat - minLat) / (maxLat - minLat);
      double normLng = (finalLng - minLng) / (maxLng - minLng);

      normLat = normLat.clamp(0.05, 0.95);
      normLng = normLng.clamp(0.05, 0.95);

      final double x = normLng * size.width;
      final double y = (1.0 - normLat) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RoutePathPainter oldDelegate) =>
      oldDelegate.simulationStep != simulationStep || oldDelegate.armadas != armadas;
}
