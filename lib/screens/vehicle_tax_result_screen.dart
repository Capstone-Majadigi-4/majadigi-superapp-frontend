import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';

class VehicleTaxResultScreen extends StatelessWidget {
  final String? platNomor;
  final String? merk;

  const VehicleTaxResultScreen({
    super.key,
    this.platNomor,
    this.merk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF), // Primary Blue
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context),

            // Main Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // The Result Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Vehicle Info Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.directions_car_filled_rounded, color: Color(0xFF16A34A), size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          platNomor ?? 'Nilai Jual SEDAN',
                                          style: const TextStyle(
                                            color: Color(0xFF101828),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        Text(
                                          merk ?? 'Mobil - Sedan - BMW',
                                          style: const TextStyle(
                                            color: Color(0xFF6A7282),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_rounded, color: Color(0xFF6A7282), size: 14),
                                            const SizedBox(width: 4),
                                            const Text(
                                              '6 April 2026 pukul 07.42',
                                              style: TextStyle(
                                                color: Color(0xFF6A7282),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Divider
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: const Color(0xFFF3F4F6),
                            ),

                            // 2. Chart Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.bar_chart_rounded, color: Color(0xFF0065FF), size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Grafik Tren Harga',
                                        style: TextStyle(
                                          color: Color(0xFF101828),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  // Simplified Chart Placeholder
                                  SizedBox(
                                    height: 180,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildChartBar('2023', 0.6, '150 jt'),
                                        _buildChartBar('2024', 0.75, '180 jt'),
                                        _buildChartBar('2025', 0.9, '200 jt'),
                                        _buildChartBar('2026', 1.0, '220 jt', isActive: true),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Divider
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: const Color(0xFFF3F4F6),
                            ),

                            // 3. Price Summary Section
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Harga Kisaran Jual',
                                    style: TextStyle(
                                      color: Color(0xFF4A5565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const Text(
                                    'Rp 200 jt - 220 jt',
                                    style: TextStyle(
                                      color: Color(0xFF00A63E),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Bottom Button to go back or start new search
                      CustomButton(
                        text: 'Kembali',
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bapenda Jatim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Pembayaran Pajak Daerah',
                  style: TextStyle(
                    color: Color(0xFFDBEAFE),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double heightPercent, String value, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isActive ? const Color(0xFF0065FF) : const Color(0xFF999999),
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 120 * heightPercent,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0065FF) : const Color(0xFFE5E7EB),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 11,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
