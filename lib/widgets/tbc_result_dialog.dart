import 'package:flutter/material.dart';
import 'custom_button.dart';

class TbcResultDialog extends StatelessWidget {
  final bool isAtRisk;

  const TbcResultDialog({
    super.key,
    required this.isAtRisk,
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
                    'Hasil Skrining',
                    style: TextStyle(
                      color: const Color(0xFF0A0A0A),
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

            // Result Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isAtRisk ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isAtRisk ? Icons.warning_rounded : Icons.check_circle_rounded,
                color: isAtRisk ? const Color(0xFFEA580C) : const Color(0xFF16A34A),
                size: 60,
              ),
            ),

            const SizedBox(height: 24),

            // Status Text
            Text(
              isAtRisk ? 'Anda Berisiko TBC' : 'Anda Sehat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isAtRisk ? const Color(0xFFEA580C) : const Color(0xFF16A34A),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                isAtRisk
                    ? 'Berdasarkan jawaban Anda, terdapat indikasi gejala TBC. Segera lakukan pemeriksaan di fasilitas kesehatan terdekat.'
                    : 'Berdasarkan jawaban Anda, Anda tidak menunjukkan gejala TBC. Tetap jaga pola hidup sehat dan kebersihan lingkungan.',
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
                text: isAtRisk ? 'Cari Layanan Kesehatan' : 'Selesai',
                backgroundColor: isAtRisk ? const Color(0xFFEA580C) : const Color(0xFF16A34A),
                borderRadius: 12,
                onPressed: () {
                  Navigator.pop(context);
                  if (!isAtRisk) {
                    Navigator.pop(context); // Go back to main TBC screen
                  } else {
                    // Logic for finding health service could go here
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

void showTbcResultDialog(BuildContext context, {required bool isAtRisk}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => TbcResultDialog(isAtRisk: isAtRisk),
  );
}
