import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';
import '../providers/etibi_provider.dart';
import '../models/etibi_model.dart';

class TbcReminderScreen extends StatefulWidget {
  const TbcReminderScreen({super.key});

  @override
  State<TbcReminderScreen> createState() => _TbcReminderScreenState();
}

class _TbcReminderScreenState extends State<TbcReminderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EtibiProvider>();
      provider.fetchAdherenceStatus();
      provider.fetchCalendarEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EtibiProvider>(context);

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
                    child: provider.isLoading && provider.adherenceStatus == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildStatusCard(provider),
                                const SizedBox(height: 20),
                                _buildReminderCard(provider),
                                const SizedBox(height: 20),
                                _buildHistorySection(provider),
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

  Widget _buildStatusCard(EtibiProvider provider) {
    final status = provider.adherenceStatus;
    final percentage = status?.adherencePercentage ?? 0;
    final progress = status?.currentProgress ?? '0/180 hari';
    final startDate = status?.startDate ?? '-';

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
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
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
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00A63E),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Progress', progress),
          const SizedBox(height: 12),
          _buildInfoRow('Mulai Pengobatan', startDate),
        ],
      ),
    );
  }

  Widget _buildReminderCard(EtibiProvider provider) {
    final status = provider.adherenceStatus;
    final isReminderOn = status?.isReminderEnabled ?? false;
    final reminderTime = status?.dailyReminderTime ?? '08:00';

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
                value: isReminderOn,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0065FF),
                onChanged: (val) {
                  provider.toggleReminder(val);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              if (status == null) return;
              
              final parts = reminderTime.split(':');
              int hour = 8;
              int minute = 0;
              if (parts.length == 2) {
                hour = int.tryParse(parts[0]) ?? 8;
                minute = int.tryParse(parts[1]) ?? 0;
              }

              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hour, minute: minute),
              );

              if (pickedTime != null) {
                final formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                provider.updateReminderTime(formattedTime);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF2F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFFDB2777), size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
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
                          'Setiap hari pukul $reminderTime',
                          style: const TextStyle(
                            color: Color(0xFF4A5565),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_calendar_rounded, color: Color(0xFFDB2777), size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: provider.isLoading ? 'Menyimpan...' : 'Sudah Minum Obat Hari Ini',
            borderRadius: 10,
            onPressed: provider.isLoading
                ? () {}
                : () async {
                    final success = await provider.confirmMedicationIntake();
                    if (mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ Konfirmasi berhasil! Kepatuhan Anda meningkat.'),
                            backgroundColor: Color(0xFF00A63E),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal melakukan konfirmasi minum obat.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(EtibiProvider provider) {
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
        if (provider.calendarEntries.isEmpty)
          const Text(
            'Belum ada riwayat konsumsi obat.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          )
        else
          ...provider.calendarEntries.map((item) => _buildHistoryItem(item)).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(MedicationCalendarEntry item) {
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
                item.isDone ? Icons.check_circle : Icons.error,
                color: item.isDone ? const Color(0xFF0065FF) : const Color(0xFFD4183D),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                item.date,
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
              color: item.isDone ? const Color(0xFF0065FF) : const Color(0xFFD4183D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.isDone ? '✓ Sudah' : '✗ Terlewat',
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
