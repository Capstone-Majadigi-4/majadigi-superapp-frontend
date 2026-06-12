import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/screens/payment_completed_screen.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final String amount;
  final Widget? nextScreen;

  const PaymentSuccessDialog({
    super.key,
    required this.amount,
    this.nextScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Close Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Pembayaran Pajak Kendaraan',
                    style: TextStyle(
                      color: Color(0xFF0A0A0A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFF6A7282), size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF00A63E),
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            // Success Text
            const Text(
              'Pembayaran Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF00A63E),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 12),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Transaksi Anda telah berhasil diproses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF4A5565),
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Total Paid Box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Dibayar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4A5565),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF00A63E),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: 'Selesai',
                backgroundColor: const Color(0xFF00A63E),
                onPressed: () {
                  final navigator = Navigator.of(context);
                  navigator.pop(); // Close dialog
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) => nextScreen ?? PaymentCompletedScreen(
                        amount: amount,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Function to show the dialog
void showPaymentSuccessDialog(BuildContext context, {required String amount, Widget? nextScreen}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PaymentSuccessDialog(amount: amount, nextScreen: nextScreen),
  );
}
