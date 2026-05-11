import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

class RsudQueueStatusScreen extends StatefulWidget {
  const RsudQueueStatusScreen({super.key});

  @override
  State<RsudQueueStatusScreen> createState() => _RsudQueueStatusScreenState();
}

class _RsudQueueStatusScreenState extends State<RsudQueueStatusScreen> {
  // Live Tracker State
  String currentServing = 'A-015';
  int waitingCount = 8;
  int estimationMinutes = 25;
  
  // Placeholder for WebSocket/SSE connection
  StreamSubscription? _queueSubscription;

  @override
  void initState() {
    super.initState();
    _initLiveTracker();
  }

  @override
  void dispose() {
    _queueSubscription?.cancel();
    super.dispose();
  }

  void _initLiveTracker() {
    // TODO: Implement WebSocket/SSE Connection (PSN-SRS-03)
    // Example: _queueSubscription = QueueService.getLiveUpdates().listen((data) { ... });
    
    // Simulating real-time updates for demonstration
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          // Mocking a change in queue status
          if (waitingCount > 0) {
            waitingCount--;
            estimationMinutes = waitingCount * 3 + 1;
            // Update current serving number logic...
          }
        });
      }
    });
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
                  _buildRealTimeItem('Poli Umum', '15 Antrean', 'Estimasi: 45 menit'),
                  const SizedBox(height: 12),
                  _buildRealTimeItem('Poli Penyakit Dalam', '8 Antrean', 'Estimasi: 30 menit'),
                  const SizedBox(height: 12),
                  _buildRealTimeItem('Poli Anak', '12 Antrean', 'Estimasi: 40 menit'),
                  const SizedBox(height: 20),
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
                  IconButton(
                    icon: const Icon(Icons.bookmark_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourQueueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: const Color(0xFFF2F2F2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF7F7F7F)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Antrean Anda',
                style: TextStyle(
                  color: Color(0xFF155DFC),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              QrImageView(
                data: 'RSUD-ANTREAN-A-023-CHECKIN',
                version: QrVersions.auto,
                size: 60.0,
                padding: EdgeInsets.zero,
                foregroundColor: const Color(0xFF155DFC),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'A-023',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF155DFC),
              fontSize: 48,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF155DFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Menunggu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow('Poliklinik:', 'Poli Umum'),
          const SizedBox(height: 12),
          _buildDetailRow('Sedang dilayani:', currentServing),
          const SizedBox(height: 12),
          _buildDetailRow('Posisi antrean:', '$waitingCount orang lagi'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimasi:',
                style: TextStyle(
                  color: Color(0xFF4A5565),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Color(0xFF155DFC)),
                  const SizedBox(width: 4),
                  Text(
                    '$estimationMinutes menit',
                    style: const TextStyle(
                      color: Color(0xFF155DFC),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tunjukkan QR Code di atas pada mesin check-in RSUD untuk konfirmasi kedatangan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6A7282),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF155DFC),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
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
          Container(
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
                  'Pilih Poliklinik',
                  style: TextStyle(
                    color: Color(0xFF717182),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.black.withOpacity(0.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155DFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Ambil Nomor Antrean',
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
}
