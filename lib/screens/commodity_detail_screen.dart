import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';
import 'package:majadigi_superapp_frontend/providers/bapok_provider.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_textfield.dart';


class CommodityDetailScreen extends StatefulWidget {
  final Komoditas komoditas;

  const CommodityDetailScreen({
    super.key,
    required this.komoditas,
  });

  @override
  State<CommodityDetailScreen> createState() => _CommodityDetailScreenState();
}

class _CommodityDetailScreenState extends State<CommodityDetailScreen> {
  final TextEditingController _alertController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BapokProvider>(context, listen: false)
          .fetchHargaHistori(widget.komoditas.id);
    });
  }

  @override
  void dispose() {
    _alertController.dispose();
    super.dispose();
  }

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
        actions: const [],
      ),
      body: Consumer<BapokProvider>(
        builder: (context, provider, child) {
          double headerPrice = widget.komoditas.hargaRataRata;
          if (provider.priceHistory.isNotEmpty) {
            String latestDate = '';
            for (final h in provider.priceHistory) {
              if (h.tanggal.compareTo(latestDate) > 0) {
                latestDate = h.tanggal;
              }
            }
            final latestEntries = provider.priceHistory.where((h) => h.tanggal == latestDate).toList();
            if (latestEntries.isNotEmpty) {
              final sum = latestEntries.map((e) => e.harga).reduce((a, b) => a + b);
              headerPrice = sum / latestEntries.length;
            }
          }
          final formattedPrice = _formatCurrency(headerPrice);

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Text(
                      widget.komoditas.nama,
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
                          formattedPrice,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF155DFC),
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          ' / Per ${widget.komoditas.satuan}',
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
                    _buildChartCard(provider),
                    if (provider.priceHistory.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _buildMarketPricesSection(provider),
                    ],
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
                    CustomTextField(
                      controller: _alertController,
                      hintText: 'Nominal Batas Harga (Misal: 14000)',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.notifications_active_outlined,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: provider.isCreatingAlert ? 'Menyimpan...' : 'Simpan Pengingat',
                      onPressed: provider.isCreatingAlert
                          ? () {}
                          : () async {
                              final text = _alertController.text.trim();
                              final nominal = double.tryParse(text);
                              if (nominal == null || nominal <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Silakan masukkan nominal batas harga yang valid'),
                                    backgroundColor: const Color(0xFFEF4444),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                return;
                              }

                              final tipe = nominal < headerPrice
                                  ? 'turun_dibawah'
                                  : 'naik_diatas';

                              final success = await provider.createPriceAlert(
                                widget.komoditas.id,
                                nominal,
                                tipe,
                              );

                              if (!mounted) return;

                              if (success) {
                                _alertController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Pengingat harga berhasil disimpan'),
                                    backgroundColor: const Color(0xFF22C55E),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      provider.errorCreatingAlert ?? 'Gagal menyimpan pengingat harga',
                                    ),
                                    backgroundColor: const Color(0xFFEF4444),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChartCard(BapokProvider provider) {
    if (provider.isLoadingHistory) {
      return Container(
        width: double.infinity,
        height: 280,
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
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
          ),
        ),
      );
    }

    final history = provider.priceHistory;
    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        height: 280,
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart_outlined, size: 40, color: Color(0xFF94A3B8)),
              SizedBox(height: 8),
              Text(
                'Tidak ada data tren harga',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group by date and calculate daily average for Harga Pasar, and subsidized coop price
    final Map<String, List<double>> grouped = {};
    for (final h in history) {
      grouped.putIfAbsent(h.tanggal, () => []).add(h.harga);
    }

    final sortedDates = grouped.keys.toList()..sort();
    final List<double> marketPrices = [];
    final List<double> coopPrices = [];

    for (final date in sortedDates) {
      final list = grouped[date]!;
      final avg = list.reduce((a, b) => a + b) / list.length;
      marketPrices.add(avg);
      coopPrices.add(avg * 0.90);
    }

    // Scale values to ratios between 0.2 and 0.8
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    for (final p in [...marketPrices, ...coopPrices]) {
      if (p < minPrice) minPrice = p;
      if (p > maxPrice) maxPrice = p;
    }

    final List<double> marketRatios = [];
    final List<double> coopRatios = [];
    final range = maxPrice - minPrice;

    for (int i = 0; i < marketPrices.length; i++) {
      if (range == 0) {
        marketRatios.add(0.5);
        coopRatios.add(0.6);
      } else {
        marketRatios.add(0.8 - (marketPrices[i] - minPrice) / range * 0.6);
        coopRatios.add(0.8 - (coopPrices[i] - minPrice) / range * 0.6);
      }
    }

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
          // Chart
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: DualLinePainter(
                marketRatios: marketRatios,
                coopRatios: coopRatios,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // X-Axis Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: sortedDates.map((date) {
              return Text(
                _formatDateLabel(date),
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              );
            }).toList(),
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

  String _formatDateLabel(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[2]);
        final monthIndex = int.parse(parts[1]);
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
        return '$day ${months[monthIndex - 1]}';
      }
    } catch (_) {}
    return dateStr;
  }

  String _formatCurrency(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _formatFullDateLabel(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final monthIndex = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        const months = [
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'Oktober',
          'November',
          'Desember'
        ];
        if (monthIndex >= 1 && monthIndex <= 12) {
          return '$day ${months[monthIndex - 1]} $year';
        }
      }
    } catch (_) {}
    return dateStr;
  }

  Widget _buildMarketPricesSection(BapokProvider provider) {
    final history = provider.priceHistory;
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find the latest date
    String latestDate = '';
    for (final h in history) {
      if (h.tanggal.compareTo(latestDate) > 0) {
        latestDate = h.tanggal;
      }
    }

    // Filter items for the latest date
    final latestEntries = history.where((h) => h.tanggal == latestDate).toList();
    if (latestEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find min and max prices
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    for (final entry in latestEntries) {
      if (entry.harga < minPrice) minPrice = entry.harga;
      if (entry.harga > maxPrice) maxPrice = entry.harga;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Harga di Pasar Tradisional',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF101828),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pembaruan Terakhir: ${_formatFullDateLabel(latestDate)}',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: latestEntries.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFF1F5F9),
              height: 24,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final entry = latestEntries[index];
              final isMin = entry.harga == minPrice && minPrice != maxPrice;
              final isMax = entry.harga == maxPrice && minPrice != maxPrice;

              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.namaPasar,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (isMin || isMax) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isMin
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isMin ? 'Termurah' : 'Tertinggi',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isMin
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFFB91C1C),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(entry.harga),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class DualLinePainter extends CustomPainter {
  final List<double> marketRatios;
  final List<double> coopRatios;

  DualLinePainter({
    required this.marketRatios,
    required this.coopRatios,
  });

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

    if (marketRatios.length >= 2) {
      // Market Line (Green)
      _drawLine(
        canvas,
        size,
        const Color(0xFF22C55E),
        marketRatios,
      );
    }

    if (coopRatios.length >= 2) {
      // Koperasi Line (Blue)
      _drawLine(
        canvas,
        size,
        const Color(0xFF155DFC),
        coopRatios,
      );
    }
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
    final fillPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = size.width * (i / (values.length - 1));
      final y = size.height * values[i];
      points.add(Offset(x, y));
    }

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    // Draw area gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.15),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
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
  bool shouldRepaint(covariant DualLinePainter oldDelegate) {
    return oldDelegate.marketRatios != marketRatios || oldDelegate.coopRatios != coopRatios;
  }
}
