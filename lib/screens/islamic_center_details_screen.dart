import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:majadigi_superapp_frontend/widgets/custom_button.dart';
import 'package:majadigi_superapp_frontend/widgets/shimmer.dart';
import 'package:majadigi_superapp_frontend/providers/islamic_center_provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/models/islamic_center_model.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<IslamicCenterProvider>(context, listen: false);
      provider.fetchAcara();
      provider.fetchFasilitas();
      provider.fetchMyRegistrations();
      provider.fetchMyBookings();
    });
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          final provider = Provider.of<IslamicCenterProvider>(context, listen: false);
          await Future.wait([
            provider.fetchAcara(),
            provider.fetchFasilitas(),
          ]);
        },
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildFeatureSwitcher(),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildActiveFeature(),
              ),
            ),
          ],
        ),
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
    return Consumer<IslamicCenterProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionBanner('📚 Jadwal Kajian Rutin', 'Daftar kajian rutin & pelatihan Islami. E-Ticket otomatis terbit setelah pendaftaran.'),
            const SizedBox(height: 24),
            if (provider.isLoadingAcara)
              _buildKajianShimmer()
            else if (provider.acaraList.isEmpty)
              _buildEmptyState(
                title: 'Belum Ada Kajian',
                message: 'Saat ini belum ada kajian rutin yang terjadwal. Silakan cek kembali nanti.',
                icon: Icons.calendar_today_outlined,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.acaraList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final acara = provider.acaraList[index];
                  return _buildEventCard(acara);
                },
              ),
            const SizedBox(height: 32),
          ],
        );
      },
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

  Widget _buildEventCard(Acara acara) {
    bool isFree = (acara.kuotaMaksimal > 0); // Mocking free tag or based on data
    String priceText = isFree ? 'GRATIS' : 'Rp 150.000';
    Color priceColor = isFree ? const Color(0xFF00A63E) : const Color(0xFF0065FF);

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
                child: Text(acara.judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: priceColor, borderRadius: BorderRadius.circular(6)),
                child: Text(priceText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (acara.pemateri != null && acara.pemateri!.isNotEmpty)
            Text(acara.pemateri!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 8),
          Text(acara.deskripsi, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, height: 1.4)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text('Sisa Kuota: ${acara.sisaKuota}/${acara.kuotaMaksimal}', style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text(acara.status.toUpperCase(), style: TextStyle(fontSize: 10, color: priceColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today, '${acara.tanggalFormatted} (${acara.waktuMulaiFormatted} - ${acara.waktuSelesaiFormatted})',),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, acara.lokasi),
          const SizedBox(height: 16),
          Consumer<IslamicCenterProvider>(
            builder: (context, provider, child) {
              return CustomButton(
                text: provider.isRegistering ? 'Memproses...' : 'Daftar Sekarang',
                onPressed: provider.isRegistering ? () {} : () async {
                  bool success = await provider.registerKajian(acara.id);
                  if (success && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IslamicCenterTicketDetailScreen()),
                    );
                  } else if (context.mounted) {
                    if (provider.isAlreadyRegistered) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorRegistration ?? 'Anda sudah terdaftar dalam kajian ini.'),
                          backgroundColor: const Color(0xFF0065FF),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IslamicCenterTicketDetailScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(provider.errorRegistration ?? 'Gagal mendaftar kajian. Silakan coba lagi.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                height: 44,
                fontSize: 14,
              );
            }
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
        Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF475569), fontSize: 12))),
      ],
    );
  }

  Widget _buildBookingTab() {
    return Consumer<IslamicCenterProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionBanner('🏢 Booking Ruangan', 'Sewa ruangan untuk acara, seminar, atau kajian. Lihat ketersediaan real-time.'),
            const SizedBox(height: 24),
            _buildCalendarSection(),
            const SizedBox(height: 24),
            const Text('🏫 Pilih Ruangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (provider.isLoadingFasilitas)
              _buildBookingShimmer()
            else if (provider.fasilitasList.isEmpty)
              _buildEmptyState(
                title: 'Fasilitas Kosong',
                message: 'Saat ini belum ada gedung/fasilitas yang aktif disewakan.',
                icon: Icons.domain_disabled,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.fasilitasList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final fasilitas = provider.fasilitasList[index];
                  return _buildRoomCard(fasilitas);
                },
              ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  DateTime _selectedBookingDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Widget _buildCalendarSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(14), 
        border: Border.all(color: const Color(0xFFE5E7EB))
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0065FF), 
            onPrimary: Colors.white, 
            onSurface: Color(0xFF18181B), 
          ),
        ),
        child: CalendarDatePicker(
          initialDate: _selectedBookingDate,
          firstDate: _selectedBookingDate.subtract(const Duration(days: 7)),
          lastDate: _selectedBookingDate.add(const Duration(days: 180)),
          onDateChanged: (date) {
            setState(() {
              _selectedBookingDate = date;
            });
          },
        ),
      ),
    );
  }

  Widget _buildRoomCard(Fasilitas fasilitas) {
    String formattedPrice = 'Rp ${fasilitas.hargaPerHari.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/Hari';
    
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: ((fasilitas.fotoUrl != null && fasilitas.fotoUrl!.isNotEmpty) ? fasilitas.fotoUrl! : 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600').startsWith('http')
                ? Image.network(
                    (fasilitas.fotoUrl != null && fasilitas.fotoUrl!.isNotEmpty) ? fasilitas.fotoUrl! : 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600',
                    height: 140, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: const Color(0xFFEFF6FF),
                      child: const Center(child: Icon(Icons.broken_image, size: 40, color: Color(0xFF3B82F6))),
                    ),
                  )
                : Image.asset(
                    fasilitas.fotoUrl!,
                    height: 140, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fasilitas.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(fasilitas.deskripsi, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kapasitas: ${fasilitas.kapasitas} orang', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    Text(formattedPrice, style: const TextStyle(color: Color(0xFF0065FF), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                CustomButton(text: 'Pilih Ruangan', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IslamicCenterBookingFormScreen(fasilitas: fasilitas, selectedDate: _selectedBookingDate)));
                }, height: 40, fontSize: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiketSayaTab() {
    return Consumer<IslamicCenterProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoadingMyBookings || provider.isLoadingMyRegistrations;
        
        if (isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('🎫 E-Ticket Kajian', '', const Color(0xFF9810FA)),
              const SizedBox(height: 16),
              _buildShimmerTicketCard(),
              const SizedBox(height: 32),
              _buildSectionHeader('🏢 Booking Ruangan', '', const Color(0xFF155DFC)),
              const SizedBox(height: 16),
              _buildShimmerTicketCard(),
            ],
          );
        }

        final bookings = provider.myBookings;
        final registrations = provider.myRegistrations;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionBanner('🎫 Tiket & Booking', 'Daftar tiket kajian dan riwayat booking ruangan Anda.'),
            const SizedBox(height: 24),
            
            // Section 1: E-Ticket Kajian
            _buildSectionHeader(
              '🎫 E-Ticket Kajian', 
              registrations.isEmpty ? '0 Tiket' : '${registrations.length} Tiket', 
              const Color(0xFF9810FA),
            ),
            const SizedBox(height: 16),
            if (registrations.isEmpty)
              _buildEmptyState(
                title: 'Tidak ada E-Ticket Kajian',
                message: 'Anda belum mendaftar di kajian apapun saat ini.',
                icon: Icons.confirmation_number_outlined,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: registrations.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final reg = registrations[index];
                  final title = reg.acara?.judul ?? 'Kajian';
                  final subtitle = reg.acara?.pemateri ?? reg.acara?.deskripsi ?? 'Islamic Center';
                  final date = reg.acara?.tanggalFormatted ?? '';
                  final time = reg.acara != null 
                      ? '${reg.acara!.waktuMulaiFormatted} - ${reg.acara!.waktuSelesaiFormatted} WIB' 
                      : '';
                  final location = reg.acara?.lokasi ?? 'Islamic Center';
                  
                  return _buildTicketCard(
                    title: title,
                    subtitle: subtitle,
                    status: reg.statusLabel,
                    statusColor: reg.statusColor,
                    bookingCode: reg.qrPayload,
                    date: date,
                    time: time,
                    location: location,
                    gradient: const [Color(0xFFFAF5FF), Color(0xFFEEF2FF)],
                    borderColor: const Color(0xFFE9D4FF),
                    titleColor: const Color(0xFF59168B),
                    onShare: () => _shareTicket(context, title),
                  );
                },
              ),

            const SizedBox(height: 32),

            // Section 2: Booking Ruangan
            _buildSectionHeader(
              '🏢 Booking Ruangan', 
              bookings.isEmpty ? '0 Booking' : '${bookings.length} Booking', 
              const Color(0xFF155DFC),
            ),
            const SizedBox(height: 16),
            if (bookings.isEmpty)
              _buildEmptyState(
                title: 'Tidak ada Booking Ruangan',
                message: 'Anda belum mengajukan booking ruangan saat ini.',
                icon: Icons.business_outlined,
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  String userName = 'Budi Sintara';
                  try {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    userName = authProvider.user?.nama ?? 'Budi Sintara';
                  } catch (_) {}
                  
                  final title = booking.fasilitas?.nama ?? 'Fasilitas';
                  final subtitle = 'Nama Pemesan: $userName';
                  final date = booking.tanggalFormatted;
                  final time = '08:00 - Selesai WIB';
                  final location = 'Islamic Center';

                  return _buildTicketCard(
                    title: title,
                    subtitle: subtitle,
                    status: booking.statusLabel,
                    statusColor: booking.statusColor,
                    bookingCode: booking.kodeBayar,
                    date: date,
                    time: time,
                    location: location,
                    additionalInfo: '${booking.estimasiPeserta} orang',
                    gradient: const [Color(0xFFEFF6FF), Color(0xFFECFEFF)],
                    borderColor: const Color(0xFFBEDBFF),
                    titleColor: const Color(0xFF1C398E),
                    onShare: () => _shareTicket(context, title),
                  );
                },
              ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String count, Color badgeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        if (count.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTicketCard({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required String bookingCode,
    required String date,
    required String time,
    required String location,
    String? additionalInfo,
    required List<Color> gradient,
    required Color borderColor,
    required Color titleColor,
    required VoidCallback onShare,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(width: 1.33, color: borderColor),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF4A5565),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  if (bookingCode.isNotEmpty)
                    Center(
                      child: QrImageView(
                        data: bookingCode,
                        version: QrVersions.auto,
                        size: 140.0,
                      ),
                    )
                  else
                    const Icon(Icons.qr_code_2, size: 120, color: Colors.black87),
                  const SizedBox(height: 8),
                  Text(
                    bookingCode,
                    style: const TextStyle(
                      color: Color(0xFF6A7282),
                      fontSize: 12,
                      fontFamily: 'Consolas',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDetailBox('Tanggal', date)),
                const SizedBox(width: 8),
                Expanded(child: _buildDetailBox('Waktu', time)),
              ],
            ),
            const SizedBox(height: 8),
            _buildDetailBox('Lokasi', location),
            if (additionalInfo != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jumlah Peserta:',
                      style: TextStyle(
                        color: Color(0xFF4A5565),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      additionalInfo,
                      style: const TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: onShare,
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2B7FFF)),
                        foregroundColor: const Color(0xFF1447E6),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4A5565),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerTicketCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.rectangular(height: 18, width: 140),
                    const SizedBox(height: 6),
                    Shimmer.rectangular(height: 14, width: 100),
                  ],
                ),
              ),
              Shimmer.rounded(height: 22, width: 60, borderRadius: 8),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Shimmer.rectangular(height: 120, width: 120),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.rectangular(height: 12, width: 50),
                    const SizedBox(height: 4),
                    Shimmer.rectangular(height: 12, width: 90),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.rectangular(height: 12, width: 50),
                    const SizedBox(height: 4),
                    Shimmer.rectangular(height: 12, width: 90),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Shimmer.rectangular(height: 36, width: double.infinity),
        ],
      ),
    );
  }

  void _shareTicket(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bagikan Tiket: $title',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.copy, color: Color(0xFF0065FF)),
                title: const Text('Salin Tautan E-Tiket'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tautan e-tiket berhasil disalin ke papan klip!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF10B981)),
                title: const Text('Bagikan ke WhatsApp (Simulasi)'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka WhatsApp untuk membagikan e-tiket...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.send_rounded, color: Color(0xFF0EA5E9)),
                title: const Text('Bagikan ke Telegram (Simulasi)'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka Telegram untuk membagikan e-tiket...')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKajianShimmer() {
    return Column(
      children: List.generate(2, (index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                Shimmer.rectangular(height: 20, width: 180),
                Shimmer.rounded(height: 20, width: 60, borderRadius: 6),
              ],
            ),
            const SizedBox(height: 8),
            Shimmer.rectangular(height: 14, width: 120),
            const SizedBox(height: 12),
            Row(
              children: [
                Shimmer.rounded(height: 20, width: 60, borderRadius: 6),
                const SizedBox(width: 8),
                Shimmer.rounded(height: 20, width: 80, borderRadius: 6),
              ],
            ),
            const SizedBox(height: 16),
            Shimmer.rectangular(height: 12, width: 140),
            const SizedBox(height: 8),
            Shimmer.rectangular(height: 12, width: 160),
            const SizedBox(height: 16),
            Shimmer.rounded(height: 44, width: double.infinity, borderRadius: 10),
          ],
        ),
      )),
    );
  }

  Widget _buildBookingShimmer() {
    return Column(
      children: List.generate(2, (index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.rounded(height: 140, width: double.infinity, borderRadius: 14),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.rectangular(height: 16, width: 180),
                  const SizedBox(height: 8),
                  Shimmer.rectangular(height: 14, width: 100),
                  const SizedBox(height: 12),
                  Shimmer.rounded(height: 40, width: double.infinity, borderRadius: 10),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildEmptyState({required String title, required String message, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.5),
          ),
        ],
      ),
    );
  }
}
