import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/module_provider.dart';
import '../providers/transjatim_provider.dart';
import '../models/transjatim_model.dart';
import 'transjatim_route_screen.dart';
import 'transjatim_ticket_active_screen.dart';
import 'transjatim_route_detail_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/transjatim_websocket_service.dart';


class TransjatimTrackingScreen extends StatefulWidget {
  final String? initialCorridorId;
  const TransjatimTrackingScreen({super.key, this.initialCorridorId});

  @override
  State<TransjatimTrackingScreen> createState() => _TransjatimTrackingScreenState();
}

class _TransjatimTrackingScreenState extends State<TransjatimTrackingScreen> with SingleTickerProviderStateMixin {
  bool _isLiveTrackingEnabled = true;
  Timer? _trackingTimer;
  double _simulationStep = 0.0;
  String _selectedKoridorId = '';
  final MapController _mapController = MapController();
  LatLng? _currentUserLocation;
  String? _lastCenteredKoridorId;

  final TransjatimWebSocketService _wsService = TransjatimWebSocketService();
  StreamSubscription? _wsSubscription;
  bool _isWsSimulated = true;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (kIsWeb || !Platform.environment.containsKey('FLUTTER_TEST')) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 1.0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransJatimProvider>(context, listen: false);
      provider.fetchKoridor().then((_) {
        if (provider.koridorList.isNotEmpty) {
          setState(() {
            final initialId = widget.initialCorridorId;
            if (initialId != null && initialId.isNotEmpty) {
              final matchedKoridor = provider.koridorList.firstWhere(
                (k) => k.id == initialId,
                orElse: () => provider.koridorList.firstWhere(
                  (k) => k.kode.toLowerCase() == initialId.toLowerCase() ||
                         k.kode.replaceAll(RegExp(r'[^0-9]'), '') == initialId,
                  orElse: () => provider.koridorList.firstWhere(
                    (k) => k.nama.toLowerCase().contains(initialId.toLowerCase()),
                    orElse: () => provider.koridorList.first,
                  ),
                ),
              );
              _selectedKoridorId = matchedKoridor.id;
            } else {
              _selectedKoridorId = provider.koridorList.first.id;
            }
          });
          _startTracking();
        }
      });
    });
  }

  void _centerMapOnBusRoute() {
    if (!mounted) return;
    final provider = Provider.of<TransJatimProvider>(context, listen: false);
    if (provider.armadaList.isNotEmpty) {
      final bus = provider.armadaList.first;
      final busLoc = LatLng(bus.lat ?? -7.3512, bus.lng ?? 112.7242);
      _mapController.move(busLoc, 13.0);
      _lastCenteredKoridorId = _selectedKoridorId;
    }
  }

  void _startTracking() {
    _stopTracking();
    final provider = Provider.of<TransJatimProvider>(context, listen: false);
    
    provider.fetchArmada(_selectedKoridorId).then((_) {
      _centerMapOnBusRoute();
    });
    
    _wsService.connect(_selectedKoridorId);
    
    _wsSubscription = _wsService.armadaStream.listen((data) {
      if (!mounted) return;
      setState(() {
        _isWsSimulated = data['isSimulated'] ?? false;
        if (data['step'] != null) {
          _simulationStep = (data['step'] as num).toDouble();
        }
      });
      
      if (data['armada'] != null) {
        try {
          final List<dynamic> armadaJson = data['armada'];
          final List<Armada> parsedArmadas = armadaJson.map((x) => Armada.fromJson(x)).toList();
          provider.updateArmadaList(parsedArmadas);
        } catch (e) {
          debugPrint('Error parsing WS armada data: $e');
        }
      } else {
        provider.fetchArmada(_selectedKoridorId).then((_) {
          if (_lastCenteredKoridorId != _selectedKoridorId) {
            _centerMapOnBusRoute();
          }
        });
      }
    });
  }

  void _stopTracking() {
    _trackingTimer?.cancel();
    _wsSubscription?.cancel();
    _wsSubscription = null;
    _wsService.disconnect();
  }

  @override
  void dispose() {
    _stopTracking();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildPulsingDot(Color color) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseController.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 4 * _pulseController.value,
                  spreadRadius: 1 * _pulseController.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCurrentUserLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        );
        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentUserLocation!, 14.5);
      } catch (e) {
        debugPrint("Error getting location: $e");
        final defaultLoc = LatLng(-7.3512, 112.7242);
        setState(() {
          _currentUserLocation = defaultLoc;
        });
        _mapController.move(defaultLoc, 14.5);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak dapat memperoleh GPS. Menggunakan lokasi simulasi.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      final defaultLoc = LatLng(-7.3512, 112.7242);
      setState(() {
        _currentUserLocation = defaultLoc;
      });
      _mapController.move(defaultLoc, 14.5);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin lokasi ditolak. Menggunakan lokasi simulasi.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showBusStatsBottomSheet(
    BuildContext context,
    String name,
    String plate,
    String status,
    String startStop,
    String endStop,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 24, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistik Armada',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD1FAE5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: const TextStyle(
                            color: Color(0xFF065F46),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nomor Plat Kendaraan',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      plate,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    icon: Icons.speed_rounded,
                    iconColor: const Color(0xFF3B82F6),
                    bgColor: const Color(0xFFEFF6FF),
                    label: 'Kecepatan',
                    value: '42 km/jam',
                  ),
                  _buildStatCard(
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF10B981),
                    bgColor: const Color(0xFFECFDF5),
                    label: 'Kapasitas',
                    value: '18 / 35 Kursi',
                  ),
                  _buildStatCard(
                    icon: Icons.thermostat_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    bgColor: const Color(0xFFFEF3C7),
                    label: 'Suhu Kabin',
                    value: '22.5 °C',
                  ),
                  _buildStatCard(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    bgColor: const Color(0xFFF5F3FF),
                    label: 'Pramudi (Driver)',
                    value: 'Hendra S.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Rute Operasional',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Color(0xFF10B981), size: 10),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            startStop,
                            style: const TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      height: 20,
                      width: 2,
                      color: Colors.grey.shade300,
                      alignment: Alignment.centerLeft,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Color(0xFF3B82F6), size: 10),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            endStop,
                            style: const TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
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
                            _buildBookmarkButton(context),
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
                          lat: bus.lat,
                          lng: bus.lng,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _isWsSimulated ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isWsSimulated ? const Color(0xFFBFDBFE) : const Color(0xFFA7F3D0),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLiveTrackingEnabled
                      ? _buildPulsingDot(_isWsSimulated ? const Color(0xFF3B82F6) : const Color(0xFF10B981))
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                  const SizedBox(width: 6),
                  Text(
                    _isWsSimulated ? 'LIVE SIM' : 'LIVE WS',
                    style: TextStyle(
                      color: _isWsSimulated ? const Color(0xFF1E40AF) : const Color(0xFF065F46),
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(TransJatimProvider provider) {
    final List<Marker> markers = [];
    final List<LatLng> routePoints = [];

    for (int i = 0; i < provider.armadaList.length; i++) {
      final bus = provider.armadaList[i];
      double latOffset = (i % 2 == 0) ? _simulationStep : -_simulationStep;
      double lngOffset = (i % 2 == 0) ? _simulationStep * 0.4 : -_simulationStep * 0.4;

      double baseLat = (bus.lat == null || bus.lat == 0.0) ? -7.3512 : bus.lat!;
      double baseLng = (bus.lng == null || bus.lng == 0.0) ? 112.7242 : bus.lng!;

      double finalLat = baseLat + latOffset;
      double finalLng = baseLng + lngOffset;
      final point = LatLng(finalLat, finalLng);
      routePoints.add(point);

      markers.add(
        Marker(
          point: point,
          width: 80,
          height: 80,
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
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling,
                  ),
                  child: Text(
                    bus.kodeBus,
                    style: const TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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

    LatLng initialCenter = routePoints.isNotEmpty ? routePoints.first : LatLng(-7.3512, 112.7242);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 256,
        decoration: BoxDecoration(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentUserLocation ?? initialCenter,
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.majadigi.superapp',
                  ),
                  if (routePoints.length >= 2)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4.0,
                          color: const Color(0xFF0065FF).withOpacity(0.7),
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      ...markers,
                      if (_currentUserLocation != null)
                        Marker(
                          point: _currentUserLocation!,
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF3B82F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
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
              Positioned(
                bottom: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    _getCurrentUserLocation();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Color(0xFF0065FF),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    required double? lat,
    required double? lng,
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
                _buildActionIcon(
                  Icons.near_me_outlined, 
                  const Color(0xFFEEF2FF), 
                  const Color(0xFF4F46E5),
                  () {
                    double baseLat = (lat == null || lat == 0.0) ? -7.3512 : lat;
                    double baseLng = (lng == null || lng == 0.0) ? 112.7242 : lng;
                    _mapController.move(LatLng(baseLat, baseLng), 14.5);
                  },
                ),
                const SizedBox(width: 12),
                _buildActionIcon(
                  Icons.access_time, 
                  const Color(0xFFF0FDF4), 
                  const Color(0xFF16A34A),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransjatimRouteDetailScreen(
                          corridorId: corridor,
                          corridorName: 'Koridor $corridor',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildActionIcon(
                  Icons.trending_up, 
                  const Color(0xFFFDF2F8), 
                  const Color(0xFFDB2777),
                  () {
                    _showBusStatsBottomSheet(context, name, plate, status, startStop, endStop);
                  },
                ),
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

  Widget _buildActionIcon(IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
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

  Widget _buildBookmarkButton(BuildContext context) {
    ModuleProvider? moduleProvider;
    try {
      moduleProvider = Provider.of<ModuleProvider>(context, listen: true);
    } catch (_) {}
    if (moduleProvider == null) {
      return IconButton(
        onPressed: null,
        icon: const Icon(
          Icons.bookmark_border,
          color: Colors.white,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
    final isFav = moduleProvider.isFavorite('transjatim');
    return IconButton(
      onPressed: () {
        moduleProvider!.toggleFavorite('transjatim');
      },
      icon: Icon(
        isFav ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.white,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}


