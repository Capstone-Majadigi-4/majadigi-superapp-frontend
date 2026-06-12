import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:majadigi_superapp_frontend/providers/rsud_provider.dart';
import 'package:majadigi_superapp_frontend/models/rsud_model.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_ambil_antrean_screen.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_live_queue_detail_screen.dart';
import 'package:majadigi_superapp_frontend/services/rsud_websocket_service.dart';

class RsudQueueStatusScreen extends StatefulWidget {
  const RsudQueueStatusScreen({super.key});

  @override
  State<RsudQueueStatusScreen> createState() => _RsudQueueStatusScreenState();
}

class _RsudQueueStatusScreenState extends State<RsudQueueStatusScreen> {
  // Live Tracker State - dynamically computed from the actual queue number
  String currentServing = '-';
  int waitingCount = 0;
  int estimationMinutes = 0;
  bool _trackerInitialized = false;
  
  final RsudWebSocketService _wsService = RsudWebSocketService();
  StreamSubscription? _queueSubscription;
  Timer? _simulativeTimer;

  String? _lastNomorAntrean;
  List<Poliklinik>? _lastPoliklinikList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<RsudProvider>(context, listen: false).fetchPoliklinik();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen reactively to RsudProvider updates
    final provider = Provider.of<RsudProvider>(context);
    final antrean = provider.lastAntrean;
    final polis = provider.poliklinikList;

    bool poliListChanged = false;
    if (_lastPoliklinikList == null || _lastPoliklinikList!.length != polis.length) {
      poliListChanged = true;
      _lastPoliklinikList = List.from(polis);
    }

