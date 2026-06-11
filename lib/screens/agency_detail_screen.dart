import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/utils/app_colors.dart';
import 'package:majadigi_superapp_frontend/widgets/expandable_info_card.dart';
import 'package:majadigi_superapp_frontend/widgets/service_detail_tile.dart';
import 'package:majadigi_superapp_frontend/screens/bapenda_screen.dart';

class AgencyDetailScreen extends StatefulWidget {
  const AgencyDetailScreen({super.key});

  @override
  State<AgencyDetailScreen> createState() => _AgencyDetailScreenState();
}

class _AgencyDetailScreenState extends State<AgencyDetailScreen> {
  int _activeTab = 1; // Default to 'Operasional' to match the user's first reference image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Stack(
        children: [
          // 1. Header Background (Using local asset: assets/images/header.png)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/header.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          const Icon(Icons.bookmark_border, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Agency Info Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 10),
                                  spreadRadius: -3,
                                )
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.directions_car, color: Colors.white, size: 28),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Bapenda Jatim',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.40,
                                ),
                              ),
                              Text(
                                'Pembayaran Pajak Daerah',
                                style: TextStyle(
                                  color: Color(0xFFDBEAFE),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Main White Content Container
          Positioned.fill(
            top: 210,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  // Image & Brief Desc
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/Bapenda/gambar bapenda.png",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 350,
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Info dan layanan pajak kendaraan bermotor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Navigation Tabs (Layanan, Operasional, Ketentuan Umum)
                  Row(
                    children: [
                      _buildTabItem('Layanan', 0),
                      _buildTabItem('Operasional', 1),
                      _buildTabItem('Ketentuan\nUmum', 2),
                    ],
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  
                  // Scrollable Content based on active tab
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: _buildActiveTabContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primaryBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? AppColors.primaryBlue : const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildLayananTab();
      case 1:
        return _buildOperasionalTab();
      case 2:
        return _buildKetentuanUmumTab();
      default:
        return Container();
    }
  }

  Widget _buildLayananTab() {
    return Column(
      children: [
        ServiceDetailTile(
          title: "Info Pajak Kendaraan Bermotor",
          fallbackIcon: Icons.info_outline,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BapendaScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        const ServiceDetailTile(
          title: "Info Nilai Jual",
          fallbackIcon: Icons.attach_money,
        ),
      ],
    );
  }

  Widget _buildOperasionalTab() {
    return Column(
      children: [
        _buildInfoCard(
          "Alamat",
          child: const Text(
            "Seluruh Kota",
            style: TextStyle(color: Color(0xFF364153)),
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          "Jam Operasional",
          child: Column(
            children: [
              _buildListRow("senin 24 jam"),
              _buildListRow("selasa 24 jam"),
              _buildListRow("rabu 24 jam"),
              _buildListRow("kamis 24 jam"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKetentuanUmumTab() {
    return Column(
      children: [
        const ExpandableInfoCard(
          title: "Manfaat",
          content:
              "Layanan nomor darurat memberikan akses cepat dan mudah untuk mencari pertolongan saat seseorang mengalami atau mengetahui situasi darurat seperti kebakaran, banjir, kecelakaan lalu lintas, kriminalitas, dan lainnya. Dengan begitu, layanan ini diharapkan mampu mempercepat penanganan keadaan darurat dan meminimalisir dampak buruk yang muncul akibat situasi darurat. Layanan nomor darurat beroperasi 24 jam sehari, dan 7 hari seminggu. Sehingga masyarakat bisa mengaksesnya kapanpun dan dari manapun.",
        ),
        const SizedBox(height: 16),
        const ExpandableInfoCard(
          title: "Pendaftaran Online",
          content:
              "Kontak darurat biasanya lebih pendek atau sedikit dengan tujuan agar mudah diingat. Pastikan Anda menyimpan daftar kontak darurat di ponsel Anda atau tempat yang mudah dijangkau. Terakhir, pastikan Anda memberikan informasi secara jelas mengenai kejadian dan lokasinya agar petugas bisa mengeksekusinya lebih cepat.",
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAccordionItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.darkText,
            ),
          ),
          const Icon(Icons.add, color: Color(0xFF64748B), size: 20),
        ],
      ),
    );
  }

  Widget _buildListRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFF364153)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF364153),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
