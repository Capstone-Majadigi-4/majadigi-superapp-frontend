import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/commodity_detail_screen.dart';

class CommodityListScreen extends StatefulWidget {
  final bool showAppBar;
  const CommodityListScreen({super.key, this.showAppBar = true});

  @override
  State<CommodityListScreen> createState() => _CommodityListScreenState();
}

class _CommodityListScreenState extends State<CommodityListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> commodities = const [
    {
      'name': 'Daging Ayam Ras',
      'price': 'Rp 35.610',
      'unit': 'Per kg',
      'image': 'https://placehold.co/100x100?text=Ayam',
      'trend': 'down', // down = green arrow down
    },
    {
      'name': 'Daging Sapi Paha Belakang',
      'price': 'Rp 118.400',
      'unit': 'Per kg',
      'image': 'https://placehold.co/100x100?text=Sapi',
      'trend': 'up', // up = red arrow up
    },
    {
      'name': 'Gas Elpiji 3 Kg',
      'price': 'Rp 18.500',
      'unit': 'Per tabung',
      'image': 'https://placehold.co/100x100?text=LPG',
      'trend': 'stable',
    },
    {
      'name': 'Gula Kristal Putih',
      'price': 'Rp 16.200',
      'unit': 'Per kg',
      'image': 'https://placehold.co/100x100?text=Gula',
      'trend': 'down',
    },
    {
      'name': 'Beras Premium',
      'price': 'Rp 15.000',
      'unit': 'Per kg',
      'image': 'https://placehold.co/100x100?text=Beras',
      'trend': 'up',
    },
    {
      'name': 'Minyak Goreng Kemasan',
      'price': 'Rp 17.800',
      'unit': 'Per liter',
      'image': 'https://placehold.co/100x100?text=Minyak',
      'trend': 'stable',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        // Search Bar Section
        Container(
          padding: const EdgeInsets.all(16),
          color: widget.showAppBar ? const Color(0xFF0065FF) : Colors.transparent,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: widget.showAppBar ? null : Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: widget.showAppBar ? null : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari data bahan pokok...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),

        // Grid View Section
        widget.showAppBar 
          ? Expanded(
              child: _buildGrid(),
            )
          : _buildGrid(),
      ],
    );

    if (!widget.showAppBar) return content;

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
          'Daftar Harga Bahan Pokok',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: content,
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: !widget.showAppBar,
      physics: widget.showAppBar ? null : const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: commodities.length,
      itemBuilder: (context, index) {
        final item = commodities[index];
        return CommodityGridCard(
          name: item['name'],
          price: item['price'],
          unit: item['unit'],
          imageUrl: item['image'],
          trend: item['trend'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommodityDetailScreen(
                  name: item['name'],
                  price: item['price'],
                  unit: item['unit'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CommodityGridCard extends StatelessWidget {
  final String name;
  final String price;
  final String unit;
  final String imageUrl;
  final String trend;
  final VoidCallback onTap;

  const CommodityGridCard({
    super.key,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.trend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Circular Image with Green Border
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Name (Max 2 lines)
            Expanded(
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                  fontFamily: 'Inter',
                  height: 1.2,
                ),
              ),
            ),
            
            const SizedBox(height: 8),

            // Price and Trend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF155DFC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                
                // Trend Icon in small circle
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getTrendColor(trend).withOpacity(0.1),
                  ),
                  child: Icon(
                    _getTrendIcon(trend),
                    size: 12,
                    color: _getTrendColor(trend),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrendColor(String trend) {
    if (trend == 'up') return const Color(0xFFEF4444);
    if (trend == 'down') return const Color(0xFF22C55E);
    return const Color(0xFF94A3B8);
  }

  IconData _getTrendIcon(String trend) {
    if (trend == 'up') return Icons.arrow_upward;
    if (trend == 'down') return Icons.arrow_downward;
    return Icons.remove;
  }
}
