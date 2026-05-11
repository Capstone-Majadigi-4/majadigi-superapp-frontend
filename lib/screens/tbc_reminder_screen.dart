import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class TbcReminderScreen extends StatefulWidget {
  const TbcReminderScreen({super.key});

  @override
  State<TbcReminderScreen> createState() => _TbcReminderScreenState();
}

class _TbcReminderScreenState extends State<TbcReminderScreen> {
  bool _isReminderOn = true;

  final List<Map<String, dynamic>> _history = [
    {'date': '4 Apr', 'status': 'Sudah', 'isDone': true},
    {'date': '3 Apr', 'status': 'Terlewat', 'isDone': false},
    {'date': '2 Apr', 'status': 'Sudah', 'isDone': true},
    {'date': '1 Apr', 'status': 'Sudah', 'isDone': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 200,
            width: double.infinity,
            color: const Color(0xFF0065FF),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Pengingat Pengobatan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusCard(),
                          const SizedBox(height: 20),
                          _buildReminderCard(),
                          const SizedBox(height: 20),
                          _buildHistorySection(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.33),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status Pengobatan',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A63E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '95%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Kepatuhan Minum Obat',
            style: TextStyle(
              color: Color(0xFF4A5565),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          // Progress Bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.95,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00A63E),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Progress', '75/180 hari'),
          const SizedBox(height: 12),
          _buildInfoRow('Mulai Pengobatan', '15 Januari 2025'),
        ],
      ),
    );
  }

  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.33),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengingat Harian',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: _isReminderOn,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0065FF),
                onChanged: (val) {
                  setState(() {
                    _isReminderOn = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Color(0xFFDB2777), size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Waktu Minum Obat',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Setiap hari pukul 08:00',
                      style: TextStyle(
                        color: const Color(0xFF4A5565),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Sudah Minum Obat Hari Ini',
            borderRadius: 10,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Minum Obat',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ..._history.map((item) => _buildHistoryItem(item)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                item['isDone'] ? Icons.check_circle : Icons.error,
                color: item['isDone'] ? const Color(0xFF0065FF) : const Color(0xFFD4183D),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                item['date'],
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: item['isDone'] ? const Color(0xFF0065FF) : const Color(0xFFD4183D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item['isDone'] ? '✓ Sudah' : '✗ Terlewat',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
