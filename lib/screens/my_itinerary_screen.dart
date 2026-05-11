import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/ticket_qr_screen.dart';

class MyItineraryScreen extends StatelessWidget {
  const MyItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0065FF), // Primary Blue
      body: Stack(
        children: [
          // Background Decorative Pattern
          Positioned(
            left: -276,
            top: -212,
            child: Container(
              width: 815,
              height: 1250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Itinerary Saya',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '3 rencana perjalanan',
                          style: TextStyle(
                            color: const Color(0xFFCEFAFE),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildItineraryCard(
                        context,
                        title: 'Gunung Bromo',
                        location: 'Probolinggo',
                        date: '6 Apr',
                        time: '09:00',
                        guests: '1 orang',
                        price: 'Rp 35.000',
                        status: 'Hari Ini',
                      ),
                      const SizedBox(height: 16),
                      _buildItineraryCard(
                        context,
                        title: 'Pantai Tiga Warna',
                        location: 'Malang',
                        date: '8 Apr',
                        time: '10:30',
                        guests: '2 orang',
                        price: 'Rp 50.000',
                        status: 'Mendatang',
                        statusColor: const Color(0xFF0065FF),
                      ),
                      const SizedBox(height: 16),
                      _buildItineraryCard(
                        context,
                        title: 'Kawah Ijen',
                        location: 'Banyuwangi',
                        date: '12 Apr',
                        time: '02:00',
                        guests: '1 orang',
                        price: 'Rp 25.000',
                        status: 'Mendatang',
                        statusColor: const Color(0xFF0065FF),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryCard(
    BuildContext context, {
    required String title,
    required String location,
    required String date,
    required String time,
    required String guests,
    required String price,
    required String status,
    Color statusColor = const Color(0xFF00A63E),
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF9810FA)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF6A7282)),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Color(0xFF6A7282),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoTag(Icons.calendar_today_outlined, date),
                    const SizedBox(width: 12),
                    _buildInfoTag(Icons.access_time, time),
                    const SizedBox(width: 12),
                    _buildInfoTag(Icons.person_outline, guests),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF9810FA),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketQrScreen(
                              title: title,
                              location: location,
                              date: date,
                              time: time,
                              price: price,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black.withOpacity(0.1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 32),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.qr_code_2, size: 16, color: Color(0xFF0A0A0A)),
                          SizedBox(width: 4),
                          Text(
                            'Lihat QR',
                            style: TextStyle(
                              color: Color(0xFF0A0A0A),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF4A5565)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 11,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
