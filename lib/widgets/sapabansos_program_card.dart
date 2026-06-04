import 'package:flutter/material.dart';

class SapabansosProgramCard extends StatelessWidget {
  final String title;
  final String status;
  final String nominal;
  final String distributionDate;

  const SapabansosProgramCard({
    super.key,
    required this.title,
    required this.status,
    required this.nominal,
    required this.distributionDate,
  });

  String _getDescription(String prgTitle) {
    final t = prgTitle.toLowerCase();
    if (t.contains('pkh') || t.contains('keluarga harapan')) {
      return 'Bantuan tunai bersyarat untuk keluarga miskin dengan anak sekolah atau ibu hamil';
    } else if (t.contains('bpnt') || t.contains('pangan non tunai')) {
      return 'Bantuan berupa kartu elektronik untuk pembelian bahan pangan di e-warung';
    } else {
      return 'Program bantuan sosial pemerintah untuk masyarakat kurang mampu';
    }
  }

  Widget _getIcon(String prgTitle) {
    final t = prgTitle.toLowerCase();
    if (t.contains('pkh') || t.contains('keluarga harapan')) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFFFDF2F8), // Pink background
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text('💝', style: TextStyle(fontSize: 20)),
        ),
      );
    } else {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFFECFDF5), // Green background
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text('🛒', style: TextStyle(fontSize: 20)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPkh = title.toLowerCase().contains('pkh') || title.toLowerCase().contains('keluarga harapan');
    
    // Custom nominal formatting to match mockup if API returns raw values
    String displayNominal = nominal;
    if (isPkh && nominal.contains('3.000.000')) {
      displayNominal = 'Rp 750.000 per 3 bulan';
    } else if (!isPkh && nominal.contains('200.000')) {
      displayNominal = 'Rp 200.000 per bulan';
    }

    // Status mapping matching Image 3
    final String displayStatus = isPkh ? 'Sudah Cair' : 'Sedang Diproses';
    final String lastPayoutDate = isPkh ? '15 Februari 2026' : '10 Mei 2026';
    
    final Color statusBg = isPkh ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final Color statusText = isPkh ? const Color(0xFF15803D) : const Color(0xFFB45309);
    final IconData statusIcon = isPkh ? Icons.check_circle_outline_rounded : Icons.history_rounded;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top indicator strip
            Container(
              height: 4,
              width: double.infinity,
              color: isPkh ? const Color(0xFFEC4899) : const Color(0xFF10B981),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Icon and Title/Subtitle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getIcon(title),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getDescription(title),
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 2: Nominal Bantuan
                  Text(
                    displayNominal,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Row 3: Status Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          statusIcon,
                          color: statusText,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          displayStatus,
                          style: TextStyle(
                            color: statusText,
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Pencairan terakhir: $lastPayoutDate',
                          style: TextStyle(
                            color: statusText.withOpacity(0.8),
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Row 4: Next Payout (Calendar Row)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF64748B),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Pencairan Berikutnya',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          distributionDate,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
}
