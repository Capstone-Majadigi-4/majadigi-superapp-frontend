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
  int _currentStep = 1; // 1: Pilih Poli, 2: Pilih Dokter
  Poliklinik? _selectedPoli;
  Dokter? _selectedDokter;
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

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getPoliEmoji(String nama) {
    final name = nama.toLowerCase();
    if (name.contains('umum') || name.contains('dalam')) return '🩺';
    if (name.contains('anak')) return '👶';
    if (name.contains('kandungan') || name.contains('kebidanan')) return '🤰';
    if (name.contains('jantung')) return '❤️';
    if (name.contains('mata')) return '👁️';
    if (name.contains('paru')) return '🫁';
    if (name.contains('saraf') || name.contains('neurologi')) return '🧠';
    if (name.contains('gigi')) return '🦷';
    if (name.contains('bedah')) return '😷';
    return '🏥';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 220,
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
                        onPressed: () {
                          if (_currentStep == 2) {
                            setState(() {
                              _currentStep = 1;
                              _selectedDokter = null;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          _currentStep == 1 ? 'Pilih Poliklinik' : 'Pilih Dokter',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to balance back button
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      child: Consumer<RsudProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoadingPoli) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0065FF)),
                              ),
                            );
                          }

                          if (provider.errorPoli != null && provider.poliklinikList.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('❌', style: TextStyle(fontSize: 40)),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Gagal memuat data poliklinik',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      provider.errorPoli!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => provider.fetchPoliklinik(),
                                      child: const Text('Coba Lagi'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }

                          final list = provider.poliklinikList;

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(24),
                            child: _currentStep == 1
                                ? _buildStep1(list)
                                : _buildStep2(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Confirmation Button (only visible in Step 2)
          if (_currentStep == 2)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _selectedDokter != null
                      ? () async {
                          _showLoadingDialog(context);

                          final provider = Provider.of<RsudProvider>(context, listen: false);
                          String poliId = _selectedPoli!.id;
                          String dokterId = _selectedDokter!.id;
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
                              Navigator.pushReplacement(
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
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF254EDB),
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Konfirmasi',
                    style: TextStyle(
                      color: _selectedDokter != null ? Colors.white : Colors.grey.shade500,
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

  Widget _buildStep1(List<Poliklinik> poliklinikList) {
    int doctorCount = 0;
    for (var p in poliklinikList) {
      doctorCount += p.daftarDokter.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Card
        _buildStatsCard(poliklinikList.length, doctorCount),
        const SizedBox(height: 24),

        // Kamar Inap Banner Quick Link
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
                      'Kamar Rawat Inap',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    Text(
                      'Periksa ketersediaan tempat tidur kosong',
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

        const Text(
          'Poliklinik Tersedia',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),

        // Poliklinik Grid
        if (poliklinikList.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Tidak ada poliklinik aktif.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: poliklinikList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final poli = poliklinikList[index];
              final emoji = _getPoliEmoji(poli.nama);
              final isAvailable = poli.isActive && poli.kuotaTersisa > 0;

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        setState(() {
                          _selectedPoli = poli;
                          _currentStep = 2;
                        });
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.white : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: isAvailable
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? const Color(0xFFEFF6FF)
                                  : const Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                            ),
                            child: Text(emoji, style: const TextStyle(fontSize: 18)),
                          ),
                          if (!isAvailable)
                            const Text(
                              'Tutup',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            poli.nama,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isAvailable ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            poli.lantai.isNotEmpty ? poli.lantai : 'Lantai 1',
                            style: TextStyle(
                              fontSize: 11,
                              color: isAvailable ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        isAvailable
                            ? 'Tersedia'
                            : 'Tidak tersedia',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isAvailable ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStep2() {
    if (_selectedPoli == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected Poli Indicator Card
        _buildSelectedPoliCard(),
        const SizedBox(height: 20),

        // Date Picker (Collapsible Section)
        _buildDateSelector(),
        const SizedBox(height: 24),

        const Text(
          'Pilih Dokter Praktek',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 16),

        _buildDoctorList(),
        const SizedBox(height: 120), // Bottom padding for confirmation button
      ],
    );
  }

  Widget _buildStatsCard(int poliCount, int doctorCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('🟢', 'Buka 24 Jam'),
          _buildStatItem('🏥', '$poliCount Poli'),
          _buildStatItem('👨‍⚕️', '$doctorCount Dokter'),
          _buildStatItem('🛏️', '174 Kamar'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String label) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPoliCard() {
    final emoji = _getPoliEmoji(_selectedPoli!.nama);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Poliklinik Terpilih',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedPoli!.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
                _selectedDokter = null;
              });
            },
            child: const Text(
              'Ubah',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0065FF),
          onPrimary: Colors.white,
          onSurface: Color(0xFF18181B),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          title: Row(
            children: [
              const Icon(Icons.calendar_month, color: Color(0xFF0065FF), size: 20),
              const SizedBox(width: 8),
              Text(
                'Tanggal Kunjungan: ${_formatDate(selectedDate)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorList() {
    final doctors = _selectedPoli!.daftarDokter;
    if (doctors.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text('👨‍⚕️', style: TextStyle(fontSize: 32)),
              SizedBox(height: 8),
              Text(
                'Tidak ada dokter praktek tersedia.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = doctors[index];
        final isSelected = _selectedDokter?.id == doc.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDokter = doc;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF0065FF) : const Color(0xFFE2E8F0),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFEFF6FF),
                  backgroundImage: doc.fotoUrl != null && doc.fotoUrl!.isNotEmpty
                      ? NetworkImage(doc.fotoUrl!)
                      : null,
                  child: doc.fotoUrl == null || doc.fotoUrl!.isEmpty
                      ? const Text('👨‍⚕️', style: TextStyle(fontSize: 22))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              doc.nama,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Tersedia',
                              style: TextStyle(
                                color: Color(0xFF059669),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doc.spesialis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: doc.jadwal.map((day) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              day[0].toUpperCase() + day.substring(1),
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
