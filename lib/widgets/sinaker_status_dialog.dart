import 'package:flutter/material.dart';
import 'custom_button.dart';

enum SinakerStatus { sent, failed }

class SinakerStatusDialog extends StatelessWidget {
  final SinakerStatus status;

  const SinakerStatusDialog({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSent = status == SinakerStatus.sent;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isSent ? 'Konfirmasi Berhasil' : 'Konfirmasi Gagal',
                    style: const TextStyle(
                      color: Color(0xFF0A0A0A),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF6A7282), size: 24),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            const SizedBox(height: 32),

            // Status Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isSent ? const Color(0xFFE0EDFF) : const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSent ? Icons.check_circle_rounded : Icons.error_rounded,
                color: isSent ? const Color(0xFF0065FF) : const Color(0xFFD32F2F),
                size: 60,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              isSent ? 'Lamaran Terkirim!' : 'Gagal Mengirim',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSent ? const Color(0xFF0065FF) : const Color(0xFFD32F2F),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                isSent
                    ? 'Lamaran Anda telah berhasil dikirim ke perusahaan. Pantau status lamaran secara berkala di menu Lamaran Saya.'
                    : 'Mohon maaf, terjadi kesalahan sistem saat memproses lamaran Anda. Silakan coba beberapa saat lagi.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4A5565),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: CustomButton(
                text: isSent ? 'Lihat Lamaran Saya' : 'Coba Lagi',
                backgroundColor: isSent ? const Color(0xFF0065FF) : const Color(0xFFD32F2F),
                borderRadius: 12,
                onPressed: () {
                  Navigator.pop(context);
                  if (isSent) {
                    // Logic to navigate or refresh could go here
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showSinakerStatusDialog(BuildContext context, {required SinakerStatus status}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SinakerStatusDialog(status: status),
  );
}
