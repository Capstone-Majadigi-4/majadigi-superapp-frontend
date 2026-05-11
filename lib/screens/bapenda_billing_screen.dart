import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/payment_qr_dialog.dart';

class BapendaBillingScreen extends StatelessWidget {
  final String platNomor;
  final String merk;

  const BapendaBillingScreen({
    super.key,
    required this.platNomor,
    required this.merk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF), // Header Biru
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Konten Utama
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Card Detail Kendaraan
                            _buildVehicleDetailCard(),
                            
                            const SizedBox(height: 24),
                            
                            // Card Rincian Biaya
                            _buildBillingDetailCard(),
                          ],
                        ),
                      ),
                    ),
                    
                    // Bagian Bawah (Bottom Navigation / Footer)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            offset: const Offset(0, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: CustomButton(
                          text: 'Bayar Sekarang',
                          onPressed: () {
                            showPaymentQrDialog(
                              context,
                              amount: 'Rp 185.000',
                              agencyName: 'Bapenda Jatim',
                            );
                          },
                        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rincian Tagihan Pajak',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  platNomor,
                  style: const TextStyle(
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

  Widget _buildVehicleDetailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                platNomor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                  fontFamily: 'Inter',
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Segera Bayar',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            merk,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6A7282),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 20),
          
          // Yellow Due Date Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3).withValues(alpha: 0.4), // Very light yellow
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFEF08A)), // Yellow border
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: Color(0xFFCA8A04), size: 20), // Golden yellow icon
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Jatuh Tempo Pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCA8A04),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '20 April 2025', // Use a static dummy that matches the reference vibe
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA16207),
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
    );
  }

  Widget _buildBillingDetailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Biaya',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          
          _buildBillingRow('Pokok PKB', 'Rp 250.000'),
          const SizedBox(height: 12),
          _buildBillingRow('SWDKLLJ', 'Rp 35.000'),
          const SizedBox(height: 12),
          _buildBillingRow('Biaya Admin', 'Rp 5.000'),
          const SizedBox(height: 12),
          _buildBillingRow('Denda', 'Rp 0'),
          
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB), thickness: 1),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Tagihan', // Disesuaikan dengan reference
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Rp 185.000', // Disesuaikan dengan reference
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF155DFC), // Biru cerah Majadigi
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Sumber Data Footer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFF155DFC), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sumber Data : Badan Pendapatan Daerah\nProvinsi Jawa Timur',
                  style: TextStyle(
                    color: const Color(0xFF155DFC).withValues(alpha: 0.8),
                    fontSize: 11,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4A5565),
            fontFamily: 'Inter',
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF101828),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
