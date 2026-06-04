import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/rsud_provider.dart';
import 'package:majadigi_superapp_frontend/models/rsud_model.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_queue_status_screen.dart';
import 'package:majadigi_superapp_frontend/screens/rsud_ruang_inap_screen.dart';
import 'package:majadigi_superapp_frontend/services/notification_service.dart';

class RsudAmbilAntreanScreen extends StatefulWidget {
  const RsudAmbilAntreanScreen({super.key});

  @override
  State<RsudAmbilAntreanScreen> createState() => _RsudAmbilAntreanScreenState();
}

class _RsudAmbilAntreanScreenState extends State<RsudAmbilAntreanScreen> {
  String? selectedPoliklinik;
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RsudProvider>(context, listen: false).fetchPoliklinik();
    });
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF254EDB)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Memproses Antrean Anda...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Mohon tunggu sebentar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                          const SizedBox(height: 20),

                          // Ketersediaan Kamar Inap Quick Link
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF), // light blue
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bed_outlined, color: Color(0xFF2563EB)),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ingin mengecek kamar rawat inap?',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E3A8A),
                                        ),
                                      ),
                                      Text(
                                        'Periksa ketersediaan tempat tidur kosong di sini',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF1E40AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const RsudRuangInapScreen()),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Lihat',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF254EDB),
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, size: 14, color: Color(0xFF254EDB)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

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
                  if (selectedPoliklinik == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Silakan pilih poliklinik terlebih dahulu.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  _showLoadingDialog(context);

                  final provider = Provider.of<RsudProvider>(context, listen: false);
                  final selectedPoli = provider.poliklinikList.firstWhere(
                    (p) => p.nama == selectedPoliklinik,
                    orElse: () => provider.poliklinikList.isNotEmpty
                        ? provider.poliklinikList.first
                        : Poliklinik(
                            id: '3bb1b554-a5a1-7d08-7c12-5e1d58984de5',
                            nama: 'Poliklinik Umum',
                            isActive: true,
                            daftarDokter: [],
                          ),
                  );

                  String poliId = selectedPoli.id;
                  String dokterId = selectedPoli.daftarDokter.isNotEmpty 
                      ? selectedPoli.daftarDokter.first.id 
                      : '6cab51a0-a519-f377-a089-7a67b575492c';
                  String tanggal = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

                  final antrean = await provider.submitAntrean(poliId, dokterId, tanggal);
                  
                  if (context.mounted) {
                    Navigator.pop(context); // Close loading dialog
                  }

                  if (antrean != null) {
                    await NotificationService().showQueueNotification(
                      queueNumber: antrean.nomorAntrean,
                      polyclinic: antrean.poli,
                    );
                    
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RsudQueueStatusScreen()),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal mendaftar antrean. Silakan coba lagi.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
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
    return Consumer<RsudProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingPoli) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black.withOpacity(0.1)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Memuat poliklinik...', style: TextStyle(color: Color(0xFF717182), fontSize: 14)),
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
          );
        }

        final list = provider.poliklinikList.map((e) => e.nama).toList();
        if (list.isEmpty) {
          list.addAll(['Poliklinik Umum', 'Poliklinik Anak', 'Poliklinik Gigi']);
        }

        // Handle if selectedPoliklinik is not in the list anymore
        if (selectedPoliklinik != null && !list.contains(selectedPoliklinik)) {
          selectedPoliklinik = null;
        }

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
              items: list
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedPoliklinik = val),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
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
          initialDate: selectedDate,
          firstDate: selectedDate.subtract(const Duration(days: 7)),
          lastDate: selectedDate.add(const Duration(days: 180)),
          onDateChanged: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
      ),
    );
  }
}
