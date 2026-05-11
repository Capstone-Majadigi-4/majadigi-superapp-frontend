import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/sapabansos_card.dart';
import '../widgets/sapabansos_operasional_tab.dart';
import '../widgets/sapabansos_ketentuan_tab.dart';
import '../widgets/sapabansos_status_dialog.dart';
import 'sapabansos_status_screen.dart';

class SapabansosScreen extends StatefulWidget {
  const SapabansosScreen({super.key});

  @override
  State<SapabansosScreen> createState() => _SapabansosScreenState();
}

class _SapabansosScreenState extends State<SapabansosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0065FF),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -50,
                  top: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.network(
                      "https://placehold.co/449x253",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
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
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'SAPABANSOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.04,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner Image
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: NetworkImage("https://placehold.co/352x201"),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Description
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Sistem Aplikasi Pelayanan Administrasi Bantuan Sosial',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF4A5565),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.71,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Tabs
                            TabBar(
                              controller: _tabController,
                              indicatorColor: const Color(0xFF155DFC),
                              indicatorWeight: 3,
                              labelColor: const Color(0xFF155DFC),
                              unselectedLabelColor: const Color(0xFF4A5565),
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                              tabs: const [
                                Tab(text: 'Layanan'),
                                Tab(text: 'Operasional'),
                                Tab(text: 'Ketentuan'),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Tab Content
                            SizedBox(
                              height: 400, // Fixed height for tab content within scrollview
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Layanan Tab
                                  Column(
                                    children: [
                                      SapabansosCard(
                                        title: 'Cek Status Penerima Bantuan Sosial',
                                        imageUrl: 'https://placehold.co/44x47',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SapabansosStatusScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      SapabansosCard(
                                        title: 'Info Program Bansos',
                                        imageUrl: 'https://placehold.co/44x47',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SapabansosInfoProgramScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // Operasional Tab
                                  const SapabansosOperasionalTab(),
                                  // Ketentuan Tab
                                  const SapabansosKetentuanTab(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 80), // Space for bottom button
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Button
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: CustomButton(
              text: 'Mulai Pelayanan',
              borderRadius: 12,
              onPressed: () {
                // Action to start
              },
            ),
          ),
        ],
      ),
    );
  }
}
