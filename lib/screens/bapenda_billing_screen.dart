import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapenda_provider.dart';
import 'package:majadigi_superapp_frontend/models/bapenda_model.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/payment_qr_dialog.dart';
import 'payment_completed_screen.dart';

class BapendaBillingScreen extends StatefulWidget {
  final String platNomor;
  final String merk;

  const BapendaBillingScreen({
    super.key,
    required this.platNomor,
    required this.merk,
  });

  @override
  State<BapendaBillingScreen> createState() => _BapendaBillingScreenState();
}

class _BapendaBillingScreenState extends State<BapendaBillingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BapendaProvider>(context, listen: false);
      if (provider.currentBill == null || provider.currentBill!.platNomor != widget.platNomor) {
        provider.fetchBillDetail(widget.platNomor);
      }
    });
  }

  String _formatMoney(double amount) {
    final str = amount.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF),
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
                child: Consumer<BapendaProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoadingBill) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
                        ),
                      );
                    }

                    final bill = provider.currentBill;
                    if (bill == null) {
                      return const Center(
                        child: Text('Data tagihan tidak ditemukan'),
                      );
                    }

                    final isPaid = bill.statusBayar.toLowerCase() == 'lunas';

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                // Card Detail Kendaraan
                                _buildVehicleDetailCard(bill),
                                
                                const SizedBox(height: 24),
                                
                                // Card Rincian Biaya
                                _buildBillingDetailCard(bill),
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
                              text: isPaid ? 'Pembayaran Selesai' : 'Bayar Sekarang',
                              backgroundColor: isPaid ? const Color(0xFF10B981) : const Color(0xFF0065FF),
                              onPressed: isPaid 
                                  ? () => Navigator.pop(context, true)
                                  : () {
                                      showPaymentQrDialog(
                                        context,
                                        amount: 'Rp ${_formatMoney(bill.totalTagihan)}',
                                        agencyName: 'Bapenda Jatim',
                                        onConfirm: () {
                                          provider.payVehicleBill(widget.platNomor);
                                        },
                                        nextScreen: PaymentCompletedScreen(
                                          amount: 'Rp ${_formatMoney(bill.totalTagihan)}',
                                          platNomor: widget.platNomor,
                                          vehicleInfo: '${bill.merk} / ${bill.tipe}',
                                        ),
                                      );
                                    },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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
                  widget.platNomor,
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

  Widget _buildVehicleDetailCard(BapendaBillDetail bill) {
    final isPaid = bill.statusBayar.toLowerCase() == 'lunas';

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
                widget.platNomor,
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
                  color: isPaid ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPaid ? 'Lunas' : 'Segera Bayar',
                  style: TextStyle(
                    color: isPaid ? const Color(0xFF047857) : const Color(0xFFEF4444),
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
            '${bill.merk} / ${bill.tipe}',
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
              color: isPaid 
                  ? const Color(0xFFECFDF5) 
                  : const Color(0xFFFEF9C3).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPaid ? const Color(0xFFA7F3D0) : const Color(0xFFFEF08A),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPaid ? Icons.check_circle_rounded : Icons.calendar_today_rounded,
                  color: isPaid ? const Color(0xFF059669) : const Color(0xFFCA8A04),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPaid ? 'Status Pembayaran' : 'Jatuh Tempo Pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: isPaid ? const Color(0xFF047857) : const Color(0xFFCA8A04),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPaid ? 'Lunas' : bill.jatuhTempo,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isPaid ? const Color(0xFF047857) : const Color(0xFFA16207),
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

  Widget _buildBillingDetailCard(BapendaBillDetail bill) {
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
          
          _buildBillingRow('Pokok PKB', 'Rp ${_formatMoney(bill.pkbPokok)}'),
          const SizedBox(height: 12),
          _buildBillingRow('SWDKLLJ', 'Rp ${_formatMoney(bill.swdkljj)}'),
          const SizedBox(height: 12),
          _buildBillingRow('Biaya Admin', 'Rp ${_formatMoney(bill.biayaAdmin)}'),
          const SizedBox(height: 12),
          _buildBillingRow('Denda', 'Rp ${_formatMoney(bill.denda)}'),
          
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB), thickness: 1),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Tagihan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF101828),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Rp ${_formatMoney(bill.totalTagihan)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF155DFC),
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
