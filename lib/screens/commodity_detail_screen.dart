import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';

class CommodityDetailScreen extends StatelessWidget {
  final String name;
  final String price;
  final String unit;

  const CommodityDetailScreen({
    super.key,
    required this.name,
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
          'Analisis Harga',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF101828),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF155DFC),
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  ' / $unit',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Chart Section
            const Text(
              'Tren Perbandingan Harga',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildChartCard(),

            const SizedBox(height: 32),

            // Price Alert Section
            const Text(
              'Atur Pengingat Harga (Price Alert)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF101828),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dapatkan notifikasi otomatis saat harga menyentuh batas yang Anda tentukan.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const CustomTextField(
              hintText: 'Nominal Batas Harga (Misal: 14000)',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.notifications_active_outlined,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Simpan Pengingat',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Pengingat berhasil disimpan'),
                    backgroundColor: const Color(0xFF22C55E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Harga Pasar', const Color(0xFF22C55E)),
              const SizedBox(width: 24),
              _buildLegendItem('Harga Koperasi', const Color(0xFF155DFC)),
            ],
          ),
          const SizedBox(height: 24),
          // Chart Mockup
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: DualLinePainter(),
            ),
          ),
          const SizedBox(height: 16),
          // X-Axis Labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('01 Mei', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('03 Mei', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('05 Mei', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text('07 Mei', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}

class DualLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1;

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Market Line (Green)
    _drawLine(
      canvas,
      size,
      const Color(0xFF22C55E),
      [0.7, 0.65, 0.6, 0.62, 0.55, 0.58, 0.5],
    );

    // Koperasi Line (Blue)
    _drawLine(
      canvas,
      size,
      const Color(0xFF155DFC),
      [0.85, 0.8, 0.75, 0.78, 0.7, 0.72, 0.65],
    );
  }

  void _drawLine(Canvas canvas, Size size, Color color, List<double> values) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = size.width * (i / (values.length - 1));
      final y = size.height * values[i];
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
