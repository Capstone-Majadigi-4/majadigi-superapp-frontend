import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/transjatim_provider.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/payment_success_dialog.dart';
import 'transjatim_payment_success_screen.dart';

class TransjatimPaymentScreen extends StatefulWidget {
  final String corridorId;
  final String amount;
  final String corridorName;

  const TransjatimPaymentScreen({
    super.key,
    required this.corridorId,
    required this.amount,
    required this.corridorName,
  });

  @override
  State<TransjatimPaymentScreen> createState() => _TransjatimPaymentScreenState();
}

class _TransjatimPaymentScreenState extends State<TransjatimPaymentScreen> {
  Timer? _timer;
  int _secondsRemaining = 291; // 4 minutes 51 seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: -3,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Title
                const Text(
                  'E-Ticket Transjatim',
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Destinasi Wisata Jawa Timur', // Based on snippet
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF6A7282),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Timer Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, color: Color(0xFF155DFC), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(
                          color: Color(0xFF155DFC),
                          fontSize: 18,
                          fontFamily: 'Consolas',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // QR Code Container
                Container(
                  width: 256,
                  height: 256,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDBEAFE), width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/Transjastim/QRCodeSVG.png',
                    fit: BoxFit.contain,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Payment Amount Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFF6FF), Color(0xFFFAF5FF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          color: Color(0xFF4A5565),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.amount,
                        style: const TextStyle(
                          color: Color(0xFF155DFC),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Scan QR Code dengan aplikasi pembayaran Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                 CustomButton(
                  text: 'Saya Sudah Membayar',
                  icon: Icons.check_circle_outline,
                  backgroundColor: const Color(0xFF155DFC),
                  height: 48,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  onPressed: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    final res = await context.read<TransJatimProvider>().purchaseTicket(widget.corridorId, 1);

                    // Dismiss loading indicator
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    if (res != null) {
                      if (context.mounted) {
                        showPaymentSuccessDialog(
                          context,
                          amount: widget.amount,
                          nextScreen: const TransjatimPaymentSuccessScreen(),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        final provider = context.read<TransJatimProvider>();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage ?? 'Gagal membeli tiket'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Batalkan Pembayaran',
                  backgroundColor: Colors.white,
                  borderColor: Colors.black.withOpacity(0.1),
                  textColor: const Color(0xFF0A0A0A),
                  height: 48,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
