import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/widgets/destination_detail_modal.dart';
import 'package:majadigi_superapp_frontend/screens/bus_route_detail_screen.dart';
import 'package:majadigi_superapp_frontend/screens/my_itinerary_screen.dart';
import 'package:majadigi_superapp_frontend/providers/wisata_provider.dart';

class TourismMainFlowScreen extends StatefulWidget {
  const TourismMainFlowScreen({super.key});

  @override
  State<TourismMainFlowScreen> createState() => _TourismMainFlowScreenState();
}

class _TourismMainFlowScreenState extends State<TourismMainFlowScreen> {
  String selectedCategory = 'Semua';
  final List<String> categories = ['Semua', 'Alam', 'Pantai', 'Keluarga'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WisataProvider>(context, listen: false).fetchDestinations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wisataProvider = Provider.of<WisataProvider>(context);
    final filteredDestinations = wisataProvider.destinations.where((d) {
      return selectedCategory == 'Semua' || d.category == selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0065FF),
      body: Stack(
        children: [
          // Background Pattern/Decorative Container
          Positioned(
            left: -276,
            top: -212,
            child: Container(
              width: 815,
              height: 1250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Image Section
                SizedBox(
                  width: double.infinity,
                  height: 253,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                       Image.asset(
                        "assets/images/destinasi wisata/Gambar wisata bromo.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF0078FF), Color(0xFF0046B2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Destinasi Wisata',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              _buildBookmarkButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Area with Overlap
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildCrossTicketingBanner(),
                        const SizedBox(height: 24),
                        _buildCategorySelector(),
                        const SizedBox(height: 24),
                        if (wisataProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (filteredDestinations.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'Tidak ada destinasi ditemukan',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredDestinations.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final dest = filteredDestinations[index];
                              return _buildDestinationCard(
                                title: dest.title,
                                description: dest.description,
                                imageUrl: dest.imageUrl,
                                duration: dest.duration,
                                openHours: dest.openHours,
                                route: dest.route,
                                distance: dest.distance,
                                price: dest.price,
                              );
                            },
                          ),
                        const SizedBox(height: 120), // Spacing for fixed button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed Bottom Primary Button with Premium Full-Width Solid White Container
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom + 8 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => DestinationDetailModal.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0065FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Beli E-Ticket Sekarang',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossTicketingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFECFEFF)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.airplane_ticket_outlined, color: Color(0xFF1C398E), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Cross-Ticketing & Bus Integration',
                style: TextStyle(
                  color: Color(0xFF1C398E),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Color(0xFF1447E6),
                fontSize: 12,
                fontFamily: 'Inter',
                height: 1.6,
              ),
              children: [
                TextSpan(text: 'Setiap destinasi sudah terintegrasi dengan '),
                TextSpan(
                  text: 'Transjatim',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' untuk rekomendasi rute bus terdekat. Beli E-Ticket langsung dengan QRIS!',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyItineraryScreen()),
                );
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'Lihat Itinerary Saya →',
                style: TextStyle(
                  color: Color(0xFF1447E6),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: categories.map((cat) {
          bool isSelected = selectedCategory == cat;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  cat,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF0A0A0A),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDestinationCard({
    required String title,
    required String description,
    required String imageUrl,
    required String duration,
    required String openHours,
    required String route,
    required String distance,
    required String price,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: imageUrl.startsWith('http')
                ? Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.landscape_rounded, color: Color(0xFF64748B), size: 48),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Image.asset(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTag(Icons.access_time, duration),
                    const SizedBox(width: 8),
                    _buildTag(Icons.calendar_today, openHours),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Yellow Route Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFEFCE8), Color(0xFFFFF7ED)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFFF085)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.directions_bus, color: Color(0xFF733E0A), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rute Transjatim',
                                  style: TextStyle(
                                    color: Color(0xFF733E0A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  route,
                                  style: const TextStyle(color: Color(0xFFA65F00), fontSize: 11),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.near_me, color: Color(0xFFD08700), size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      distance,
                                      style: const TextStyle(color: Color(0xFFD08700), fontSize: 11),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      price,
                                      style: const TextStyle(
                                        color: Color(0xFF733E0A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BusRouteDetailScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFFFDF20)),
                          minimumSize: const Size(double.infinity, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Lihat Rute Bus',
                          style: TextStyle(color: Color(0xFF894B00), fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF0A0A0A))),
        ],
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    ModuleProvider? moduleProvider;
    try {
      moduleProvider = Provider.of<ModuleProvider>(context, listen: true);
    } catch (_) {}
    if (moduleProvider == null) {
      return const IconButton(
        icon: Icon(Icons.bookmark_border, color: Colors.white),
        onPressed: null,
      );
    }
    final isFav = moduleProvider.isFavorite('wisata');
    return IconButton(
      icon: Icon(
        isFav ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.white,
      ),
      onPressed: () => moduleProvider!.toggleFavorite('wisata'),
    );
  }
}
