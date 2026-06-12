import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:majadigi_superapp_frontend/models/rsud_model.dart';
import 'package:majadigi_superapp_frontend/services/rsud_websocket_service.dart';

class RsudLiveQueueDetailScreen extends StatefulWidget {
  final String poliName;
  final String poliId;
  final List<Dokter> doctors;

  const RsudLiveQueueDetailScreen({
    super.key,
    required this.poliName,
    required this.poliId,
    required this.doctors,
  });

  @override
  State<RsudLiveQueueDetailScreen> createState() => _RsudLiveQueueDetailScreenState();
}

class _RsudLiveQueueDetailScreenState extends State<RsudLiveQueueDetailScreen> with SingleTickerProviderStateMixin {
  final RsudWebSocketService _wsService = RsudWebSocketService();
  StreamSubscription? _subscription;
  late AnimationController _pulseController;

  // Real-time Queue State
  String _currentServing = '-';
  int _waitingCount = 0;
  List<String> _calledNumbers = [];
  bool _isSimulated = false;

  @override
  void initState() {
    super.initState();
    
    // Connect to WebSocket / Local Simulation
    _wsService.connect(widget.poliId);
    
    // Listen to updates
    _subscription = _wsService.queueStream.listen((data) {
      if (mounted) {
        setState(() {
          _currentServing = data['currentServing'] ?? '-';
          _waitingCount = data['waitingCount'] ?? 0;
          _calledNumbers = List<String>.from(data['calledNumbers'] ?? []);
          _isSimulated = data['isSimulated'] ?? false;
        });
      }
    });

    // Pulsing dot animation for connection indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (kIsWeb || !Platform.environment.containsKey('FLUTTER_TEST')) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _wsService.disconnect();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0065FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.poliName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Live Monitoring Antrean',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          // Connection Status Indicator
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _pulseController.value,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isSimulated ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isSimulated ? 'Simulasi' : 'Live WS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header Background Extension
            Container(
              width: double.infinity,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF0065FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Real-time Queue Board (Glow Effect)
                  _buildQueueBoard(),

                  const SizedBox(height: 24),

                  // Called and Waiting List Columns
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Called numbers (Left column)
                      Expanded(
                        child: _buildQueueHistoryCard(
                          title: 'Sudah Dipanggil',
                          icon: Icons.check_circle_outline,
                          iconColor: const Color(0xFF10B981),
                          numbers: _calledNumbers,
                          isStrikethrough: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Waiting numbers (Right column)
                      Expanded(
                        child: _buildQueueWaitingCard(
                          title: 'Daftar Tunggu',
                          icon: Icons.hourglass_empty_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          startNum: _currentServing,
                          count: _waitingCount,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Doctors Section Title
                  const Text(
                    'Dokter Bertugas Hari Ini',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Doctors duty list
                  widget.doctors.isEmpty
                      ? _buildEmptyDoctorsCard()
                      : Column(
                          children: widget.doctors.map((doc) => _buildDoctorCard(doc)).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueBoard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0065FF).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'SEDANG DILAYANI',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Animated Serving Number
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              _currentServing,
              key: ValueKey<String>(_currentServing),
              style: const TextStyle(
                color: Color(0xFF0065FF),
                fontSize: 64,
                fontWeight: FontWeight.w900,
                fontFamily: 'Inter',
                letterSpacing: -1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFDCFCE7)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flash_on, color: Color(0xFF16A34A), size: 16),
                const SizedBox(width: 6),
                Text(
                  'Sisa Antrean: $_waitingCount Orang',
                  style: const TextStyle(
                    color: Color(0xFF15803D),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueHistoryCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> numbers,
    bool isStrikethrough = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          numbers.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      '-',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numbers.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        numbers[idx],
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: isStrikethrough ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildQueueWaitingCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String startNum,
    required int count,
  }) {
    final List<String> waitingNumbers = [];
    if (startNum.isNotEmpty && startNum != '-') {
      final parts = startNum.split('-');
      if (parts.length == 2) {
        final prefix = parts[0];
        final numPart = int.tryParse(parts[1]);
        if (numPart != null) {
          for (int i = 1; i <= 4 && i <= count; i++) {
            waitingNumbers.add('$prefix-${(numPart + i).toString().padLeft(3, '0')}');
          }
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          waitingNumbers.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Tidak ada',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: waitingNumbers.length,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        waitingNumbers[idx],
                        style: const TextStyle(
                          color: Color(0xFF334155),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Dokter doc) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_pin, color: Color(0xFF0065FF), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.nama,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doc.spesialis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      '${doc.jamFormatted} • ${doc.jadwalFormatted}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
  }

  Widget _buildEmptyDoctorsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Center(
        child: Text(
          'Tidak ada dokter bertugas untuk hari ini.',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
        ),
      ),
    );
  }
}
