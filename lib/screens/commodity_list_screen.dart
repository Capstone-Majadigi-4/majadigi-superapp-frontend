import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/bapok_provider.dart';
import 'package:majadigi_superapp_frontend/widgets/shimmer.dart';
import 'package:majadigi_superapp_frontend/models/bapok_ticker_model.dart';
import 'package:majadigi_superapp_frontend/screens/commodity_detail_screen.dart';

class CommodityListScreen extends StatefulWidget {
  final bool showAppBar;
  const CommodityListScreen({super.key, this.showAppBar = true});

  @override
  State<CommodityListScreen> createState() => _CommodityListScreenState();
}

class _CommodityListScreenState extends State<CommodityListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BapokProvider>(context, listen: false).fetchKomoditas();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = RefreshIndicator(
      onRefresh: () => Provider.of<BapokProvider>(context, listen: false).fetchKomoditas(),
      child: Column(
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
      ),
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
        actions: const [],
      ),
      body: content,
    );
  }

  Widget _buildGrid() {
    return Consumer<BapokProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildShimmerGrid();
        }

        final items = provider.komoditasList.where((item) {
          return item.nama.toLowerCase().contains(_searchQuery) ||
              item.kategori.toLowerCase().contains(_searchQuery);
        }).toList();

        if (items.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: !widget.showAppBar,
          physics: widget.showAppBar ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            String formattedPrice = 'Rp ${item.hargaRataRata.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
            String trend = 'stable';
            if (item.perubahanPersen != null) {
              if (item.perubahanPersen! > 0) {
                trend = 'up';
              } else if (item.perubahanPersen! < 0) {
                trend = 'down';
              }
            }

            // High-quality fallback image URL for commodity representation
            String fallbackImageUrl = 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&q=80&w=150';
            if (item.nama.toLowerCase().contains('beras')) {
              fallbackImageUrl = 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&q=80&w=150';
            } else if (item.nama.toLowerCase().contains('daging')) {
              fallbackImageUrl = 'https://images.unsplash.com/photo-1603048588665-791ca8aea617?auto=format&fit=crop&q=80&w=150';
            } else if (item.nama.toLowerCase().contains('minyak')) {
              fallbackImageUrl = 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&q=80&w=150';
            } else if (item.nama.toLowerCase().contains('gula')) {
              fallbackImageUrl = 'https://images.unsplash.com/photo-1581798459219-318e76aecc7b?auto=format&fit=crop&q=80&w=150';
            } else if (item.nama.toLowerCase().contains('gas') || item.nama.toLowerCase().contains('lpg')) {
              fallbackImageUrl = 'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?auto=format&fit=crop&q=80&w=150';
            }

            return CommodityGridCard(
              name: item.nama,
              price: formattedPrice,
              unit: 'Per ${item.satuan}',
              imageUrl: item.ikonUrl ?? fallbackImageUrl,
              trend: trend,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommodityDetailScreen(
                      komoditas: item,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: !widget.showAppBar,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Shimmer.circular(width: 70, height: 70),
              const SizedBox(height: 12),
              Shimmer.rectangular(height: 14, width: 100),
              const SizedBox(height: 8),
              Shimmer.rectangular(height: 12, width: 60),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.rectangular(height: 16, width: 60),
                      const SizedBox(height: 4),
                      Shimmer.rectangular(height: 10, width: 30),
                    ],
                  ),
                  Shimmer.circular(width: 20, height: 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 40, color: Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          Text(
            'Komoditas Tidak Ditemukan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Text(
            'Data harga komoditas bahan pokok yang Anda cari tidak ditemukan atau kosong.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.5),
          ),
        ],
      ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF155DFC),
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
