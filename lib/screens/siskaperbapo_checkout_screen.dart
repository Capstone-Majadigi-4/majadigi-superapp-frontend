import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';

class SiskaperbapoCheckoutScreen extends StatelessWidget {
  final String commodityName;
  final String price;
  final String unit;

  const SiskaperbapoCheckoutScreen({
    super.key,
    required this.commodityName,
    required this.price,
    required this.unit,
  });

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
        title: const Text(
          'Checkout Sembako Subsidi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zero Data Entry Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: Color(0xFF155DFC), size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Identitas Anda telah terverifikasi via SSO NIK. Tidak perlu mengisi data diri lagi.',
                            style: TextStyle(
                              color: Color(0xFF1E40AF),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Item Card
                  const Text(
                    'Item yang Dibeli',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildItemCard(),

                  const SizedBox(height: 24),

                  // Subsidy Info Card
                  const Text(
                    'Informasi Kuota Subsidi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSubsidyCard(),

                  const SizedBox(height: 24),

                  // Price Breakdown
                  const Text(
                    'Rincian Biaya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPriceBreakdown(),
                ],
              ),
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Bayar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A7282),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Rp 13.800',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF155DFC),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Bayar Sekarang',
                    onPressed: () {
                      // Logic for payment
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage("https://placehold.co/60x60"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commodityName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
                Text(
                  'Kuantitas: 1 $unit',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Rp 15.000',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101828),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsidyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sisa Kuota Anda (Bulan Ini)',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF166534),
                ),
              ),
              const Text(
                '4 / 5 kg',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.white,
            color: const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          _buildPriceRow('Harga Normal', 'Rp 15.000'),
          const SizedBox(height: 12),
          _buildPriceRow('Potongan Subsidi Koperasi', '- Rp 1.200', isDiscount: true),
          const SizedBox(height: 12),
          _buildPriceRow('Biaya Admin', 'Rp 0'),
          const Divider(height: 24),
          _buildPriceRow('Total', 'Rp 13.800', isBold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isBold ? const Color(0xFF101828) : const Color(0xFF6A7282),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isDiscount ? const Color(0xFF166534) : const Color(0xFF101828),
            fontWeight: isBold || isDiscount ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
