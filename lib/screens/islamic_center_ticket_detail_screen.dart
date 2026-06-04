import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:majadigi_superapp_frontend/providers/islamic_center_provider.dart';
import 'package:majadigi_superapp_frontend/providers/auth_provider.dart';
import 'package:majadigi_superapp_frontend/widgets/shimmer.dart';

class IslamicCenterTicketDetailScreen extends StatefulWidget {
  const IslamicCenterTicketDetailScreen({super.key});

  @override
  State<IslamicCenterTicketDetailScreen> createState() => _IslamicCenterTicketDetailScreenState();
}

class _IslamicCenterTicketDetailScreenState extends State<IslamicCenterTicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<IslamicCenterProvider>(context, listen: false);
      provider.fetchMyBookings();
      provider.fetchMyRegistrations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Header Background (Brand Gradient)
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              height: 253,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0065FF), Color(0xFF0040A1)],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Header Content
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Islamic Center',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content Scrollable
          Positioned.fill(
            top: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Consumer<IslamicCenterProvider>(
                builder: (context, provider, child) {
                  final isLoading = provider.isLoadingMyBookings || provider.isLoadingMyRegistrations;
                  
                  if (isLoading) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
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
                      ),
                    );
                  }

                  final bookings = provider.myBookings;
                  final registrations = provider.myRegistrations;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              final userName = authProvider.user?.nama ?? 'Budi Sintara';
                              
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
                              );
                            },
                          ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
            // Header: Title and Status
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

            // QR Code Section
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

            // Details Grid
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

            // Download Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download'),
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

  Widget _buildEmptyState({
    required String title,
    required String message,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
