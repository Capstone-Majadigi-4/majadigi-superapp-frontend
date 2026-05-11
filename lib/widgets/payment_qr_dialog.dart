import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/payment_success_dialog.dart';

class PaymentQrDialog extends StatelessWidget {
  final String amount;
  final String agencyName;

  const PaymentQrDialog({
    super.key,
    required this.amount,
    required this.agencyName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Pembayaran Pajak Kendaraan',
                        style: TextStyle(
                          color: Color(0xFF0A0A0A),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Waktu pembayaran tersisa',
                        style: TextStyle(
                          color: Color(0xFF717182),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFF0A0A0A), size: 20),
                    ),
                  ),
                ],
              ),
            ),
            
            // Timer Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.access_time, color: Color(0xFF155DFC), size: 18),
                  SizedBox(width: 8),
                  Text(
                    '04 : 51',
                    style: TextStyle(
                      color: Color(0xFF155DFC),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // QR Code Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 48),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDBEAFE), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDBEAFE).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=MAJADIGI-PAYMENT'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Amount Details
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF0F6FF), Color(0xFFF9F5FF)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      color: Color(0xFF6A7282),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      color: Color(0xFF155DFC),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agencyName,
                    style: const TextStyle(
                      color: Color(0xFF6A7282),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              'Scan QR Code dengan aplikasi pembayaran Anda',
              style: TextStyle(
                color: Color(0xFF717182),
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Unduh QR Code',
                    icon: Icons.file_download_outlined,
                    backgroundColor: const Color(0xFF155DFC),
                    height: 44,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    onPressed: () {
                      Navigator.pop(context); // Close QR dialog
                      showPaymentSuccessDialog(context, amount: amount);
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Batalkan Pembayaran',
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xFFE5E7EB),
                    textColor: const Color(0xFF0A0A0A),
                    height: 44,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
    );
  }
}

// Function to show the dialog
void showPaymentQrDialog(BuildContext context, {required String amount, required String agencyName}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => PaymentQrDialog(
      amount: amount,
      agencyName: agencyName,
    ),
  );
}
