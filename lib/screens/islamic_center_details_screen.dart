import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'islamic_center_booking_form_screen.dart';
import 'islamic_center_ticket_detail_screen.dart';

class IslamicCenterDetailsScreen extends StatefulWidget {
  const IslamicCenterDetailsScreen({super.key});

  @override
  State<IslamicCenterDetailsScreen> createState() => _IslamicCenterDetailsScreenState();
}

class _IslamicCenterDetailsScreenState extends State<IslamicCenterDetailsScreen> {
  int _activeTabIndex = 0; // 0: Kajian, 1: Booking, 2: Tiket Saya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Gedung Islamic Center', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildFeatureSwitcher(),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildActiveFeature(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          _buildSwitcherItem(0, Icons.calendar_today_outlined, 'Kajian'),
          _buildSwitcherItem(1, Icons.domain_outlined, 'Booking'),
          _buildSwitcherItem(2, Icons.confirmation_number_outlined, 'Tiket'),
        ],
      ),
    );
  }

  Widget _buildSwitcherItem(int index, IconData icon, String label) {
    bool isActive = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0065FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : const Color(0xFF64748B),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFeature() {
    switch (_activeTabIndex) {
      case 0: return _buildKajianTab();
      case 1: return _buildBookingTab();
      case 2: return _buildTiketSayaTab();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildKajianTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionBanner('📚 Jadwal Kajian Rutin', 'Daftar kajian rutin & pelatihan Islami. E-Ticket otomatis terbit setelah pendaftaran.'),
        const SizedBox(height: 24),
        _buildEventCard(
          title: 'Kajian Akbar Ramadhan',
          instructor: 'Ustadz Dr. Ahmad Zainuddin',
          description: 'Membahas keutamaan bulan Ramadhan dan persiapan menyambutnya',
          price: 'GRATIS',
          priceColor: const Color(0xFF00A63E),
          tags: ['Ramadhan', 'Puasa', 'Ibadah'],
          date: '11 April 2026',
          time: '19:30 WIB',
          location: 'Aula Utama Islamic Center',
          registered: 234,
          capacity: 500,
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          title: 'Pelatihan Tahfidz Al-Qur\'an',
          instructor: 'Ustadzah Fatimah Azzahra, M.Pd.I',
          description: 'Metode cepat menghafal Al-Qur\'an untuk pemula dan lanjutan',
          price: 'Rp 150.000',
          priceColor: const Color(0xFF0065FF),
          tags: ['Tahfidz', 'Metode Menghafal'],
          date: '12 April 2026',
          time: '08:00 WIB',
          location: 'Ruang Kelas Asrama',
          registered: 45,
          capacity: 60,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionBanner(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFAF5FF), Color(0xFFEEF2FF)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9D4FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF0065FF), fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String instructor,
    required String description,
    required String price,
    required Color priceColor,
    required List<String> tags,
    required String date,
    required String time,
    required String location,
    required int registered,
    required int capacity,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: priceColor, borderRadius: BorderRadius.circular(6)),
                child: Text(price, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(instructor, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
              child: Text(t, style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
            )).toList(),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today, date),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, location),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Daftar Sekarang',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const IslamicCenterTicketDetailScreen()));
            },
            height: 44,
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Color(0xFF475569), fontSize: 12)),
      ],
    );
  }

  Widget _buildBookingTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionBanner('🏢 Booking Ruangan', 'Sewa ruangan untuk acara, seminar, atau kajian. Lihat ketersediaan real-time.'),
        const SizedBox(height: 24),
        _buildCalendarSection(),
        const SizedBox(height: 24),
        const Text('🏫 Pilih Ruangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildRoomCard('Aula Utama (Lantai 1)', 'Rp 500.000/Jam', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600'),
        const SizedBox(height: 16),
        _buildRoomCard('Ruang Serbaguna (Lantai 2)', 'Rp 250.000/Jam', 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80&w=600'),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          const Text('📅 April 2026', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8),
            itemCount: 30,
            itemBuilder: (context, index) {
              int d = index + 1;
              Color color = Colors.transparent;
              if (d == 11) color = const Color(0xFF0065FF);
              else if ([5, 12, 18].contains(d)) color = const Color(0xFFEF4444);
              else if ([15, 22].contains(d)) color = const Color(0xFFF59E0B);
              else color = const Color(0xFF10B981).withOpacity(0.1);

              return Container(
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(child: Text('$d', style: TextStyle(fontSize: 12, color: (d == 11 || [5, 12, 18].contains(d)) ? Colors.white : Colors.black))),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(String name, String price, String img) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), child: Image.network(img, height: 140, width: double.infinity, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: const TextStyle(color: Color(0xFF0065FF), fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                CustomButton(text: 'Pilih Ruangan', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IslamicCenterBookingFormScreen(roomName: name, date: '11 April 2026')));
                }, height: 40, fontSize: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiketSayaTab() {
    return Column(
      children: [
        _buildSectionBanner('🎫 Tiket & Booking', 'Daftar tiket kajian dan riwayat booking ruangan Anda.'),
        const SizedBox(height: 24),
        CustomButton(text: 'Lihat Tiket Aktif', onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const IslamicCenterTicketDetailScreen()));
        }),
      ],
    );
  }
}
