import 'package:flutter/material.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_queue_status_screen.dart';
import 'package:majadigi_superapp_frontend/services/notification_service.dart';

class RsudAmbilAntreanScreen extends StatefulWidget {
  const RsudAmbilAntreanScreen({super.key});

  @override
  State<RsudAmbilAntreanScreen> createState() => _RsudAmbilAntreanScreenState();
}

class _RsudAmbilAntreanScreenState extends State<RsudAmbilAntreanScreen> {
  String? selectedPoliklinik;
  DateTime selectedDate = DateTime(2026, 4, 7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0065FF), Color(0xFF004FCC)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
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

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ambil Antrean',
                            style: TextStyle(
                              color: Color(0xFF18181B),
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.20,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Dropdown Poliklinik
                          _buildDropdown(),
                          const SizedBox(height: 32),

                          // Pilih Tanggal Section
                          const Text(
                            'Pilih Tanggal',
                            style: TextStyle(
                              color: Color(0xFF18181B),
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.20,
                            ),
                          ),
                          const Text(
                            'Kamu bisa memilih tanggal berdasarkan berkunjung',
                            style: TextStyle(
                              color: Color(0xFF52525B),
                              fontSize: 12,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.20,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Calendar Card
                          _buildCalendarCard(),
                          const SizedBox(height: 80), // Space for bottom button
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Confirmation Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Trigger Notification
                  await NotificationService().showQueueNotification(
                    queueNumber: 'A-023',
                    polyclinic: selectedPoliklinik ?? 'Poli Umum',
                  );
                  
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RsudQueueStatusScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF254EDB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPoliklinik,
          hint: const Text(
            'Pilih Poliklinik',
            style: TextStyle(
              color: Color(0xFF717182),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF717182)),
          items: ['Poliklinik Umum', 'Poliklinik Anak', 'Poliklinik Gigi']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => selectedPoliklinik = val),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                '📅 Pilih Tanggal',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Month Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 20),
                      onPressed: () {},
                    ),
                    const Text(
                      'April 2026',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                // Days Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                      .map((d) => Text(
                            d,
                            style: const TextStyle(
                              color: Color(0xFF717182),
                              fontSize: 12,
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Calendar Grid (Mockup based on image)
                _buildCalendarGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // This is a simplified grid to match the visual specification
    final days = [
      ['30', '31', '1', '2', '3', '4', '5'],
      ['6', '7', '8', '9', '10', '11', '12'],
      ['13', '14', '15', '16', '17', '18', '19'],
      ['20', '21', '22', '23', '24', '25', '26'],
      ['27', '28', '29', '30', '1', '2', '3'],
    ];

    return Column(
      children: days.map((week) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: week.map((day) {
            bool isSelected = day == '7' && week[1] == '7'; // Mock for April 7
            bool isCurrentMonth = !(day == '30' || day == '31' || (day == '1' || day == '2' || day == '3') && days.indexOf(week) > 2);
            
            return Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0A0A0A) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected 
                      ? Colors.white 
                      : (isCurrentMonth ? const Color(0xFF18181B) : const Color(0xFF717182).withOpacity(0.5)),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
