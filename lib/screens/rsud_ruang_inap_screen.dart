import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/room_stat_card.dart';
import 'package:majadigi_superapp_frontend/widgets/room_availability_table.dart';

class RsudRuangInapScreen extends StatefulWidget {
  const RsudRuangInapScreen({super.key});

  @override
  State<RsudRuangInapScreen> createState() => _RsudRuangInapScreenState();
}

class _RsudRuangInapScreenState extends State<RsudRuangInapScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'Kelas 1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Ketersediaan Kamar Rawat
                    const Text(
                      'Ketersediaan Kamar Rawat',
                      style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.60,
                        letterSpacing: 0.20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Horizontal Scroll of Stat Cards
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          RoomStatCard(
                            title: 'Total Kamar Rawat',
                            count: '945',
                            icon: Icons.business,
                          ),
                          SizedBox(width: 16),
                          RoomStatCard(
                            title: 'Tersedia',
                            count: '249',
                            icon: Icons.check_circle_outline,
                          ),
                          SizedBox(width: 16),
                          RoomStatCard(
                            title: 'Terisi',
                            count: '667',
                            icon: Icons.people_outline,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Section: Status Ketersediaan Ruangan
                    const Text(
                      'Status Ketersediaan Ruangan',
                      style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.60,
                        letterSpacing: 0.20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari Kelas Rawat Inap',
                          hintStyle: TextStyle(
                            color: Color(0xFFA9A5B8),
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                          ),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Color(0xFFA9A5B8)),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Room Availability Table
                    const RoomAvailabilityTable(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0065FF), Color(0xFF004FCC)],
        ),
      ),
      child: Stack(
        children: [
          // Background Image Placeholder
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'RSUD Dr Saiful Anwar',
                      textAlign: TextAlign.center,
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
          ),
        ],
      ),
    );
  }
}
