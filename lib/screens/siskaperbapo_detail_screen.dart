import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/price_alert_modal.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';

class SiskaperbapoDetailScreen extends StatefulWidget {
  final String commodityName;

  const SiskaperbapoDetailScreen({
    super.key,
    this.commodityName = 'Beras Premium',
  });

  @override
  State<SiskaperbapoDetailScreen> createState() => _SiskaperbapoDetailScreenState();
}

class _SiskaperbapoDetailScreenState extends State<SiskaperbapoDetailScreen> {
  int _selectedChipIndex = 0;
  final List<String> _commodities = ['Beras Premium', 'Minyak Goreng', 'Gula Pasir', 'Telur Ayam'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Blue Header Background
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0065FF),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'SISKAPERBAPO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTrendCard(),
                        const SizedBox(height: 24),
                        _buildDailyPriceHeader(),
                        const SizedBox(height: 16),
                        _buildPriceListItem('Beras Premium', 'Per kg', '15.000', '+500'),
                        const SizedBox(height: 12),
                        _buildPriceListItem('Minyak Goreng', 'Per liter', '14.500', '-200', isIncrease: false),
                        const SizedBox(height: 12),
                        _buildPriceListItem('Gula Pasir', 'Per kg', '16.000', '+100'),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grafik Tren Harga',
                    style: TextStyle(
                      color: Color(0xFF0A0A0A),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pantau pergerakan harga\n6 hari terakhir',
                    style: TextStyle(
                      color: Color(0xFF717182),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildGraphIcon(Icons.show_chart, true),
                  const SizedBox(width: 8),
                  _buildGraphIcon(Icons.bar_chart, false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Commodity Selection Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_commodities.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(_commodities[index], index),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Legend for Dual Line Chart
          Row(
            children: [
              _buildLegendItem('Harga Pasar', const Color(0xFF008236)),
              const SizedBox(width: 20),
              _buildLegendItem('Harga Koperasi', const Color(0xFF155DFC)),
            ],
          ),
          const SizedBox(height: 16),
          // Today's Price Summary (Comparison)
          Row(
            children: [
              Expanded(
                child: _buildPriceSummaryBox(
                  label: 'Harga Pasar',
                  price: '15.000',
                  color: const Color(0xFF008236),
                  trend: '+500',
                  isIncrease: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceSummaryBox(
                  label: 'Harga Koperasi',
                  price: '13.800',
                  color: const Color(0xFF155DFC),
                  trend: '-200',
                  isIncrease: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Dual Line Graph Mockup
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: DualLineChartPainter(),
            ),
          ),
          const SizedBox(height: 16),
          // X-Axis Labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('1 Apr', style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
              Text('2 Apr', style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
              Text('3 Apr', style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
              Text('4 Apr', style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
              Text('5 Apr', style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
              Text('6 Apr', style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraphIcon(IconData icon, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF030213) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? null : Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : const Color(0xFF030213),
        size: 16,
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    bool isActive = _selectedChipIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedChipIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF030213) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? null : Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyPriceHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daftar Harga Hari Ini',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Update: 10:00 WIB',
            style: TextStyle(
              color: Color(0xFF008236),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceListItem(String name, String unit, String price, String trend, {bool isIncrease = true}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/64x64.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        color: Color(0xFF6A7282),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rp $price',
                    style: const TextStyle(
                      color: Color(0xFF101828),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isIncrease ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isIncrease ? Icons.trending_up : Icons.trending_down,
                          color: isIncrease ? const Color(0xFFC10007) : const Color(0xFF008236),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend,
                          style: TextStyle(
                            color: isIncrease ? const Color(0xFFC10007) : const Color(0xFF008236),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => PriceAlertModal(
                        commodityName: name,
                        currentPrice: price,
                        unit: unit,
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFCC99)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, color: Color(0xFFF97316), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Price Alert',
                          style: TextStyle(
                            color: Color(0xFFF97316),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Lihat Detail',
                  height: 40,
                  fontSize: 13,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Harga $name hari ini: Rp $price/$unit'),
                        backgroundColor: const Color(0xFF0065FF),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
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
            color: Color(0xFF4A5565),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummaryBox({
    required String label,
    required String price,
    required Color color,
    required String trend,
    required bool isIncrease,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp $price',
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isIncrease ? Icons.trending_up : Icons.trending_down,
                color: isIncrease ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: isIncrease ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DualLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid Lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      double y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Market Line (Green)
    _drawLine(
      canvas, 
      size, 
      const Color(0xFF008236), 
      [0.4, 0.35, 0.3, 0.35, 0.2, 0.25],
    );

    // Koperasi Line (Blue)
    _drawLine(
      canvas, 
      size, 
      const Color(0xFF155DFC), 
      [0.6, 0.55, 0.5, 0.45, 0.4, 0.35],
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
    
    for (var i = 0; i < values.length; i++) {
      points.add(Offset(size.width * (i / (values.length - 1)), size.height * values[i]));
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 6, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
