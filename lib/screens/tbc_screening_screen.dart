import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import '../providers/etibi_provider.dart';
import '../models/etibi_model.dart';
import '../widgets/custom_button.dart';
import 'tbc_questions_screen.dart';

class TbcScreeningScreen extends StatefulWidget {
  const TbcScreeningScreen({super.key});

  @override
  State<TbcScreeningScreen> createState() => _TbcScreeningScreenState();
}

class _TbcScreeningScreenState extends State<TbcScreeningScreen> {
  int _activeTabIndex = 0; // 0 for Skrining, 1 for Pengingat Obat

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EtibiProvider>();
      provider.fetchLastScreeningResult();
      provider.fetchAdherenceStatus();
      provider.fetchCalendarEntries();
      provider.fetchQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EtibiProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0046B2),
      body: Stack(
        children: [
          // Header background with gradient
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0078FF), Color(0xFF0046B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Skrining TBC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Layanan Skrining Mandiri TBC',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<ModuleProvider>(
                      builder: (context, moduleProvider, _) {
                        final isFav = moduleProvider.isFavorite('tbc');
                        return GestureDetector(
                          onTap: () => moduleProvider.toggleFavorite('tbc'),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.star_rounded : Icons.star_border_rounded,
                              color: isFav ? const Color(0xFFF59E0B) : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🩺', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 110,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC), 
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  _buildTabSelector(),
                  Expanded(
                    child: _activeTabIndex == 0
                        ? _buildSkriningTab(provider)
                        : _buildReminderTab(provider),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTabIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _activeTabIndex == 0 ? const Color(0xFF0065FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: _activeTabIndex == 0 ? Colors.white : const Color(0xFF4A5565),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Skrining',
                      style: TextStyle(
                        color: _activeTabIndex == 0 ? Colors.white : const Color(0xFF4A5565),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTabIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _activeTabIndex == 1 ? const Color(0xFF0065FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: _activeTabIndex == 1 ? Colors.white : const Color(0xFF4A5565),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pengingat Obat',
                      style: TextStyle(
                        color: _activeTabIndex == 1 ? Colors.white : const Color(0xFF4A5565),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkriningTab(EtibiProvider provider) {
    final questionsCount = provider.questions.isNotEmpty ? provider.questions.length : 6;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0072FF).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('🩺', style: TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Skrining TBC Gratis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Jawab $questionsCount pertanyaan sederhana untuk mendeteksi risiko Tuberkulosis (TBC) secara dini. Hanya butuh 2-3 menit.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBadge(
                        icon: const Text('⏱️', style: TextStyle(fontSize: 24)),
                        text: '2-3 menit',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoBadge(
                        icon: const Text(
                          '?',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        text: '$questionsCount pertanyaan',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoBadge(
                        icon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'FREE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        text: 'Gratis',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFDE68A),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFD97706),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Disclaimer',
                            style: TextStyle(
                              color: Color(0xFFB45309),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Hasil skrining ini bukan diagnosis medis. Untuk kepastian, konsultasikan ke dokter atau tenaga kesehatan.',
                        style: TextStyle(
                          color: Color(0xFFB45309),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TbcQuestionsScreen()),
                      ).then((_) {
                        provider.fetchLastScreeningResult();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0065FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Mulai Skrining',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (provider.lastScreeningResult != null) ...[
            const SizedBox(height: 16),
            _buildLastResultCard(provider.lastScreeningResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBadge({required Widget icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastResultCard(bool isAtRisk) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAtRisk ? const Color(0xFFFFF1F2) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAtRisk ? const Color(0xFFFECDD3) : const Color(0xFFBBF7D0),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAtRisk ? const Color(0xFFFFE4E6) : const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAtRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
              color: isAtRisk ? const Color(0xFFE11D48) : const Color(0xFF16A34A),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAtRisk ? 'Hasil Skrining: Berisiko TBC' : 'Hasil Skrining: Risiko Rendah',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: isAtRisk ? const Color(0xFF9F1239) : const Color(0xFF166534),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAtRisk 
                      ? 'Gejala yang Anda rasakan mengindikasikan risiko TBC. Silakan segera periksakan diri ke Puskesmas terdekat.'
                      : 'Anda dalam kondisi sehat dan berisiko rendah. Tetap jaga protokol kesehatan dan pola hidup bersih.',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: isAtRisk ? const Color(0xFFBE123C) : const Color(0xFF15803D),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTab(EtibiProvider provider) {
    if (provider.isLoading && provider.adherenceStatus == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(provider),
          const SizedBox(height: 20),
          _buildReminderCard(provider),
          const SizedBox(height: 20),
          _buildHistorySection(provider),
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
                    fontFamily: 'Inter',
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
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage > 100 ? 1.0 : (percentage < 0 ? 0.0 : percentage / 100),
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
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Setiap hari pukul $reminderTime',
                          style: const TextStyle(
                            color: Color(0xFF4A5565),
                            fontSize: 14,
                            fontFamily: 'Inter',
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
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontFamily: 'Inter'),
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
                  fontFamily: 'Inter',
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
                fontFamily: 'Inter',
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
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