    if (antrean?.nomorAntrean != _lastNomorAntrean || (poliListChanged && polis.isNotEmpty)) {
      _lastNomorAntrean = antrean?.nomorAntrean;
      debugPrint('RSUD STATUS SCREEN: didChangeDependencies triggered. lastAntrean: ${antrean?.nomorAntrean}, poli: ${antrean?.poli}');
      _initLiveTracker(antrean?.nomorAntrean);
    }
  }

  @override
  void dispose() {
    _queueSubscription?.cancel();
    _simulativeTimer?.cancel();
    _wsService.disconnect();
    super.dispose();
  }

  /// Parse the numeric part from a queue number like "A-023" → 23 using regex
  int? _parseQueueNumber(String? nomorAntrean) {
    if (nomorAntrean == null || nomorAntrean.isEmpty) return null;
    final regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(nomorAntrean);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }

  /// Format a queue number back to "A-XXX" style
  String _formatQueueNumber(String prefix, int number) {
    return '$prefix-${number.toString().padLeft(3, '0')}';
  }

  bool _isClinicMatch(String clinicName, String activePoli) {
    if (activePoli.isEmpty) return false;
    final cName = clinicName.toLowerCase();
    final aPoli = activePoli.toLowerCase();
    return cName.contains(aPoli) || aPoli.contains(cName);
  }

  Map<String, String> _getMockDataForClinic(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('umum')) {
      return {'count': '15 Antrean', 'estimation': 'Estimasi: 45 menit'};
    } else if (lowerName.contains('dalam')) {
      return {'count': '8 Antrean', 'estimation': 'Estimasi: 30 menit'};
    } else if (lowerName.contains('anak')) {
      return {'count': '12 Antrean', 'estimation': 'Estimasi: 40 menit'};
    } else if (lowerName.contains('bedah')) {
      return {'count': '6 Antrean', 'estimation': 'Estimasi: 18 menit'};
    } else if (lowerName.contains('jantung')) {
      return {'count': '9 Antrean', 'estimation': 'Estimasi: 27 menit'};
    } else if (lowerName.contains('saraf')) {
      return {'count': '4 Antrean', 'estimation': 'Estimasi: 12 menit'};
    } else {
      final hash = name.hashCode.abs();
      final countVal = (hash % 10) + 3;
      return {'count': '$countVal Antrean', 'estimation': 'Estimasi: ${countVal * 3} menit'};
    }
  }

  void _startSimulativeTimer(String? nomorAntrean) {
    _simulativeTimer?.cancel();
    
    final myNumber = _parseQueueNumber(nomorAntrean);
    debugPrint('RSUD STATUS SCREEN: _startSimulativeTimer called with $nomorAntrean, parsed number: $myNumber');
    
    if (myNumber != null && myNumber > 1) {
      // Estimate: serving is ~5 people before the user, min 1
      final serving = (myNumber - 5).clamp(1, myNumber - 1);
      final prefix = nomorAntrean!.contains('-') ? nomorAntrean.split('-').first : 'A';
      setState(() {
        currentServing = _formatQueueNumber(prefix, serving);
        waitingCount = myNumber - serving;
        estimationMinutes = waitingCount * 3;
      });
    } else if (myNumber != null) {
      // User is first in queue (e.g. A-001)
      setState(() {
        currentServing = nomorAntrean ?? 'A-001';
        waitingCount = 0;
        estimationMinutes = 0;
      });
    } else {
      // No queue data, use neutral defaults
      setState(() {
        currentServing = '-';
        waitingCount = 0;
        estimationMinutes = 0;
      });
      return;
    }

    // Simulate real-time counter decrement every 10 seconds
    _simulativeTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (waitingCount > 0) {
          waitingCount--;
          estimationMinutes = waitingCount * 3 + 1;
          // Advance currentServing by 1
          final servingNum = _parseQueueNumber(currentServing);
          if (servingNum != null) {
            final prefix = currentServing.contains('-') ? currentServing.split('-').first : 'A';
            currentServing = _formatQueueNumber(prefix, servingNum + 1);
          }
        }
      });
    });
  }

  void _initLiveTracker(String? nomorAntrean) {
    _simulativeTimer?.cancel();
    _queueSubscription?.cancel();
    _wsService.disconnect();

    if (nomorAntrean == null || nomorAntrean.isEmpty) {
      setState(() {
        currentServing = '-';
        waitingCount = 0;
        estimationMinutes = 0;
      });
      return;
    }

    final provider = Provider.of<RsudProvider>(context, listen: false);
    final antrean = provider.lastAntrean;
    final activePoli = antrean?.poli ?? '';

    String? matchedPoliId;
    if (activePoli.isNotEmpty) {
      for (var poli in provider.poliklinikList) {
        if (_isClinicMatch(poli.nama, activePoli)) {
          matchedPoliId = poli.id;
          break;
        }
      }
    }

    if (matchedPoliId != null) {
      debugPrint('RSUD STATUS SCREEN: Matched poli "$activePoli" to ID "$matchedPoliId". Connecting to live WS...');
      _wsService.connect(matchedPoliId);

      _queueSubscription = _wsService.queueStream.listen((data) {
        if (mounted) {
          final wsServing = data['currentServing']?.toString() ?? '-';
          final wsWaiting = data['waitingCount'] is int ? data['waitingCount'] as int : 0;

          setState(() {
            currentServing = wsServing;
            waitingCount = wsWaiting;
            estimationMinutes = wsWaiting * 3;
          });
        }
      });
    } else {
      debugPrint('RSUD STATUS SCREEN: No matching poli found yet (poliklinikList size: ${provider.poliklinikList.length}). Using fallback simulation.');
      _startSimulativeTimer(nomorAntrean);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Your Queue Card
                  _buildYourQueueCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Take New Queue Card
                  _buildNewQueueCard(),
                  
                  const SizedBox(height: 32),
                  
                  // Real-time Info Title
                  const Text(
                    'Info Antrean Real-Time',
                    style: TextStyle(
                      color: Color(0xFF155DFC),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Real-time Info List
                  Consumer<RsudProvider>(
                    builder: (context, provider, child) {
                      final antrean = provider.lastAntrean;
                      final activePoli = antrean?.poli ?? '';
                      final activeQueueNum = antrean?.nomorAntrean ?? '';

                      debugPrint('RSUD REALTIME LIST: activePoli="$activePoli", activeQueueNum="$activeQueueNum"');

                      final defaultClinics = [
                        {'name': 'Poli Umum', 'count': '15 Antrean', 'estimation': 'Estimasi: 45 menit'},
                        {'name': 'Poli Penyakit Dalam', 'count': '8 Antrean', 'estimation': 'Estimasi: 30 menit'},
                        {'name': 'Poli Anak', 'count': '12 Antrean', 'estimation': 'Estimasi: 40 menit'},
                      ];

                      final List<Map<String, dynamic>> clinicsToRender = [];

                      if (provider.poliklinikList.isEmpty) {
                        for (var item in defaultClinics) {
                          var name = item['name']!;
                          var count = item['count']!;
                          var estimation = item['estimation']!;

                          final isMatch = _isClinicMatch(name, activePoli);
                          if (isMatch && activeQueueNum.isNotEmpty) {
                            count = waitingCount == 0 ? '1 Antrean' : '${waitingCount + 1} Antrean';
                            estimation = waitingCount == 0 ? 'Sedang dilayani' : 'Estimasi: $estimationMinutes menit';
                          }
                          clinicsToRender.add({
                            'name': name,
                            'count': count,
                            'estimation': estimation,
                            'id': 'poli-umum-id',
                            'doctors': <Dokter>[],
                          });
                        }
                      } else {
                        for (var poli in provider.poliklinikList) {
                          final name = 'Poli ${poli.nama}';
                          String count;
                          String estimation;

                          final isMatch = _isClinicMatch(poli.nama, activePoli);
                          if (isMatch && activeQueueNum.isNotEmpty) {
                            count = waitingCount == 0 ? '1 Antrean' : '${waitingCount + 1} Antrean';
                            estimation = waitingCount == 0 ? 'Sedang dilayani' : 'Estimasi: $estimationMinutes menit';
                          } else {
                            final mockData = _getMockDataForClinic(poli.nama);
                            count = mockData['count']!;
                            estimation = mockData['estimation']!;
                          }

                          clinicsToRender.add({
                            'name': name,
                            'count': count,
                            'estimation': estimation,
                            'id': poli.id,
                            'doctors': poli.daftarDokter,
                          });
                        }
                      }

                      final List<Widget> children = [];
                      for (int i = 0; i < clinicsToRender.length; i++) {
                        final item = clinicsToRender[i];
                        children.add(
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RsudLiveQueueDetailScreen(
                                    poliName: item['name']!,
                                    poliId: item['id']!,
                                    doctors: item['doctors'] as List<Dokter>,
                                  ),
                                ),
                              );
                            },
                            child: _buildRealTimeItem(item['name']!, item['count']!, item['estimation']!),
                          ),
                        );
                        if (i < clinicsToRender.length - 1) {
                          children.add(const SizedBox(height: 12));
                        }
                      }
                      return Column(children: children);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0065FF), Color(0xFF004FCC)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.transparent);
                },
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'RSUD Dr Saiful Anwar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildBookmarkButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourQueueCard() {
    return Consumer<RsudProvider>(
      builder: (context, provider, child) {
        final antrean = provider.lastAntrean;
        
        final queueNumber = antrean?.nomorAntrean ?? 'A-023';
        final poliName = antrean?.poli ?? 'Poli Umum';
        final dokterName = antrean?.dokter ?? 'dr. Ahmad Sp.PD';
        final statusText = antrean?.status ?? 'Menunggu';
        final qrData = antrean?.antreanId ?? 'RSUD-ANTREAN-A-023-CHECKIN';
        final estimasiJam = antrean?.estimasiJam ?? '09:45';

        final isDilayani = waitingCount == 0;
        final displayStatus = isDilayani ? 'Dilayani' : statusText;
        final statusColor = isDilayani ? const Color(0xFF10B981) : const Color(0xFF155DFC);
        final statusBgColor = isDilayani ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Ticket Top Section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Antrean Anda',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              queueNumber,
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 40,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 64.0,
                            padding: EdgeInsets.zero,
                            foregroundColor: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          displayStatus[0].toUpperCase() + displayStatus.substring(1),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Decorative Dotted Ticket Divider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: MySeparator(height: 1.5, color: Color(0xFFE2E8F0)),
              ),

              // Ticket Bottom Section (Details)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildDetailRow('Poliklinik:', poliName),
                    const SizedBox(height: 12),
                    _buildDetailRow('Dokter:', dokterName),
                    const SizedBox(height: 12),
                    _buildDetailRow('Sedang dilayani:', currentServing, valueColor: const Color(0xFFF59E0B)),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'Posisi antrean:',
                      isDilayani ? 'Giliran Anda' : '$waitingCount orang lagi',
                      valueColor: isDilayani ? const Color(0xFF10B981) : const Color(0xFF155DFC),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimasi Jam:',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
                            const SizedBox(width: 6),
                            Text(
                              '$estimasiJam WIB',
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tunjukkan QR Code di atas pada mesin check-in RSUD untuk konfirmasi kedatangan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
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

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF1E293B),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNewQueueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ambil Antrean Baru',
            style: TextStyle(
              color: Color(0xFF155DFC),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RsudAmbilAntreanScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pilih Poliklinik & Jadwal',
                    style: TextStyle(
                      color: Color(0xFF717182),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RsudAmbilAntreanScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155DFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Menuju Layar Ambil Antrean',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimeItem(String title, String count, String estimation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF155DFC),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Color(0xFF6A7282)),
                  const SizedBox(width: 4),
                  Text(
                    estimation,
                    style: const TextStyle(
                      color: Color(0xFF6A7282),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              count,
              style: const TextStyle(
                color: Color(0xFF155DFC),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    ModuleProvider? moduleProvider;
    try {
      moduleProvider = Provider.of<ModuleProvider>(context, listen: true);
    } catch (_) {}
    if (moduleProvider == null) {
      return const IconButton(
        icon: Icon(Icons.bookmark_border, color: Colors.white),
        onPressed: null,
      );
    }
    final isFav = moduleProvider.isFavorite('rsud');
    return IconButton(
      icon: Icon(
        isFav ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.white,
      ),
      onPressed: () => moduleProvider!.toggleFavorite('rsud'),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({super.key, this.height = 1, this.color = const Color(0xFFE2E8F0)});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
